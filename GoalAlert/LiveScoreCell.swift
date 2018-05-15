//
//  LiveScoreCell.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 06/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Toaster
import AVKit

 protocol LiveCellDelegate {
    func alarmClickedd( _ cell : LiveScoresCell)
}
 

class LiveScoresCell : UITableViewCell{
    
    @IBOutlet weak var noMatchLabel: UILabel!
    @IBOutlet weak var matchIdLabel: UILabel!
    @IBOutlet weak var out_cell: UIView!
    @IBOutlet weak var out_alarmButton: UIButton!
    @IBOutlet weak var LocalTeamLabel: UILabel!
    @IBOutlet weak var localScoreLabel: UILabel!
    @IBOutlet weak var visitorScoreLabel: UILabel!
    @IBOutlet weak var visitorTeamLabel: UILabel!
    @IBOutlet weak var leaguenameLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    var liveArray  = [LiveScorePojo]()
    var delegate: LiveCellDelegate?
    var player: AVAudioPlayer?
    var booleanMessage = true
    var toast : Toast!


    @IBAction func alarmClicked(_ sender: UIButton) {
        delegate?.alarmClickedd(self)
    }
 
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
  
    
    func setArray(mdataset : LiveScorePojo,color:Bool){
 
        LocalTeamLabel.text = mdataset.localTeam
        visitorTeamLabel.text = mdataset.visitorTeam
        localScoreLabel.text = String(mdataset.localScore)
        visitorScoreLabel.text = String(mdataset.visitorScore)
        minuteLabel.text = String(mdataset.minute)
        matchIdLabel.text = String(mdataset.matchId)
        
        minuteLabel.textColor = UIColor.black
        visitorScoreLabel.textColor = UIColor.black
        localScoreLabel.textColor = UIColor.black
        out_alarmButton.setBackgroundImage(UIImage(named:"bell.png"), for: UIControlState.normal)
        
        
        
        if (mdataset.matchId == -1) {
            leaguenameLabel.text = mdataset.leagueName
            let aq : String = mdataset.flagg
             flagImage.image = UIImage( named : "\(aq).png" )
            if (flagImage.image == nil) {
                flagImage.image = UIImage( named : "cup.png")
            }
             out_cell.backgroundColor = hexStringToUIColor(hex:"#004C99")
            
            //Assign nil
            out_alarmButton.isHidden = true
            localScoreLabel.text = ""
            visitorScoreLabel.text = ""
            minuteLabel.text = ""
            LocalTeamLabel.text = ""
            visitorTeamLabel.text = ""
        
            
            //Hidden
           //out_alarmButton.isHidden = true
           //localScoreLabel.isHidden=true
           //visitorScoreLabel.isHidden = true
           //minuteLabel.isHidden = true
        
        }
        else {
            out_alarmButton.isHidden = false
                 if(color){
                     out_alarmButton.setBackgroundImage(UIImage(named:"bellyellow.png"), for: UIControlState.normal)
                 }
                     
        
            //Assign nil
            flagImage.image = nil
            leaguenameLabel.text = ""
            
            //Hidden
            //flagImage.isHidden = true
            //leaguenameLabel.isHidden = true
            
            out_cell.backgroundColor = UIColor.white
            LocalTeamLabel.text = mdataset.localTeam
            localScoreLabel.text = String( mdataset.localScore ) + " - "
            visitorScoreLabel.text =  String(mdataset.visitorScore)
           visitorTeamLabel.text = mdataset.visitorTeam
            
            if ( mdataset.minute == 0 ){
            minuteLabel.text =  "HT"
            }
            else{
           minuteLabel.text = String( mdataset.minute ) + "'"
            }
            
            if (booleanMessage && mdataset.localScore != 0 && mdataset.preLocalScore != -1 && mdataset.preLocalScore != mdataset.localScore && !mdataset.ilkFlag && mdataset.isMatchLength ) {
                
                   localScoreLabel.fadeOut(completion: {
                    (finished: Bool) -> Void in
                    self.localScoreLabel.textColor = UIColor.red
                    self.localScoreLabel.fadeIn()
                
                })
                toast=Toast(text:"GOAL ! \((mdataset.localTeam)!)   \((mdataset.localScore)!)-\((mdataset.visitorScore)!)   \((mdataset.visitorTeam)!)", delay: Delay.short, duration: Delay.long)
                toast.show()
            
                
                let url = Bundle.main.url(forResource: "goal", withExtension: "wav")!
                
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    guard let player = player else { return }
                    player.prepareToPlay()
                    player.play()
                } catch let error as NSError {
                    print(error.description)
                }
               
            }
           //booleanMessage Settingsten geliyor
            if(booleanMessage && mdataset.visitorScore != 0 && mdataset.preVisitorScore != -1 && mdataset.preVisitorScore != mdataset.visitorScore && !mdataset.ilkFlag && mdataset.isMatchLength ) {
                
                print("BIK BIK ETMELİ")
                visitorScoreLabel.fadeOut(completion: {
                    (finished: Bool) -> Void in
                    self.visitorScoreLabel.textColor = UIColor.red
                    self.visitorScoreLabel.fadeIn()
                })
                toast=Toast(text: " \((mdataset.localTeam)!)   \((mdataset.localScore)!)-\((mdataset.visitorScore)!)   \((mdataset.visitorTeam)!) GOAL ! " , delay: Delay.short, duration: Delay.long)
                toast.show()
                
              
                let url = Bundle.main.url(forResource: "goal", withExtension: "wav")!
                
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    guard let player = player else { return }
                    player.prepareToPlay()
                    player.play()
                } catch let error as NSError {
                    print(error.description)
                }
            }
            
            if (mdataset.preMinute != mdataset.minute && !mdataset.ilkFlag ) {
             
                
                    minuteLabel.fadeOut(completion: {
                    (finished: Bool) -> Void in
                    self.minuteLabel.textColor = UIColor.red
                    self.minuteLabel.fadeIn()
                })
             
            }
        }
       
    }


    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.black
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }
}

