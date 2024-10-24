//
//  CrearUsuarioViewController.swift
//  OrtizSnapchat4
//
//  Created by mauro on 10/24/24.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CrearUsuarioViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func registrarUsuarioTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Campos incompletos")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error al crear el usuario: \(error.localizedDescription)")
            } else {
                guard let uid = authResult?.user.uid else { return }
                Database.database().reference().child("usuarios").child(uid).child("email").setValue(email)
                print("Usuario creado exitosamente")
                // Navegar a la siguiente pantalla
                self.performSegue(withIdentifier: "registroCompletoSegue", sender: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
