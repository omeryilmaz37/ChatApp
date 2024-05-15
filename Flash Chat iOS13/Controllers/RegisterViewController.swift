//
// RegisterViewController.swift
// Flash Chat iOS13
//
// Created by Angela Yu on 21/10/2019.
// Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class RegisterViewController: UIViewController {

    // Email ve şifre girişi için IBOutlet bağlantıları
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    // Kayıt ol butonuna basıldığında çağrılan IBAction
    @IBAction func registerPressed(_ sender: UIButton) {
        // Email ve şifre alanlarının boş olmadığını kontrol et
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            // Firebase Auth kullanarak yeni kullanıcı oluştur
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                // Eğer hata varsa, hata mesajını yazdır
                if let hata = error {
                    print(hata.localizedDescription)
                } else {
                    // Kayıt başarılıysa, belirli bir segue'yi gerçekleştir
                    self.performSegue(withIdentifier: K.registerSegue, sender: nil)
                }
            }
        }
    }
    
}
