//
// WelcomeViewController.swift
// Flash Sohbet iOS13
//
// Angela Yu tarafından 21/10/2019 tarihinde oluşturuldu.
// Telif hakkı © 2019 Angela Yu. Tüm hakları saklıdır.
//

import UIKit

class WelcomeViewController: UIViewController {

    // titleLabel adında bir UILabel'in IBOutlet bağlantısı
    @IBOutlet weak var titleLabel: UILabel!

    // ViewController görünmeden hemen önce çağrılır
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigasyon çubuğunu gizler
        navigationController?.isNavigationBarHidden = true
    }

    // ViewController kaybolmadan hemen önce çağrılır
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Navigasyon çubuğunu tekrar görünür hale getirir
        navigationController?.isNavigationBarHidden = false
    }

    // ViewController yüklendiğinde çağrılır
    override func viewDidLoad() {
        super.viewDidLoad()

        // titleLabel metnini boş bir string olarak ayarla
        titleLabel.text = ""

        // Gösterilecek uygulama adı
        let titleText = K.appName

        // Harflerin sırayla ekranda görünmesi için bir başlangıç indeksi
        var charIndex = 0.0

        // titleText içindeki her bir harf için döngü
        for letter in titleText {
            // Her harf için bir zamanlayıcı oluştur
            Timer.scheduledTimer(withTimeInterval: 0.2 * Double(charIndex), repeats: false) { (timer) in
                // titleLabel'a harfi ekle
                self.titleLabel.text?.append(letter)
            }
            // Her harf için indeks artırılır
            charIndex += 1
        }

        // Bu döngü, titleText'in içindeki her harf için bir Timer oluşturur.
        // Her bir harfin ekranda görünme zamanı, o harfin sırasını belirleyen charIndex'e bağlıdır.
        // Bu sayede harfler, ekranda sırayla ve belirli bir gecikmeyle görünür.
    }
}
