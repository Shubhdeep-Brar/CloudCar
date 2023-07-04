//
//  DataManager.swift
//  DemoFirebase
//
//  Created by Shubhdeep on 2023-06-27.
//

import Foundation
import FirebaseDatabase

class DataManager {
    
    static let shared = DataManager()
    var data: String? = ""
    var displayUsers: [String] = []

    
    let firebaseReference = Database.database().reference()
    
    private init() {}
}
