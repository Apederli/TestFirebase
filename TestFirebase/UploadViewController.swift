//
//  UploadViewController.swift
//  TestFirebase
//
//  Created by aydoğan pederli on 3.03.2021.
//

import UIKit

import Firebase


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var commetText: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:    nil)
        
        alert.addAction(button)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
         
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            let fireStoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference?
                            
                            let firestorePost = ["imageUrl" : imageUrl! , "postedBy" : Auth.auth().currentUser!.email as Any , "postCommet" : self.commetText.text!, "date" : FieldValue.serverTimestamp() , "liekes" : 0 ] as [String : Any]
                            
                            firestoreReference = fireStoreDatabase.collection("Post").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                }else{
                                    
                                    self.imageView.image = UIImage(named: "select.jpg")
                                    
                                    self.commetText.text = ""
                                    
                                    self.tabBarController!.selectedIndex = 0
                                }
                            })
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    
    
}
