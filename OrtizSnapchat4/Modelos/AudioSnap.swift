//
//  AudioSnap.swift
//  OrtizSnapchat4
//
//  Created by mauro on 11/1/24.
//

import Foundation

class AudioSnap {
    var audioURL: String
    var descrip: String
    var from: String
    var id: String
    var audioID: String
    
    init(audioURL: String = "", descrip: String = "", from: String = "", id: String = "", audioID: String = "") {
        self.audioURL = audioURL
        self.descrip = descrip
        self.from = from
        self.id = id
        self.audioID = audioID
    }
}
