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
            if error != nil {
                print("Se presentó el siguiente error: \(error)")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("Intentando crear un usuario")
                    if error != nil {
                        print("Se presentó el siguiente error al crear el usuario: \(error)")
                    } else {
                        print("El usuario fue creado exitosamente")
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
                })
            } else {
                print("Inicio de Sesión Exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
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

