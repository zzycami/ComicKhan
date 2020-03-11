//
//  InfoVC.swift
//  wutComicReader
//
//  Created by Sha Yan on 3/7/20.
//  Copyright © 2020 wutup. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class InfoVC: UITableViewController {
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
                 let email = MFMailComposeViewController()
                 email.mailComposeDelegate = self
                 email.setToRecipients(["wuttupdev@yahoo.com"])
                 
                 present(email, animated: true)
             }
        
    }
    
    @IBAction func twitterButtonTapped(_ sender: Any) {
        guard let url = URL(string: "https://twitter.com/shaysu6g") else { return }
        UIApplication.shared.open(url)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupDesign()
    }
    
    func setupDesign(){
        let twitterImage = UIImage(named: "twitter")?.withRenderingMode(.alwaysTemplate)
        twitterButton.setImage(twitterImage, for: .normal)
        
        let emailImage = UIImage(named: "email")?.withRenderingMode(.alwaysTemplate)
        emailButton.setImage(emailImage, for: .normal)
        
        navigationController?.navigationBar.tintColor = .appBlueColor
        
        
    }
}

extension InfoVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
