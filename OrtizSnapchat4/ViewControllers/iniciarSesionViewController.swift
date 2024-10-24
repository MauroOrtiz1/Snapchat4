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
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Campos incompletos")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error al iniciar sesión: \(error.localizedDescription)")

                // Mostrar alerta con opciones Crear o Cancelar
                let alerta = UIAlertController(title: "Usuario no encontrado", message: "¿Deseas crear una nueva cuenta?", preferredStyle: .alert)
                let crearAction = UIAlertAction(title: "Crear", style: .default) { _ in
                    // Navegar a la pantalla de creación de usuarios
                    self.performSegue(withIdentifier: "mostrarCrearUsuarioSegue", sender: nil)
                }
                let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                        
                alerta.addAction(crearAction)
                alerta.addAction(cancelarAction)
                self.present(alerta, animated: true, completion: nil)

            } else {
                print("Inicio de sesión exitoso")
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

