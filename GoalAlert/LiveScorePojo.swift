//
//  LiveScorePojo.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 06/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit

class LiveScorePojo{
    var leagueId : Int!
    var matchId : Int!
    var localScore : Int!
    var visitorScore : Int!
    var minute : Int!
    var preLocalScore : Int!
    var preVisitorScore : Int!
    var preMinute : Int!
    var leagueName : String!
    var localTeam : String!
    var visitorTeam : String!
    var flagg : String!
    var ilkFlag : Bool!
    var isMatchLength : Bool!
    
    init(leagueId : Int ,matchId : Int,localScore : Int,visitorScore : Int,minute : Int,preLocalScore : Int,preVisitorScore : Int,preMinute : Int,leagueName : String , localTeam : String ,visitorTeam : String ,flagg : String , ilkflag : Bool , isMatchLength : Bool ) {
        self.leagueId = leagueId
        self.matchId = matchId
        self.localScore = localScore
        self.minute = minute
        self.preLocalScore = preLocalScore
        self.preVisitorScore = preVisitorScore
        self.preMinute = preMinute
        self.leagueName = leagueName
        self.localTeam = localTeam
        self.visitorTeam = visitorTeam
        self.flagg = flagg
        self.ilkFlag = ilkflag
        self.visitorScore = visitorScore
        self.isMatchLength = isMatchLength
    }
   init(){
    }
    init(leagueId : Int , leagueName : String , flagg : String) {
        
        self.leagueId = leagueId
        self.matchId = -1
        self.localScore = -1
        self.minute = -1
        self.preLocalScore = -1
        self.preVisitorScore = -1
        self.preMinute = -1
        self.leagueName = leagueName
        self.localTeam = nil
        self.visitorTeam = nil
        self.flagg = flagg
        self.ilkFlag = false
        self.visitorScore = -1
        
    }
}
