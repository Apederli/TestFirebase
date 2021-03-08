//
//  ViewController.swift
//  TestFirebase
//
//  Created by aydoğan pederli on 2.03.2021.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwrodText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        
        
    }
    
    @IBAction func singInClicked(_ sender: Any) {
        if emailText.text != "" && passwrodText.text != nil {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwrodText.text!) { (autdata, error) in
              
                if error != nil {
                    self.makeAllert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }
    }
    
    
    @IBAction func singUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwrodText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwrodText.text!) { (authdata, error) in
                
                if error != nil {
                    self.makeAllert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            makeAllert(titleInput: "Error", messageInput: "Username-Password?")
        }
        
    }
    
    func makeAllert(titleInput:String, messageInput:String) {
        
        let alert = UIAlertController.init(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

