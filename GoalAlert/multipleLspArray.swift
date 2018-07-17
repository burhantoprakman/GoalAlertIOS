//
//  multipleLspArray.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 05/07/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
class multipleLspArray{
    var localteam : String
    var visitorteam : String
    var bet_minute: String
    var lang : String
    var bet : String
    var match_id : String
    var deviceid : String
    
    init(localTeam : String , visitorTeam : String, bet_minute : String, lang : String, bet : String, matchid : String, deviceid : String ) {
        self.localteam = localTeam
        self.visitorteam = visitorTeam
        self.bet_minute = bet_minute
        self.lang = lang
        self.bet = bet
        self.match_id = matchid
        self.deviceid = deviceid
    }
}
