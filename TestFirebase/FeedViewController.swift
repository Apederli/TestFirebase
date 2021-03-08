//
//  FeedViewController.swift
//  TestFirebase
//
//  Created by aydoğan pederli on 3.03.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userEmailArray = [String]()
    
    var userCommentArray = [String]()
    
    var likeArray = [Int]()
    
    var imageArray = [String]()
    
    var documentIdArray = [String]()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        getDataFromFirebase()
    }
    
    func getDataFromFirebase()
    {
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Post").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print("error")
            }else{
                if snapshot?.isEmpty != true {
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    self.imageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        
                        self.documentIdArray.append(document.documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postCommet") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        
                        if let likes = document.get("liekes")as? Int{
                            self.likeArray.append(likes)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.imageArray.append(imageUrl)
                        }
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.commetLabel.text = userCommentArray[indexPath.row]
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.userImageView.sd_setImage(with: URL(string: self.imageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        //cell.userImageView.image = UIImage(data: <#T##Data#>)?.resizeImage(targetSize: CGSize(width: UIScreen.main.bounds.size.width - 16, height: 200))
        return cell
    }
    
    
}

