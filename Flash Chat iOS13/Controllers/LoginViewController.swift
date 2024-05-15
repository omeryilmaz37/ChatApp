//
// LoginViewController.swift
// Flash Chat iOS13
//
// Created by Angela Yu on 21/10/2019.
// Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController {

    // Email ve şifre girişi için IBOutlet bağlantıları
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    // Giriş butonuna basıldığında çağrılan IBAction
    @IBAction func loginPressed(_ sender: UIButton) {
        // Email ve şifre alanlarının boş olmadığını kontrol et
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            // Firebase Auth kullanarak kullanıcı giriş yap
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                // Eğer hata varsa, hata mesajını yazdır
                if let hata = error {
                    print(hata.localizedDescription)
                } else {
                    // Giriş başarılıysa, belirli bir segue'yi gerçekleştir
                    self.performSegue(withIdentifier: K.loginSegue, sender: nil)
                }
            }
        }
    }
}
