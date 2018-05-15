//
//  NextMatchesPojo.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 13/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation

class NextMatchesPojo{
    var leagueId : Int!
    var matchId : Int!
       var minute : String!
    var leagueName : String!
    var localTeam : String!
    var visitorTeam : String!
    var flagg : String!
    var hour : String!
    
    init(leagueId : Int ,matchId : Int, leagueName : String , localTeam : String ,visitorTeam : String ,flagg : String , hour :String, minute : String ) {
        self.leagueId = leagueId
        self.matchId = matchId
        self.leagueName = leagueName
        self.localTeam = localTeam
        self.visitorTeam = visitorTeam
        self.flagg = flagg
        self.hour = hour
        self.minute = minute
       
    }
    init(leagueId : Int , leagueName : String , flagg : String) {
        
        self.leagueId = leagueId
        self.matchId = -1
      
        self.minute = nil
        self.leagueName = leagueName
        self.localTeam = nil
        self.visitorTeam = nil
        self.flagg = flagg
        
        
    }
    
    
}
