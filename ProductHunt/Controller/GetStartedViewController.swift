//
//  GetStartedViewController.swift
//  ProductHunt
//
//  Created by Apple on 07/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController{

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnGetStarted_Click(sender: UIButton)
    {
       self.navigateToHome()
    }
    
    func navigateToHome()
    {
        let homeVC: UINavigationController = self.storyboard!.instantiateViewController(withIdentifier: IdentifierNavigationVC) as! UINavigationController
        self.present(homeVC, animated: true, completion: nil)
    }
}
