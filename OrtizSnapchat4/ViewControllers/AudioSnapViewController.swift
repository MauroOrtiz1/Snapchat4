//
//  AudioSnapViewController.swift
//  OrtizSnapchat4
//
//  Created by mauro on 10/31/24.
//

import UIKit
import AVFoundation
import FirebaseStorage
import FirebaseDatabase

class AudioSnapViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var selectContactButton: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    var audioURL: URL?
    var audioID = NSUUID().uuidString
    var selectedContactID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudioRecorder()
        selectContactButton.isEnabled = false
    }				
    @IBAction func recordAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            audioRecorder?.record()
            recordButton.setTitle("Detener Grabación", for: .normal)
            } else {
            audioRecorder?.stop()
            recordButton.setTitle("Iniciar Grabación", for: .normal)
            selectContactButton.isEnabled = true // Habilitar el botón de seleccionar contacto
        }
    }
    @IBAction func selectContactTapped(_ sender: Any) {
        guard let audioURL = audioURL else {
            mostrarAlerta(titulo: "Error", mensaje: "No se encontró el archivo de audio.", accion: "Aceptar")
            return
        }
        do {
            let audioData = try Data(contentsOf: audioURL)
            selectContactButton.isEnabled = false
            let audiosFolder = Storage.storage().reference().child("audios")
            let uploadAudio = audiosFolder.child("\(audioID).m4a")
                    
            uploadAudio.putData(audioData, metadata: nil) { (metadata, error) in
                if let error = error {
                    self.mostrarAlerta(titulo: "Error", mensaje: "Error al subir el audio. Intente nuevamente.", accion: "Aceptar")
                    self.selectContactButton.isEnabled = true
                    print("Ocurrió un error al subir el audio: \(error)")
                } else {
                    uploadAudio.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            self.mostrarAlerta(titulo: "Error", mensaje: "Error al obtener la URL del audio.", accion: "Aceptar")
                            self.selectContactButton.isEnabled = true
                            print("Ocurrió un error al obtener la URL del audio: \(error!)")
                            return
                        }
                        // Pasa la URL del audio a la siguiente pantalla
                        self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: downloadURL.absoluteString)
                    }
                }
            }
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo cargar el audio.", accion: "Aceptar")
        }
    }
    func setupAudioRecorder() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            audioURL = paths[0].appendingPathComponent("audioSnap.m4a")
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.prepareToRecord()
            
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo configurar el grabador de audio.", accion: "Aceptar")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seleccionarContactoSegue" {
            let elegirUsuarioVC = segue.destination as! ElegirUsuario2ViewController
            elegirUsuarioVC.audioTitle = titleTextField.text ?? "" // Pasa el título del audio
            elegirUsuarioVC.audioID = audioID // Pasa el ID del audio
            elegirUsuarioVC.audioURL = (sender as? String) ?? audioURL?.absoluteString ?? "" // Asegura que sea String
            elegirUsuarioVC.selectedContactID = selectedContactID // Pasa el ID del contacto seleccionado
        }
    }
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
}
