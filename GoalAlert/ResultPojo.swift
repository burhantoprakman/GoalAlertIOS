//
//  ResultPojo.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 12/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit

class ResultPojo{
    var leagueId : Int!
    var matchId : Int!
    var localScore : Int!
    var visitorScore : Int!
    var minute : Int!
    var leagueName : String!
    var localTeam : String!
    var visitorTeam : String!
    var flagg : String!
    
    init(leagueId : Int ,matchId : Int,localScore : Int,visitorScore : Int, leagueName : String , localTeam : String ,visitorTeam : String ,flagg : String  ) {
        self.leagueId = leagueId
        self.matchId = matchId
        self.localScore = localScore
        self.leagueName = leagueName
        self.localTeam = localTeam
        self.visitorTeam = visitorTeam
        self.flagg = flagg
        self.visitorScore = visitorScore
    }
    init(leagueId : Int , leagueName : String , flagg : String) {
        
        self.leagueId = leagueId
        self.matchId = -1
        self.localScore = -1
        self.minute = -1
        self.leagueName = leagueName
        self.localTeam = nil
        self.visitorTeam = nil
        self.flagg = flagg
        self.visitorScore = -1
        
    }
    
    
}
