//
//  SnapsViewController.swift
//  OrtizSnapchat4
//
//  Created by mauro on 10/23/24.
//

import UIKit
import Firebase

class SnapsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.isEmpty && audioSnaps.isEmpty {
            return 1
        } else {
            return snaps.count + audioSnaps.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
                
                // Determina si se debe mostrar un Snap o un AudioSnap
                if snaps.isEmpty && audioSnaps.isEmpty {
                    cell.textLabel?.text = "No tienes Snaps ni Audios 😭"
                } else if indexPath.row < snaps.count {
                    let snap = snaps[indexPath.row]
                    cell.textLabel?.text = snap.from // Nombre del remitente del Snap
                } else {
                    let audioSnap = audioSnaps[indexPath.row - snaps.count]
                    cell.textLabel?.text = audioSnap.from // Nombre del remitente del AudioSnap
                }
                return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < snaps.count {
                    let snap = snaps[indexPath.row]
                    performSegue(withIdentifier: "versnapsegue", sender: snap)
                } else {
                    let audioSnap = audioSnaps[indexPath.row - snaps.count]
                    performSegue(withIdentifier: "veraudiosnapsegue", sender: audioSnap) // Nueva segue para AudioSnap
                }
    }

    @IBOutlet weak var tablaSnaps: UITableView!
    var snaps:[Snap] = []
    var audioSnaps: [AudioSnap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        // Cargar snaps de imágenes
        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snaps").observe(.childAdded, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any],
                let imagenURL = data["imagenURL"] as? String {
                let snap = Snap()
                snap.imagenURL = imagenURL
                snap.from = data["from"] as? String ?? ""
                snap.descrip = data["descripcion"] as? String ?? ""
                snap.id = snapshot.key
                snap.imagenID = data["imagenID"] as? String ?? ""
                self.snaps.append(snap)
                self.tablaSnaps.reloadData()
            }
        })
        // Cargar snaps de audio
        Database.database().reference().child("usuarios").child(Auth.auth().currentUser!.uid).child("snapsaudio").observe(.childAdded, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any],
                let audioID = data["audioID"] as? String {
                let audioSnap = AudioSnap()
                audioSnap.audioID = audioID
                audioSnap.from = data["from"] as? String ?? ""
                audioSnap.descrip = data["descripcion"] as? String ?? ""
                audioSnap.id = snapshot.key
                self.audioSnaps.append(audioSnap)
                self.tablaSnaps.reloadData()
            }
        })
    }
    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versnapsegue" {
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        } else if segue.identifier == "veraudiosnapsegue" {
            let siguienteVC = segue.destination as! VerAudioSnapViewController
            siguienteVC.audioSnap = sender as! AudioSnap // Asigna el AudioSnap
        }
    }
}
