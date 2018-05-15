//
//  ResultCell.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 12/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit

class ResultCell : UITableViewCell {
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var localTeamLabell: UILabel!
    @IBOutlet weak var localScoreLabell: UILabel!
    @IBOutlet weak var visitorScoreLabell: UILabel!
    @IBOutlet weak var visitorTeamLabell: UILabel!
    @IBOutlet weak var leagueNameLabell: UILabel!
    @IBOutlet weak var out_cell: UIView!
    
    
    func setArray(mdataset : ResultPojo){
        
        localTeamLabell.text = mdataset.localTeam
        visitorTeamLabell.text = mdataset.visitorTeam
        localScoreLabell.text = String(mdataset.localScore)
        visitorScoreLabell.text = String(mdataset.visitorScore)
        
        
        if (mdataset.matchId == -1) {
            leagueNameLabell.text = mdataset.leagueName
            
            let aq : String = mdataset.flagg;
            flagImage.image = UIImage( named : "\(aq).png" )
            if (flagImage.image == nil) {
                flagImage.image = UIImage( named : "cup.png")
            }
        
            out_cell.backgroundColor = UIColor.init(red: 0.11, green: 0.17, blue: 0.31, alpha: 1.0)
            localScoreLabell.isHidden=true
            visitorScoreLabell.isHidden = true
            flagImage.isHidden = false
        }
            
        else{
            localScoreLabell.isHidden = false
            visitorScoreLabell.isHidden = false
        out_cell.backgroundColor = UIColor.white
        leagueNameLabell.text = nil;
        flagImage.isHidden = true
        localTeamLabell.text = mdataset.localTeam
        localScoreLabell.text = String( mdataset.localScore ) + " - "
       
        visitorScoreLabell.text =  String(mdataset.visitorScore)
        
        visitorTeamLabell.text = mdataset.visitorTeam
       }
    }
    
}
