// Firestore'dan veri almak ve kullanmak için gerekli kütüphaneleri içe aktar
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import IQKeyboardManagerSwift

// ChatViewController sınıfını tanımla ve UIViewController sınıfından türet
class ChatViewController: UIViewController {

    // IBOutlet ile TableView ve TextField bağlantılarını tanımla
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    // Firestore veritabanına erişmek için bir referans oluştur
    let db = Firestore.firestore()
    
    // Mesajları saklamak için bir dizi oluştur
    var messages: [Message] = []
    
    // ViewController yüklendiğinde çağrılan metod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView'in veri kaynağı olarak self'i ayarla
        tableView.dataSource = self
        
        // Ekran başlığını ve navigasyon ayarlarını ayarla
        title = K.appName
        navigationItem.hidesBackButton = true
        
        // Özel hücrenin NIB'ini (XIB) TableView'e kaydet
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        // Firestore'dan mesajları yükle
        loadMessages()
    }
    
    // Firestore'dan mesajları yüklemek için bir metod tanımla
    func loadMessages() {
        // Firestore koleksiyonundan veri al, tarih alanına göre sırala ve değişikliklerin anlık olarak izlenmesi için bir dinleyici ekleyerek verileri getir
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField) // Verileri tarih alanına göre sırala
            .addSnapshotListener { (querySnapshot, error) in // Anlık olarak veri değişikliklerini izle
                self.messages = [] // Mevcut mesajları temizle
                // Hata kontrolü
                if let error = error {
                    // Hata varsa konsola yazdır
                    print("Firestore'dan veri alınırken sorun yaşandı: \(error)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        // Firestore'dan gelen belgeleri döngüye al
                        for doc in snapshotDocuments {
                            // Her bir belgenin verilerini al
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String, // Gönderenin adını al
                               let messageBody = data[K.FStore.bodyField] as? String { // Mesaj içeriğini al
                                // Yeni bir mesaj oluştur
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                // Mesajı diziye ekle
                                self.messages.append(newMessage)
                                
                                // Tabloyu güncelle ve en son mesaja kaydır
                                DispatchQueue.main.async {
                                    self.tableView.reloadData() // Tabloyu yeniden yükle
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0) // En son mesajın indeksini al
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) // Tabloyu en son mesaja kaydır
                                }
                            }
                        }
                    }
                }
            }
    }

    // "Gönder" butonuna basıldığında çağrılan metod
    @IBAction func sendPressed(_ sender: UIButton) {
        // Mesaj gövdesini ve göndereni al
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            // Firestore'a mesajı ekle
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender, // Gönderen alanını belirt
                K.FStore.bodyField: messageBody, // Mesaj gövdesini belirt
                K.FStore.dateField: Date().timeIntervalSince1970 // Mesajın gönderilme zamanını belirt
            ]) { (error) in
                // Hata kontrolü
                if let error = error {
                    // Hata varsa konsola yazdır
                    print("Firestore'a veri kaydederken bir sorun oluştu: \(error)")
                } else {
                    // Başarı mesajını konsola yazdır
                    print("Veriler başarıyla kaydedildi.")
                    // TextField'i temizle
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }

    // "Çıkış Yap" butonuna basıldığında çağrılan metod
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            // Firebase Authentication'dan çıkış yap
            try Auth.auth().signOut()
            // Kullanıcıyı başlangıç ​​görünümüne geri yönlendir
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

// TableView'in veri kaynağını sağlamak için UITableViewDataSource protokolünü uygula
extension ChatViewController: UITableViewDataSource {
    // TableView'da kaç satır olduğunu belirlemek için metod
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // TableView'da hücreleri yapılandırmak için metod
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        // Mesajın göndereninin mevcut kullanıcı olduğunu kontrol et
        if message.sender == Auth.auth().currentUser?.email {
            // Eğer mesaj mevcut kullanıcı tarafından gönderildiyse:
            // Sol imageView'i gizle (gelen mesajları göstermek için)
            cell.leftImageView.isHidden = true
            // Sağ imageView'i göster (kullanıcının kendi mesajlarını göstermek için)
            cell.rightImageView.isHidden = false
            // Mesaj balonunun arka plan rengini ayarla (kullanıcının kendi mesajlarını göstermek için)
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            // Mesaj metninin rengini ayarla (kullanıcının kendi mesajlarını göstermek için)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            // Eğer mesaj mevcut kullanıcı tarafından gönderilmediyse:
            // Sol imageView'i göster (kullanıcının dışındaki kişilerin mesajlarını göstermek için)
            cell.leftImageView.isHidden = false
            // Sağ imageView'i gizle (gelen mesajları göstermek için)
            cell.rightImageView.isHidden = true
            // Mesaj balonunun arka plan rengini ayarla (kullanıcının dışındaki kişilerin mesajlarını göstermek için)
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            // Mesaj metninin rengini ayarla (kullanıcının dışındaki kişilerin mesajlarını göstermek için)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
}
