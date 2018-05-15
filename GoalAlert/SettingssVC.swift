//
//  SettingsVC.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 19/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Social

class SettingssVC : UITableViewController,UIDocumentInteractionControllerDelegate {
    @IBOutlet var vibrationLabel: UILabel!
    @IBOutlet var goalAlertMessage: UILabel!
    @IBOutlet var instaImage: UIImageView!
    @IBOutlet var twitImage: UIImageView!
    @IBOutlet var wpImage: UIImageView!
    var documentController: UIDocumentInteractionController!
    @IBOutlet var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    
    @IBAction func vibrationButton(_ sender: Any) {
    }
    @IBAction func goalAlertButton(_ sender: Any) {
    }
    @IBAction func userAggrementClicked(_ sender: Any) {
        let msg = NSLocalizedString("privacy", comment: "")
        let alert = UIAlertController(title: "Goal Alert Privacy", message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
   
    
    @IBAction func sendWhatsapp(_ sender: Any) {
        
        let msg = "APP STORE LINK"
        let urlWhats = "whatsapp://send?text=\(msg)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.openURL(whatsappURL as URL)
                } else {
                    print("please install watsapp")
                }
            }
        }
    }
    @IBAction func sendTwitter(_ sender: Any) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let tweetShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            if let tweetShare = tweetShare {
                tweetShare.setInitialText("Goal Alert")
                tweetShare.add(UIImage(named: "stor.png")!)
                tweetShare.add(URL(string: "APP STORE LINK"))
                self.present(tweetShare, animated: true, completion: nil)
            }
        } else {
            print("Not Available")
        }
        
    }
    @IBAction func sendInstagram(_ sender: Any) {
        DispatchQueue.main.async {
            
            //Share To Instagram:
            
            let instagramURL = URL(string: "instagram://app")
            
            if UIApplication.shared.canOpenURL(instagramURL!) {
                var img : UIImage = UIImage(named: "stor.png")!
                let imageData = UIImageJPEGRepresentation(img, 100)
                
                let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
                
                do {
                    try imageData?.write(to: URL(fileURLWithPath: writePath), options: .atomic)
                    
                } catch {
                    
                    print(error)
                }
                
                let fileURL = URL(fileURLWithPath: writePath)
                
                self.documentController = UIDocumentInteractionController(url: fileURL)
                self.documentController.delegate = self
                self.documentController.uti = "com.instagram.exlusivegram"
                self.documentController.presentOpenInMenu(from: self.view.bounds, in: self.view, animated: true)
            
                }
    
        else{print(" Instagram is not installed ")}
        }

        
    }
  
   
    
    
    
}
