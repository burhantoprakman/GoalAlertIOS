//
//  AlertsPojo.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 08/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
public class AlertsPojo{
    var dbId : Int64
    var mainText : String
    var matchId : Int
    init(dbId : Int64 , mainText : String , matchId : Int ) {
        self.dbId = dbId
        self.mainText = mainText
        self.matchId = matchId
    }
    
}
