//
//  LoginVC.swift
//  DemoFirebase
//
//  Created by Shubhdeep on 2023-06-20.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class LoginVC: UIViewController {
    
    var fetchedValues: [[String : Any]] = []
    var userName: [UserData] = []
    var currentUserType = ""
    let firebaseDatabase = Database.database().reference()
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let _ = error {
                // show alert
                let alertViewController = UIAlertController(title: "Error", message: "This account already exists", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Sign in", style: .cancel, handler: { _ in
                    let altertVC = LoginVC()
                    self.navigationController!.pushViewController(altertVC, animated: true)
                })
                
                self.present(alertViewController, animated: true)
                alertViewController.addAction(action)
                
            } else {
                
                print("Login Successful")
                guard let userID = Auth.auth().currentUser?.uid else { return }
                self.getUserType(userID: userID) { [weak self] in
                    if self?.currentUserType == "Driver"{
                        
                        self?.fetchDriversUserNameList(userID: userID) { [weak self] in
                            self?.pushToListVC()
                        }
                        
                    } else if self?.currentUserType == "Customer" {
                        
                        self?.fetchCustomersUserNameList(userID: userID) { [weak self] in
                            self?.pushToListVC()
                        }
                    }
                    print(DataManager.shared.displayUsers)
                    //self.navigationController?.pushViewController(ListVC(), animated: true)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func getUserType(userID: String, completion: @escaping () -> Void) {
        firebaseDatabase.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            
            if let data = snapshot.value as? [String: String] {
                guard let userTypeValue = data["userType"] else { return }
                self.currentUserType = userTypeValue
            }
            completion()
        }
    }
    
    func fetchDriversUserNameList(userID: String, completion: @escaping () -> Void) {
        firebaseDatabase.child("userType").child("Drivers").observeSingleEvent(of: .value) { snapshot  in
            
            if let data = snapshot.value as? [String: Any] {
                let dataArray = Array(data)
                let values = dataArray.map { $0.1 } as! [[String : String]]
                for item in values {
                    if let username = item["username"]  {
                        DataManager.shared.displayUsers.append(username)
                    }
                    DataManager.shared.displayUsers.sort()
                }
            }
            completion()
        }
        
    }
    
    func fetchCustomersUserNameList(userID: String, completion: @escaping () -> Void) {
        firebaseDatabase.child("userType").child("Customers").observeSingleEvent(of: .value) { snapshot  in
            
            if let data = snapshot.value as? [String: Any] {
                let dataArray = Array(data)
                let values = dataArray.map { $0.1 } as! [[String : String]]
                for item in values {
                    if let username = item["username"]  {
                        DataManager.shared.displayUsers.append(username)
                    }
                    DataManager.shared.displayUsers.sort()
                }
            }
            completion()
        }
    }
    
    func pushToListVC() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(ListVC(), animated: true)
        }
    }
}


