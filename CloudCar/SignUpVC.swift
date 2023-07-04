
import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpVC: UIViewController {
    
    let firebaseDatabase = Database.database().reference()
    var allUsers = [UserModel]()
    var userUidFetched = ""
    
    @IBOutlet var userNameTextField : UITextField!
    @IBOutlet var emailTextField : UITextField!
    @IBOutlet var passwordTextField : UITextField!
    @IBOutlet weak var myUserSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let username = userNameTextField.text ?? ""
        let user = myUserSwitch.isOn ? "Customer" : "Driver"
        
        Auth.auth().createUser(withEmail: email, password: password) {firebaseResult, error in
            
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
                print("Account created")
                guard let userUid = firebaseResult?.user.uid else { return }
                self.userUidFetched = userUid
                self.createUserData(username: username, email: email, userType: user, userID: userUid)
                self.userTypeData(userType: user, userId: userUid, username: username)
                self.readData()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewControllerToPush = storyboard.instantiateViewController(withIdentifier: "signUpSuccessful")
                self.navigationController?.pushViewController(viewControllerToPush, animated: true)
            }
        }
    }
    
    func createUserData(username: String, email: String, userType: String, userID: String){
        
        let userData = [
            "username" : username,
            "email" : email,
            "userType" : userType,
//            "lat" : 123,
//            "long" : 1234
        ]
        
        let allUsersRef = firebaseDatabase.child("users")
        let userReferenceWithUid = allUsersRef.child(userID)
        
        userReferenceWithUid.setValue(userData) { (error, _) in
            if let _ = error {
                print("Error uploading user data")
            } else {
                print("User data uploaded successfully")
            }
        }
    }
    
    func userTypeData(userType: String, userId: String, username: String){
        
        if userType == "Driver" {
            
            let driverData =  [
                "username": username
            ]
            
            let allDriversRef = firebaseDatabase.child("userType").child("Drivers").child(userUidFetched)
            allDriversRef.setValue(driverData) { (error, _) in
                if let _ = error {
                    print("Error uploading driver profile")
                } else {
                    print("Uploaded Driver profile")
                }
            }
        }
        
        if userType == "Customer" {
            
            let CustomerData =  [
                "username" : username
            ]
            
            let allCustomersRef = firebaseDatabase.child("userType").child("Customers").child(userUidFetched)
            allCustomersRef.setValue(CustomerData) { (error, _) in
                if let _ = error {
                    print("Error Uploading Customer profile")
                } else {
                    print("Customer uploaded successfully")
                }
            }
        }
    }
    
    func readData(){
        firebaseDatabase.child("userType").child("Drivers").observeSingleEvent(of: .value) { snapshot in
          
            if let data = snapshot.value as? [String: Any] {
                        let dataArray = Array(data)
                        let keys = dataArray.map { $0.0 }
                        let values = dataArray.map { $0.1 }
                        print(keys)
                        print(values)
                    }
        }
    }
}

