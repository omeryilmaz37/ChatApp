//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        let titleText = K.appName
        var charIndex = 0.0
        for letter in titleText {
//            print("-")
//            print(0.1 * charIndex)
//            print(letter)
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(charIndex), repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
//        Her bir harf titleText içindeki bir elemandır.
//        Her bir harf için bir Timer oluşturulur ve bu Timer'ın tetiklenme zamanı, o harfin sırasını belirleyen charIndex'e bağlıdır. Bu sayede her harf, bir öncekinden biraz daha sonra ekranda belirir.
//        Timer'lar, charIndex'in artan değerine bağlı olarak oluşturulur. Her bir Timer'ın tetiklenme zamanı, charIndex ile çarpılarak ayarlanır.
//        Her Timer, bir harfi ekrana eklemek için bir kapanma ifadesi (closure) kullanır. Bu ifade, her Timer tetiklendiğinde çalışır ve titleLabel'ın mevcut metnine yeni harfi ekler.
//        Bu döngü, metnin harflerini sırayla ekranda göstermek için dinamik olarak zamanlanmış bir animasyon oluşturur. Her bir harfin ekranda görünme zamanı, öncekine göre biraz daha gecikmeli olacak şekilde ayarlanır, böylece metin adım adım oluşur.
    }
    

}
