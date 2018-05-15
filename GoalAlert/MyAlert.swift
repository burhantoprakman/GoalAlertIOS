//
//  MyAlert.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 04/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit

class MyAlert : UIViewController , UITableViewDelegate , UITableViewDataSource  {
  
    
   
    @IBOutlet var myalertTableView: UITableView!
    private var alert_result = [AlertsPojo]()
    private var alert_DBHelper = DBHelper.shared
    private var aq: Bool = false
    @IBOutlet weak var aTabItem: UITabBarItem!
    
    @IBOutlet weak var noAlertLabel: UILabel!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        //let localRefresh = NSLocalizedString("refresh", comment: "")
        //refreshControl.attributedTitle = NSAttributedString(string: localRefresh)
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action:
            #selector(LiveScores.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "goalalertsu.jpg") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        noAlertLabel.text = NSLocalizedString("no_alert", comment: "")
        
        myalertTableView.delegate = self
        myalertTableView.dataSource = self
        myalertTableView.backgroundView = UIImageView(image: UIImage(named: "bg.jpg"))
        showAlarmData()
           self.myalertTableView.reloadData()
        
         self.myalertTableView.addSubview(self.refreshControl)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyAlertCell = self.myalertTableView.dequeueReusableCell(withIdentifier: "alertcell") as! MyAlertCell
        let goCell  =  alert_result[indexPath.row]
        cell.setArray(mdataset: goCell)
        cell.out_deleteButton.tag = indexPath.row
        cell.out_deleteButton.addTarget(self, action: #selector(deleteClicked(sender:)), for: .touchUpInside )
          self.refreshControl.endRefreshing()
        return cell
       
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(alert_result.count == 0){
            noAlertLabel.isHidden = false
        } else {
            noAlertLabel.isHidden = true
        }
        return alert_result.count
    }
    
    func deleteClicked( sender:UIButton! ){
        aq = alert_DBHelper.deleteData(dbid: alert_result[sender.tag].dbId)
        if(aq){
            var myMatchList = [Int]()
            let def = UserDefaults.standard
            if let temp = def.array(forKey: "myMatchList") as? [Int]  {
                myMatchList = temp
            }
              if( myMatchList.count != 0 && alert_result[sender.tag].matchId != 0 ){
                myMatchList = myMatchList.filter { $0 != alert_result[sender.tag].matchId }
                def.set(myMatchList, forKey: "myMatchList")
                
            }
        }
      
         showAlarmData()
         self.myalertTableView.reloadData()
        
       
        
    }
    func handleRefresh(_ refreshControl: UIRefreshControl) {
       showAlarmData()
        self.myalertTableView.reloadData()
    }
    
    func showAlarmData(){
        var alarms = [AlertsPojo]()
        let dbHelper = DBHelper.shared
        if( dbHelper.getAllData().count != 0 ){
            var array_list: [Alert] = dbHelper.getAllData()
            for i in 0 ..< array_list.count {
                let dbId = array_list[i].id
                var matchId = array_list[i].matchId
                var aa : String = ""
                var maintext = ""
                var alarmText = ""
                
                if(array_list[i].alarmMin == -2){
                    alarmText = NSLocalizedString("any_time", comment: "")
                }else if(array_list[i].alarmMin == -3){
                    alarmText = NSLocalizedString("half_time", comment: "")
                }else if(array_list[i].alarmMin == -4){
                    alarmText = NSLocalizedString("full_time", comment: "")
                }
                else {
                    alarmText = "\(array_list[i].alarmMin)"
                }
        
                switch(array_list[i].bet){
                
                case 1.1:
                    aa =  NSLocalizedString("both_teams_scored", comment: "")
                 
                   maintext = " \(array_list[i].localTeam)- \(array_list[i].visitorTeam) :  \(alarmText) ' / \(aa)"
                    break
                case -1.1:
                    aa = NSLocalizedString("one_team_didnt_score", comment: "")
                      maintext = " \(array_list[i].localTeam)- \(array_list[i].visitorTeam) :  \(alarmText) ' / \(aa)"
                    break
                case -8.8:
                    aa = NSLocalizedString("score_info", comment: "")
                      maintext = " \(array_list[i].localTeam)- \(array_list[i].visitorTeam) :  \(alarmText) ' / \(aa)"
                   
                    break
                case -9.9:
                    aa =  NSLocalizedString("no_goal", comment: "")
                      maintext = " \(array_list[i].localTeam)- \(array_list[i].visitorTeam) :  \(alarmText) ' / \(aa)"
                    break
                    
                default:
                     maintext = " \(array_list[i].localTeam)- \(array_list[i].visitorTeam) :  \(alarmText) ' /   \(array_list[i].bet)"
                    break
                }
              /*  if(array_list[i].alarmMin == -2){
                    let generic = NSLocalizedString("generic_alarm", comment: "")
                    maintext = " \(array_list[i].localTeam)- \(array_list[i].visitorTeam) : \(generic) ' / \(aa)"
                }
            */
                
            
                let alertpojo = AlertsPojo.init(dbId: dbId!, mainText: maintext, matchId: matchId)
                alarms.append(alertpojo)
                
            }
          
        }
        self.alert_result = alarms
        
        
        
    }

}
