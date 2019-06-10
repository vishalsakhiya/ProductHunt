//
//  NewsFeedDetailViewController.swift
//  ProductHunt
//
//  Created by Apple on 08/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class NewsFeedDetailViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    //UI variable
    var commentArray:NSMutableArray = NSMutableArray()
    @IBOutlet weak var commentCollectionView:UICollectionView!
    @IBOutlet weak var lblTodayDate:UILabel!
    @IBOutlet weak var lblTodayTime:UILabel!
    @IBOutlet weak var lblPostName:UILabel!
    @IBOutlet weak var lblPostTagline:UILabel!
    @IBOutlet weak var imgPost:UIImageView!
    var objNewsfeed: NewsFeedModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lblTodayDate.text = Date().shortDate
        self.lblTodayTime.text = Date().shortTime
        if objNewsfeed != nil
        {
            self.lblPostName.text = objNewsfeed.postName
            self.lblPostTagline.text = objNewsfeed.postTagline
            
            Alamofire.request(objNewsfeed.postImageUrl, method: .get)
                .validate()
                .responseData(completionHandler: { (responseData) in
                    let userImage = UIImage(data: responseData.data!)
                    DispatchQueue.main.async {
                        // Refresh imageView
                        self.imgPost.image = userImage
                    }
                })
            self.GetCommentOfPost(postId: objNewsfeed.postId)
        }
    }
    
    func GetCommentOfPost(postId:Double){
        let url = URL(string: "\(BaseUrl)\(GetCommentOfPostEndPoint)?search[post_id]=\(postId)&order=desc")
        let headerParameters: [String: String] = ["Accept" : "application/json","Content-Type" : "application/json","Authorization" : "Bearer \(AccessToken)","Host" : "api.producthunt.com"]
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headerParameters).responseJSON{response in
            if let values = response.result.value {
                print("Comments JSON :\n \(values)")
                let responseDict = values as! NSDictionary
                let commentsDict = responseDict.object(forKey: "comments") as! NSArray
                
                if commentsDict.count > 0
                {
                    for item in commentsDict
                    {
                        let itemDict = (item as AnyObject) as! NSDictionary
                        let objComment:CommentModel = CommentModel()
                        objComment.txtViewDescription = itemDict.value(forKey: "body") as? String
                        if let media =  itemDict.value(forKey: "user") as? NSDictionary
                        {
                            if let profilePicDict = media.value(forKey: "image_url") as? NSDictionary
                            {
                                objComment.userProfileImageUrl = profilePicDict.value(forKey: "100px") as? String
                            }
                            objComment.userName = media.value(forKey: "name") as? String
                        }
                        else{
                            objComment.userProfileImageUrl = ImageNotFound
                        }
                        self.commentArray.add(objComment)
                    }
                }
                self.commentCollectionView.reloadData()
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 3
        return commentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath) as! CommentCollectionViewCell
        //rounder corners
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.shadowOpacity = 0.20
        cell.layer.shadowRadius = 4
        cell.userProfilePic.layer.cornerRadius = cell.userProfilePic.frame.height/2
        cell.userProfilePic.layer.masksToBounds = true
        
        let objComment = commentArray.object(at: indexPath.row) as! CommentModel
        cell.lblUserName.text = objComment.userName
        cell.txtViewDescription.text = objComment.txtViewDescription
        
        //Download Image
        if objComment.userProfileImageUrl != ImageNotFound
        {
            if  objComment.userProfileImage == nil
            {
                Alamofire.request(objComment.userProfileImageUrl, method: .get)
                    .validate()
                    .responseData(completionHandler: { (responseData) in
                        let userImage = UIImage(data: responseData.data!)
                        DispatchQueue.main.async {
                            // Refresh imageView
                            cell.userProfilePic.image = userImage
                            objComment.userProfileImage = userImage
                        }
                    })
            }else{
                cell.userProfilePic.image = objComment.userProfileImage
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    @IBAction func btnBack_Click(sender: UIBarButtonItem)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
