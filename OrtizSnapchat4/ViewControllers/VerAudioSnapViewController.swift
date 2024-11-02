//
//  VerAudioSnapViewController.swift
//  OrtizSnapchat4
//
//  Created by mauro on 11/1/24.
//

import UIKit
import AVFoundation
import Firebase

class VerAudioSnapViewController: UIViewController {
    
    var audioSnap: AudioSnap?
    var audioPlayer: AVAudioPlayer?
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var buttonReproducir: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Muestra el mensaje del audio
        if let audioSnap = audioSnap {
            lblMensaje.text = "Mensaje: " + audioSnap.descrip
        }
    }
    @IBAction func reproducirAudioTapped(_ sender: Any) {
        // Asegúrate de que audioSnap no sea nil
        guard let audioSnap = audioSnap else {
            print("AudioSnap es nil")
            return
        }
        // Intenta crear la URL del audio
        if let audioURL = URL(string: audioSnap.audioURL) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play() // Reproduce el audio cuando se presiona el botón
            } catch {
                print("Error al reproducir el audio: \(error.localizedDescription)")
            }
        } else {
            print("La URL del audio no es válida.")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                
        // Eliminar el audio del database
        if let audioSnap = audioSnap {
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(audioSnap.id).removeValue()
                    
            // Eliminar el archivo de audio de Storage
            Storage.storage().reference().child("audios").child("\(audioSnap.audioID).m4a").delete { (error) in
                if let error = error {
                    print("Error al eliminar el audio: \(error.localizedDescription)")
                } else {
                    print("Se eliminó el audio correctamente.")
                }
            }
        }
    }
}
