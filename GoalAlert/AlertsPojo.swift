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
    var dbId : Int
    var mainText : String
    init(dbId : Int , mainText : String) {
        self.dbId = dbId
        self.mainText = mainText
    }
    
}
