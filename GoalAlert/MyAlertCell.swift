//
//  MyAlertCell.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 08/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit

protocol AlertCellDelegate {
    func deleteClicked( _ cell : MyAlertCell)
}

class MyAlertCell: UITableViewCell  {

    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var out_deleteButton: UIButton!
    
    
    var delegate : AlertCellDelegate?
    
    @IBAction func deleteAlertClicked(_ sender: UIButton) {
    delegate?.deleteClicked(self)
     
    }
    
    func setArray(mdataset : AlertsPojo){
        alertLabel.text = mdataset.mainText
    }
}
