//
//  CreateAlertVC.swift
//  Tipster
//
//  Created by Burhan TOPRAKMAN on 19/10/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit
import CoreData
import Toaster
import UserNotifications

class CreateAlertVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
   
    @IBOutlet weak var create_localTeam: UILabel!
    @IBOutlet weak var create_visitorTeam: UILabel!
    @IBOutlet weak var create_Minute: UILabel!
    @IBOutlet weak var create_LocalTeamScore: UILabel!
    @IBOutlet weak var create_visitorTeamScore: UILabel!
    @IBOutlet weak var yourAlert: UILabel!
    @IBOutlet var alertBet: UILabel!
    @IBOutlet var ruletView: UIView!
    @IBOutlet weak var btts_yes: UIButton!
    @IBOutlet weak var btts_no: UIButton!
    @IBOutlet weak var score: UIButton!
    @IBOutlet weak var noGoal: UIButton!
    @IBOutlet weak var arti05: UIButton!
    @IBOutlet weak var arti15: UIButton!
    @IBOutlet weak var arti25: UIButton!
    @IBOutlet weak var arti35: UIButton!
    @IBOutlet weak var arti45: UIButton!
    @IBOutlet weak var eksi15: UIButton!
    @IBOutlet weak var eksi25: UIButton!
    @IBOutlet weak var eksi35: UIButton!
    @IBOutlet weak var eksi45: UIButton!
    @IBOutlet weak var eksi55: UIButton!
    @IBOutlet weak var set_Alert: UIButton!
    @IBOutlet weak var arti55: UIButton!
   
    @IBOutlet weak var alertPickerView: UIPickerView!
    
    @IBOutlet weak var alertNB: UINavigationItem!
    @IBOutlet weak var backItem: UIBarButtonItem!
    var matchId : Int = 0
    var localTeam : String = ""
    var visitorTeam : String = ""
    var Minute : Int = 0
    var LocalTeamScore : Int = 0
    var visitorTeamScore : Int = 0
    var bet : Double  = 0.0
    var spnPos : Int = -1
    var genericArray = [LiveScorePojo]()
    var isGeneric : Bool  = false
    var count = 0;
    
    
    var pickerDataSource = [NSLocalizedString("choose", comment: ""), NSLocalizedString("any_time", comment: ""), NSLocalizedString("half_time", comment: ""), NSLocalizedString("full_time", comment: ""), "5" ,"10" ,"15" ,"20" ,"25" ,"30" ,"35" ,"40" ,"45" ,"50" ,"55" ,"60" ,"65" ,"70" ,"75" ,"80" ,"85" ,"90" ];
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertPickerView.dataSource = self;
        self.alertPickerView.delegate = self;
        
        alertNB.title = NSLocalizedString("create_alert", comment: "")
        backItem.title = NSLocalizedString("back", comment: "")
        set_Alert.setTitle(NSLocalizedString("set_alert", comment: ""), for: .normal)
        btts_yes.setTitle(NSLocalizedString("btts_yes", comment: ""), for: .normal)
        btts_no.setTitle(NSLocalizedString("btts_no", comment: ""), for: .normal)
        score.setTitle(NSLocalizedString("score", comment: ""), for: .normal)
        noGoal.setTitle(NSLocalizedString("no_goal", comment: ""), for: .normal)
        
        alertPickerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.jpg")!)
        if(isGeneric == true) {
            create_visitorTeam.isHidden = true
            create_Minute.isHidden = true
            create_LocalTeamScore.isHidden = true
            create_visitorTeamScore.isHidden = true
            create_localTeam.text  = NSLocalizedString("generic_alarm", comment: "")
            
            create_visitorTeam.isHidden = true
            
        }else {
        create_LocalTeamScore.text = "\(LocalTeamScore) -"
         create_visitorTeamScore.text = "\(visitorTeamScore)"
        if(Minute == 0){
            create_Minute.text  = NSLocalizedString("ht", comment: "")
        }else{
            create_Minute.text = "\(String(Minute))'"
        }
         create_localTeam.text = String(localTeam)
         create_visitorTeam.text = "-  \(visitorTeam)"
        }
        
        backgroundTransparent()
        
  }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = pickerDataSource[row]
        return NSAttributedString(string: str, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        backgroundTransparent()
        
      if(row == 0){
        backgroundTransparent()
        yourAlert.text = NSLocalizedString("your_alert_choose", comment: "")
        spnPos = -1
      }else if(row == 1){
        spnPos = -2
        backgroundTransparent()
            btts_yes.backgroundColor=UIColor.red
            arti05.backgroundColor=UIColor.black
            arti15.backgroundColor=UIColor.red
            arti25.backgroundColor=UIColor.black
            arti35.backgroundColor=UIColor.red
            arti45.backgroundColor=UIColor.black
            set_Alert.backgroundColor=UIColor.green
            btts_yes.isEnabled = true
            arti05.isEnabled = true
            arti15.isEnabled = true
            arti25.isEnabled = true
            arti35.isEnabled = true
            arti45.isEnabled = true
            set_Alert.isEnabled = true
        yourAlert.text = NSLocalizedString("your_alert_any_time", comment: "")
        
      }else if (row == 2 ){
        yourAlert.text = NSLocalizedString("your_alert_half_time", comment: "")
        spnPos = -3
        changeColor()
      
        
      }else if(row == 3){
        yourAlert.text = NSLocalizedString("your_alert_full_time", comment: "")
        spnPos = -4
        changeColor()
        }
      else{
        let aa :String = NSLocalizedString("your_alert", comment: "")
        yourAlert.text = "\(aa) \(pickerDataSource[row])'"
        spnPos = Int(pickerDataSource[row])!
        changeColor()
        }
    
    }
    
  

    @IBAction func NOOOO(_ sender: Any) {
        bet = -1.1
        alertBet.text = NSLocalizedString("btts_no", comment: "")
    }
    
    @IBAction func btts_YesClicked(_ sender: Any) {
        bet = 1.1
        alertBet.text = NSLocalizedString("btts_yes", comment: "")
    }
    
    @IBAction func scoreClicked(_ sender: Any) {
        bet = -8.8
        alertBet.text = NSLocalizedString("score", comment: "")
    }
    @IBAction func noGoalClicked(_ sender: Any) {
        bet = -9.9
        alertBet.text = NSLocalizedString("no_goal", comment: "")
    }
    
    
    
    @IBAction func arti05Clicked(_ sender: Any) {
        bet = 0.5
        alertBet.text = "0.5+"
    }
    @IBAction func arti15Clicked(_ sender: Any) {
        bet = 1.5
        alertBet.text = "1.5+"
    }
    
    @IBAction func arti25Clicked(_ sender: Any) {
        bet = 2.5
        alertBet.text = "2.5+"
    }
    
   
    @IBAction func arti35Clicked(_ sender: Any) {
        bet = 3.5
        alertBet.text = "3.5+"
    }
  
    @IBAction func arti45Clicked(_ sender: Any) {
        bet = 4.5
        alertBet.text = "4.5+"
    }
    @IBAction func arti55Clicked(_ sender: Any) {
        bet = 5.5
        alertBet.text = "5.5+"
    }
    
    
    @IBAction func eksi15Clicked(_ sender: Any) {
        bet = -1.5
        alertBet.text = "1.5-"
    }
    
    @IBAction func eksi25Clicked(_ sender: Any) {
        bet = -2.5
        alertBet.text = "2.5-"
    }
    
    @IBAction func eksi35Clicked(_ sender: Any) {
        bet = -3.5
        alertBet.text = "3.5-"
    }
    
    @IBAction func eksi45Clicked(_ sender: Any) {
        bet = -4.5
        alertBet.text = "4.5-"
    }
    
    @IBAction func eksi55Clicked(_ sender: Any) {
        bet = -5.5
        alertBet.text = "5.5-"
    }
   
    @IBAction func setAlert_Clicked(_ sender: Any) {
        if (bet == 0.0 ){
            let toast = Toast.init(text: NSLocalizedString("choose_bet", comment: "")  , delay: Delay.short, duration: Delay.long)
            toast.show()
        }
        else if(spnPos == -1){
            let toast = Toast.init(text: NSLocalizedString("choose_minute", comment: "")  ,delay: Delay.short, duration: Delay.long)
            toast.show()
         
        } else if (isGeneric == true) {
          
            for i in 0 ..< genericArray.count {
             
                if ( genericArray[i].matchId != -1) {
                        // dk bazlı
                        if (spnPos > 0) {
                            if(spnPos > genericArray[i].minute) {
                            insert(local: genericArray[i].localTeam, visitor: genericArray[i].visitorTeam, spnPos: spnPos, bet: bet, matchId: genericArray[i].matchId)
                                count+=1
                            }
                        }
                            
                     else if (spnPos == -2) {
                        // any time
                        if (bet == 1.1) {
                            if (genericArray[i].localScore == 0 || genericArray[i].visitorScore == 0) {
                                insert(local: genericArray[i].localTeam, visitor: genericArray[i].visitorTeam, spnPos: spnPos, bet: bet, matchId: genericArray[i].matchId)
                                count+=1
                            }
                        } else {
                            if (bet > Double(genericArray[i].localScore + genericArray[i].visitorScore)) {
                                insert(local: genericArray[i].localTeam, visitor: genericArray[i].visitorTeam, spnPos: spnPos, bet: bet, matchId: genericArray[i].matchId)
                                count+=1
                            }
                        }
                    } else if (spnPos == -3) {
                        // half time
                        if (genericArray[i].minute < 45) {
                            insert(local: genericArray[i].localTeam, visitor: genericArray[i].visitorTeam, spnPos: spnPos, bet: bet, matchId: genericArray[i].matchId)
                            count+=1
                        }
                    } else if (spnPos == -4) {
                        // full time
                            insert(local: genericArray[i].localTeam, visitor: genericArray[i].visitorTeam, spnPos: spnPos, bet: bet, matchId: genericArray[i].matchId)
                            count+=1
                    }
                }
            }
            let toast : Toast! = Toast(text: "\(count) Alarm Settled", delay: Delay.short, duration: Delay.long)
            toast.show()
        }
     else {
        var myMatchList = [Int]()
            _  = DBHelper.shared.saveData(localteam: localTeam, visitorteam: visitorTeam, alarmmin: spnPos, bet: bet, matchid: matchId)
        let def = UserDefaults.standard
        if let temp = def.array(forKey: "myMatchList") as? [Int]  {
            myMatchList = temp
        }
        myMatchList.append(matchId)
        def.set(myMatchList, forKey: "myMatchList")
        def.synchronize()
            
        let myService = MyService()
       
           myService.StartTimer()
            }
      
        
    }
        
        func insert(local : String, visitor : String, spnPos : Int, bet : Double , matchId : Int) {
            
            var myMatchList = [Int]()
            _  = DBHelper.shared.saveData(localteam: local, visitorteam: visitor, alarmmin: spnPos, bet: bet, matchid: matchId)
            let def = UserDefaults.standard
            if let temp = def.array(forKey: "myMatchList") as? [Int]  {
                myMatchList = temp
            }
            myMatchList.append(matchId)
            def.set(myMatchList, forKey: "myMatchList")
            def.synchronize()
            
            
            let myService = MyService()
            
            myService.StartTimer()
  
        }
    

   
   
    
    func backgroundTransparent(){
        
        btts_yes.backgroundColor = .clear
        btts_yes.layer.borderWidth = 1
        btts_yes.layer.borderColor = UIColor.white.cgColor
        
    btts_no.backgroundColor = .clear
    btts_no.layer.borderWidth = 1
    btts_no.layer.borderColor = UIColor.white.cgColor
        
    score.backgroundColor = .clear
    score.layer.borderWidth = 1
    score.layer.borderColor = UIColor.white.cgColor
        
    noGoal.backgroundColor = .clear
    noGoal.layer.borderWidth = 1
    noGoal.layer.borderColor = UIColor.white.cgColor

    arti05.backgroundColor = .clear
    arti05.layer.borderWidth = 1
    arti05.layer.borderColor = UIColor.white.cgColor
        
    arti15.backgroundColor = .clear
    arti15.layer.borderWidth = 1
    arti15.layer.borderColor = UIColor.white.cgColor
        
    arti25.backgroundColor = .clear
    arti25.layer.borderWidth = 1
    arti25.layer.borderColor = UIColor.white.cgColor
        
    arti35.backgroundColor = .clear
    arti35.layer.borderWidth = 1
    arti35.layer.borderColor = UIColor.white.cgColor
        
    arti45.backgroundColor = .clear
    arti45.layer.borderWidth = 1
    arti45.layer.borderColor = UIColor.white.cgColor
        
    arti55.backgroundColor = .clear
    arti55.layer.borderWidth = 1
    arti55.layer.borderColor = UIColor.white.cgColor
        
    eksi15.backgroundColor = .clear
    eksi15.layer.borderWidth = 1
    eksi15.layer.borderColor = UIColor.white.cgColor
        
    eksi25.backgroundColor = .clear
    eksi25.layer.borderWidth = 1
    eksi25.layer.borderColor = UIColor.white.cgColor
        
    eksi35.backgroundColor = .clear
    eksi35.layer.borderWidth = 1
    eksi35.layer.borderColor = UIColor.white.cgColor
        
    eksi45.backgroundColor = .clear
    eksi45.layer.borderWidth = 1
    eksi45.layer.borderColor = UIColor.white.cgColor
        
    eksi55.backgroundColor = .clear
    eksi55.layer.borderWidth = 1
    eksi55.layer.borderColor = UIColor.white.cgColor
        
    set_Alert.backgroundColor = .clear
        
        
        
        btts_yes.isEnabled = false
        btts_no.isEnabled = false
        score.isEnabled = false
        noGoal.isEnabled = false
        arti05.isEnabled = false
        arti15.isEnabled = false
        arti25.isEnabled = false
        arti35.isEnabled = false
        arti45.isEnabled = false
        arti55.isEnabled = false
        eksi15.isEnabled = false
        eksi25.isEnabled = false
        eksi35.isEnabled = false
        eksi45.isEnabled = false
        eksi55.isEnabled = false
        set_Alert.isEnabled = false }
    
    func changeColor(){
        btts_yes.backgroundColor=UIColor.black
        btts_no.backgroundColor=UIColor.red
        score.backgroundColor=UIColor.red
        noGoal.backgroundColor=UIColor.black
        arti05.backgroundColor=UIColor.red
        arti15.backgroundColor=UIColor.black
        arti25.backgroundColor=UIColor.red
        arti35.backgroundColor=UIColor.black
        arti45.backgroundColor=UIColor.red
        arti55.backgroundColor=UIColor.black
        eksi15.backgroundColor=UIColor.red
        eksi25.backgroundColor=UIColor.black
        eksi35.backgroundColor=UIColor.red
        eksi45.backgroundColor=UIColor.black
        eksi55.backgroundColor=UIColor.red
        set_Alert.backgroundColor = UIColor.init(red: 94/255, green: 190/255, blue: 34/255, alpha: 1)
        btts_yes.isEnabled = true
        btts_no.isEnabled = true
        score.isEnabled = true
        noGoal.isEnabled = true
        arti05.isEnabled = true
        arti15.isEnabled = true
        arti25.isEnabled = true
        arti35.isEnabled = true
        arti45.isEnabled = true
        arti55.isEnabled = true
        eksi15.isEnabled = true
        eksi25.isEnabled = true
        eksi35.isEnabled = true
        eksi45.isEnabled = true
        eksi55.isEnabled = true
        set_Alert.isEnabled = true }
}