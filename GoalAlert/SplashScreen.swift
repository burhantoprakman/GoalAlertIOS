//
//  ViewController.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 04/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit
import OneSignal

class SplashScreen: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    var aa : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        logo.alpha = 0
        logo.fadeInn(completion: {
            (finished: Bool) -> Void in
            
            self.goMain()
        })
     
  
    }
    func goMain(){
        
         self.performSegue(withIdentifier: "golive", sender: self)
            }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "golive") {
            
            _ = segue.destination as! UITabBarController
            
        }
        
    }
    
}
extension UIView{
    func fadeInn(_ duration: TimeInterval = 2.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 100.0
        }, completion: completion)  }
    
    func fadeOutt(_ duration: TimeInterval = 5.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

