//
//  Alert.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 05/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
struct Alert : CustomStringConvertible {
    
    let id : Int64?
    let localTeam : String
    let visitorTeam : String
    let alarmMin : Int
    let bet : Double
    let matchId : Int
    
    init(id : Int64? , localTeam : String = "" , visitorTeam : String = "" , alarmMin : Int , bet : Double , matchId : Int) {
        self.id = id
        self.localTeam = localTeam
        self.visitorTeam = visitorTeam
        self.alarmMin = alarmMin
        self.bet = bet
        self.matchId = matchId
    }
    var description: String{
        return "id = \(self.id ?? 0 ) , localteam =  \(self.localTeam) ,visitorTeam = \(self.visitorTeam), alarmMin = \(self.alarmMin), bet = \(String(describing: self.bet)) , matchId = \(self.matchId)"
        
    }
    
}
