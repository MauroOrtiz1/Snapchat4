//
//  ElegirUsuario2ViewController.swift
//  OrtizSnapchat4
//
//  Created by mauro on 11/1/24.
//

import UIKit
import Firebase

class ElegirUsuario2ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]
        // Crear el "snap" de audio con los datos correspondientes
        guard let audioURL = audioURL, let audioID = audioID else {
            mostrarAlerta(titulo: "Error", mensaje: "Falta información del audio.", accion: "Aceptar")
            return
        }
        let snap = ["from": Auth.auth().currentUser?.email ?? "","descripcion": audioTitle ?? "","audioURL": audioURL,"audioID": audioID
        ]
        // Guardar el snap en la base de datos de Firebase
        Database.database().reference().child("usuarios").child(usuario.uid).child("snapsaudio").childByAutoId().setValue(snap)
            
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var listaUsuarios: UITableView!
    var usuarios: [Usuario] = []
    // Variables que se recibirán de AudioSnapViewController
    var audioTitle: String?
    var audioURL: String?
    var audioID: String?
    var selectedContactID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
                
        // Cargar usuarios desde Firebase
        Database.database().reference().child("usuarios").observe(.childAdded, with: { snapshot in
            guard let value = snapshot.value as? [String: Any],
                    let email = value["email"] as? String else { return }
            
            let usuario = Usuario()
            usuario.email = email
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
        })
    }
    // Método para mostrar alertas de error
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
}
