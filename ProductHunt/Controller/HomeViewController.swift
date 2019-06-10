//
//  ViewController.swift
//  ProductHunt
//
//  Created by Apple on 07/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    //UI variable
    var postArray:NSMutableArray = NSMutableArray()
    @IBOutlet weak var newsFeedCollectionView:UICollectionView!
    @IBOutlet weak var lblTodayDate:UILabel!
    @IBOutlet weak var lblTodayTime:UILabel!
    @IBOutlet weak var loadingView:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.loadingView.isHidden = false
        self.GetTodayPost()
        self.lblTodayDate.text = Date().shortDate
        self.lblTodayTime.text = Date().shortTime
    }

    func GetTodayPost(){
        let url = URL(string: "\(BaseUrl)\(GetTodayPostEndPoint)")
        let headerParameters: [String: String] = ["Accept" : "application/json","Content-Type" : "application/json","Authorization" : "Bearer \(AccessToken)","Host" : "api.producthunt.com"]
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headerParameters).responseJSON{response in
            if let values = response.result.value {
                print("JSON :\n \(values)")
                let responseDict = values as! NSDictionary
                 let postDict = responseDict.object(forKey: "posts") as! NSArray
                
                if postDict.count > 0
                {
                    for item in postDict
                    {
                        let itemDict = (item as AnyObject) as! NSDictionary
                        let objNewsFeed:NewsFeedModel = NewsFeedModel()
                        objNewsFeed.postId = itemDict.value(forKey: "id") as? Double
                        objNewsFeed.postName = itemDict.value(forKey: "name") as? String
                        objNewsFeed.postTagline = itemDict.value(forKey: "tagline") as? String
                        objNewsFeed.voteCount = itemDict.value(forKey: "votes_count") as? Int
                        objNewsFeed.commentCount = itemDict.value(forKey: "comments_count") as? Int
                       if let media =  itemDict.value(forKey: "thumbnail") as? NSDictionary
                       {
                          objNewsFeed.postImageUrl = media.value(forKey: "image_url") as? String
                       }
                       else{
                          objNewsFeed.postImageUrl = ImageNotFound
                       }
                      self.postArray.add(objNewsFeed)
                    }
                }
                self.newsFeedCollectionView.reloadData()
                self.loadingView.isHidden = true
            }
            self.loadingView.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsFeedCell", for: indexPath) as! NewsFeedCollectionViewCell
        //rounder corners
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 2, height: 2)
        cell.layer.shadowOpacity = 0.20
        cell.layer.shadowRadius = 4

        cell.btnVoteCount.layer.borderWidth = 1
        cell.btnVoteCount.layer.borderColor = UIColor.lightGray.cgColor
        cell.btnCommentCount.layer.borderWidth = 1
        cell.btnCommentCount.layer.borderColor = UIColor.lightGray.cgColor
    
        let objNews = postArray.object(at: indexPath.row) as! NewsFeedModel
        cell.lblPostName.text = objNews.postName
        cell.lblPostTagline.text = objNews.postTagline
        cell.txtViewDescription.text = objNews.postTagline
        cell.btnVoteCount.titleLabel?.text = String(objNews.voteCount)
        cell.btnCommentCount.titleLabel?.text = String(objNews.commentCount)
        
        //Download Image
        if objNews.postImageUrl != ImageNotFound
        {
            if objNews.postImage == nil
            {
                Alamofire.request(objNews.postImageUrl, method: .get)
                    .validate()
                    .responseData(completionHandler: { (responseData) in
                        let postImage = UIImage(data: responseData.data!)
                        DispatchQueue.main.async {
                            // Refresh imageView
                            cell.imgPost.image = postImage
                            objNews.postImage = postImage
                        }
                    })
               
            }else{
                cell.imgPost.image = objNews.postImage
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newsFeedDetailVC: NewsFeedDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: IdentifierNewsFeedDetailVC) as! NewsFeedDetailViewController
        newsFeedDetailVC.objNewsfeed = postArray.object(at: indexPath.row) as! NewsFeedModel
        self.navigationController?.pushViewController(newsFeedDetailVC, animated: true)
    }
    
}

