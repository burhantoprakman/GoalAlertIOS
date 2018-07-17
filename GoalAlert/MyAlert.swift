//
//  MyAlert.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 04/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import OneSignal

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
        showAlarmData(status: "pending")
           self.myalertTableView.reloadData()
        
         self.myalertTableView.addSubview(self.refreshControl)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyAlertCell = self.myalertTableView.dequeueReusableCell(withIdentifier: "alertcell") as! MyAlertCell
        let goCell  =  alert_result[indexPath.row]
        cell.setArray(mdataset: goCell)
        cell.out_deleteButton.tag = alert_result[indexPath.row].dbId
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
        
        let url = URL(string: "http://opucukgonder.com/tipster/index.php/Service/deleteAlarms")!
        let config = URLSessionConfiguration.default
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let userid = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId!
        //let userid = "e15d101c-aa1f-421a-83cb-d6230579624c"
        
        var langDef : String = "en";
        let lang = Locale.current.languageCode
        if (lang == "de" || lang=="es" || lang=="fr" || lang=="pt" || lang=="ru" || lang=="tr"){
            langDef = lang!
        }
        
        let postString = "deviceid=\(userid)&id=\(sender.tag)"
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        request.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: request ){ data, response, error in
            
            if error != nil{
                print("Get Request Error")
            }
            else{
                
                if data != nil {
                    
                    do {
                        let JsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        DispatchQueue.main.async {
                     
                            self.showAlarmData(status: "pending")
                            self.myalertTableView.reloadData()
                            
                        }
                       
                        
                    } // do bitişi
                    catch {
                        print(error)
                        print("CATCH OLDU")
                    }
                }
                
            }
            
        }
        task.resume()
        
        
        
        
        
        /*aq = alert_DBHelper.deleteData(dbid: alert_result[sender.tag].dbId)
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
 */
      
        
        
        
       
        
    }
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        showAlarmData(status: "pending")
        self.myalertTableView.reloadData()
        
    }
    
    func showAlarmData(status : String){
        var visTeam : String = ""
        var locTeam : String = ""
        var id : Int  = 0
        var alarms = [AlertsPojo]()
        let url = URL(string: "http://opucukgonder.com/tipster/index.php/Service/getAlarms")!
        let config = URLSessionConfiguration.default
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let userid = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId!
        //let userid = "e15d101c-aa1f-421a-83cb-d6230579624c"
        
        var langDef : String = "en";
        let lang = Locale.current.languageCode
        if (lang == "de" || lang=="es" || lang=="fr" || lang=="pt" || lang=="ru" || lang=="tr"){
            langDef = lang!
        }
        
        let postString = "deviceid=\(userid)&status=\(status)"
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        request.httpBody = postString.data(using: .utf8)
        let task = session.dataTask(with: request ){ data, response, error in
            
            if error != nil{
                print("Get Request Error")
            }
            else{
                
                if data != nil {
                    
                    do {
                        let JsonResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [AnyObject]
                        DispatchQueue.main.async {
                            for i in 0 ..< JsonResult.count{
                                var response  = JsonResult[i] as! [String:AnyObject]
                                if let lt : String = response["localteam"] as? String{
                                    locTeam = lt
                                }
                                if let vt : String = response["visitorteam"] as? String{
                                    visTeam = vt
                                }
                                if let dbid : String = response["id"] as? String{
                                    id = Int(dbid)!
                                }
                            
                                var bet: String = (response["bet"] as? String)!
                                var betMinute: String = (response["bet_minute"] as? String)!
                                switch(response["bet_minute"] as! String){
                                case "-2" :
                                     betMinute = NSLocalizedString("any_time", comment: "")
                                    break
                                case "-3":
                                    betMinute = NSLocalizedString("half_time", comment: "")
                                    break
                                case "-4":
                                    betMinute = NSLocalizedString("full_time", comment: "")
                                    break
                                    
                                default:
                                    betMinute = NSLocalizedString("\(String(describing: response["bet_minute"] as! String))", comment: "") + "'"
                                }
                                
                                switch(response["bet"] as! String){
                                case "-8.8" :
                                    bet = NSLocalizedString("score", comment: "")
                                    break
                                case "-9.9":
                                    bet = NSLocalizedString("no_goal", comment: "")
                                    break
                                case "-1.1":
                                    bet = NSLocalizedString("btts_no", comment: "")
                                    break
                                case "1.1":
                                    bet = NSLocalizedString("btts_yes", comment: "")
                                    break
                                    
                                default:
                                    bet = NSLocalizedString("\(String(describing: response["bet"] as! String))", comment: "") + "'"
                                }
                                let alertpojo = AlertsPojo.init(dbId: id, mainText: locTeam + " - " + visTeam + "   " + betMinute  + "    " + bet)
                                alarms.append(alertpojo)
                            }
                           
                        
                        }
                        DispatchQueue.main.async {
                            self.alert_result = alarms
                            self.myalertTableView.reloadData()
                        }
                        
                    } // do bitişi
                    catch {
                        print(error)
                        print("CATCH OLDU")
                    }
                }
                
            }
            
        }
        self.refreshControl.endRefreshing()
        task.resume()
      
        
        
        
    }

}
