//
//  ViewController.swift
//  OrtizSnapchat4
//
//  Created by mauro on 10/19/24.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
            print("Intentando Iniciar Sesion")
            if error != nil{
                print("Se presento el siguiente error: \(error)")
            }else{
                print("Inicio se sesion exitoso")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func googleSignInTapped(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            if let error = error {
                print("Error al iniciar sesión con Google: \(error.localizedDescription)")
                return
            }
            guard let authentication = user?.authentication else {
                print("No se obtuvo autenticación de Google")
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!, accessToken: authentication.accessToken)
            // Iniciar sesión con Firebase usando el credential
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error al autenticar con Firebase: \(error.localizedDescription)")
                    return
                }
                print("Inicio de sesión exitoso con Google")
                // Navegar a la siguiente pantalla
            }
        }
    }
}

