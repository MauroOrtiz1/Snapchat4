//
//  ElegirUsuarioViewController.swift
//  OrtizSnapchat4
//
//  Created by Bernie Mauro Ortiz Ortega on 23/10/24.
//

import UIKit
import Firebase

class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    

    @IBOutlet weak var listaUsuarios: UITableView!
    var usuarios:[Usuario] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            
            let usuario = Usuario()
            usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
        })
    }
}
