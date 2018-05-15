//
//  NextMatchesCell.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 13/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit

class NextMatchesCell : UITableViewCell {
    @IBOutlet weak var nextMatchesImage: UIImageView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var localTeamLabelll: UILabel!
    @IBOutlet weak var visitorTeamLabelll: UILabel!
    @IBOutlet weak var leagueNameLabelll: UILabel!
    @IBOutlet weak var outCell: UIView!
    @IBOutlet weak var lineLabel: UILabel!
    
    

    
    
    func setArray(mdataset : NextMatchesPojo){
        
        localTeamLabelll.text = mdataset.localTeam
        visitorTeamLabelll.text = mdataset.visitorTeam
        hourLabel.text = mdataset.hour
        minuteLabel.text = mdataset.minute
        
        
        if (mdataset.matchId == -1) {
            lineLabel.isHidden = true
            leagueNameLabelll.text = mdataset.leagueName
            nextMatchesImage.isHidden = false
            let aq : String = mdataset.flagg;
            nextMatchesImage.image = UIImage( named : "\(aq).png" )
            if (nextMatchesImage.image == nil) {
                nextMatchesImage.image = UIImage( named : "cup.png")
            }
            
            outCell.backgroundColor = UIColor.init(red: 0.11, green: 0.17, blue: 0.31, alpha: 1.0)
            
        }
            
        else{
            outCell.backgroundColor = UIColor.white
            leagueNameLabelll.text = nil;
            lineLabel.isHidden = false
            nextMatchesImage.isHidden = true
            localTeamLabelll.text = mdataset.localTeam
            visitorTeamLabelll.text = mdataset.visitorTeam
            hourLabel.text = mdataset.hour + " : "
            minuteLabel.text = mdataset.minute
            
        }
      
    }
    
}

