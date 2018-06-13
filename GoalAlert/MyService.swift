//
//  MyService.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 20/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import OneSignal

class MyService: NSObject {
    var dbHelper = DBHelper.shared
    var timer: Timer?
    var oneSignalId : String = ""
    var matchId :String  = ""
    
    
   

    func notif (dbidd : Int , localTeam : String , visitorTeam : String , localScore : Int , visitorScore : Int , minute : Int ,sstatus : String, boolStatus  : Bool ){
        let langStr = Locale.current.languageCode
        if(boolStatus == true){
            
            print("OLUMLU BİLDİRİMİ BURDAN ATIYOOORRRRR")
            
            OneSignal.postNotification([
                "headings": ["en": NSLocalizedString("success", comment: "")],
                "contents": ["\(langStr ?? "en")": "\(localTeam) \(localScore)-\(visitorScore) \(visitorTeam)  \(minute)"],
                 "include_player_ids": ["\(oneSignalId)"],
                 "content_available" : true,
                 "ios_sound" : "successcaf.caf",
                 "ios_badgeType" : "Increase",
                 "ios_badgeCount" : "1",
                 "subtitle" : ["\(langStr ?? "en")": "\(sstatus)"]
                ])
        }
        else{
            print("OLUMSUZ BİLDİRİMİ BURDAN ATIYOOORRRRR")

            OneSignal.postNotification([
                "headings": ["en": NSLocalizedString("failed", comment: "")],
                "contents": ["\(langStr ?? "en")": "\(localTeam) \(localScore)-\(visitorScore) \(visitorTeam)  \(minute) // \(sstatus)"],
                "include_player_ids": ["\(oneSignalId)"],
                 "content_available": true,
                 "ios_sound" : "failedcaf.caf",
                "ios_badgeType" : "Increase", "ios_badgeCount" : "1",
                "subtitle" : ["\(langStr ?? "en")" : "\(sstatus)"]
                ])
            
        }
        StartTimer()
        
    }

    // call Delete
  func callDelete(dbid : Int64? )  {
    var matchId : String = ""
    var aq : Bool = false
    let searchResults = dbHelper.getAllData().count

        
      for qwe in 0 ..< searchResults  {
        
        var asd : [Alert] = dbHelper.getAllData()
        if(qwe >= asd.count){
            print("HOOOOPPPP")
        }else{
            if(asd[qwe].id == dbid){
                matchId = String(describing: asd[qwe].matchId)
                aq = dbHelper.deleteData(dbid: dbid!)
            }
        }
        
     
    }
    
     if (aq) {
        var myMatchList = [Int]()
        let def = UserDefaults.standard
        
        if let temp = def.array(forKey: "myMatchList") as? [Int]{
            if( matchId != "" && temp.count != 0){
                myMatchList = temp
                
            if( myMatchList.count != 0 && matchId != ""){
                myMatchList = myMatchList.filter { $0 != Int(matchId)! }
                def.set(myMatchList, forKey: "myMatchList")
                
                }
                def.synchronize()
                
        }
    
     }
    }
     stopTimer()
     MyAlert().showAlarmData()
     }
    
    //operation
    func operation ( matchidd : Int, localTeam : String, visitorTeam : String, localScore : Int , visitorScore : Int , minute : Int, first : Bool, second : Bool , dbidd : Int64 ) {
        
    let total : Int  = localScore + visitorScore
    var alarmMin : Int = -1
    var bet : Double = 31.31
        var boolStatus : Bool = false
    var status : String = NSLocalizedString("failed", comment: "")
        
        //dbHelper Yazılacak.
       for qwe in 0 ..< dbHelper.getAllData().count  {
        do{
            
            var asd : [Alert] = try dbHelper.getAllData()
            if (( asd[qwe].matchId == Int(matchidd) ) && ( asd[qwe].id == dbidd ) ){
                
                alarmMin = asd[qwe].alarmMin
                bet = asd[qwe].bet
            }
        }
        
         catch
         { print("CATCH")}
        }
        
    switch (alarmMin) {
        case -1:
    print("asdasd", "operation da case -1 e girdi yani mevcut bir eslesme bulamadi - dbidd :  + \(dbidd)")
    
    //Call Delete Method
    callDelete(dbid: dbidd)
     break
        case -2: // ANY TIME
    //Log.wtf("ANY TIME", "BET :  + \(bet)" + " - TOTAL :  + \(total)")
    
    if (minute >= 0) {
    print("if", "min > 0 // yani maç oynanıyor")
        
    if (bet == 1.1) {
    print("if", "bet == 1.1 // btts yes")
    if (localScore > 0 && visitorScore > 0) {
    status = NSLocalizedString("both_teams_scored", comment: "")
    boolStatus = true
    //notif gönderme metodu
        callDelete(dbid: dbidd)
        notif(dbidd: Int(dbidd), localTeam: localTeam, visitorTeam: visitorTeam, localScore: localScore, visitorScore: visitorScore, minute: minute, sstatus: status ,  boolStatus: boolStatus)
        
    }
    }
        
    else if ( Int(bet) < total ) {
    
        if(total > 0 ){status = NSLocalizedString("there_is_a_scorer", comment: "")}
        if(total > 1 ){status = NSLocalizedString("two_goals_in_match", comment: "")}
        if(total > 2 ){status = NSLocalizedString("its_over_25", comment: "")}
        if(total > 3 ){status = NSLocalizedString("its_over_35", comment: "")}
        if(total > 4 ){status = NSLocalizedString("its_over_45", comment: "")}
        //print("if", "bet < total")
        boolStatus = true
        
         notif(dbidd: Int(dbidd), localTeam: localTeam, visitorTeam: visitorTeam, localScore: localScore, visitorScore: visitorScore, minute: minute, sstatus: status ,  boolStatus: boolStatus)
        callDelete(dbid: dbidd)
       
        
    }
    } else {
          print("else", "min !> 0 // macın minute'ı 0dan buyuk degil // mac  bitti demek")
        boolStatus = false
        status = NSLocalizedString("full_time", comment: "")
        if(bet == 0.5 ){status = NSLocalizedString("poor_match", comment: "")}
        if(bet == 1.5 ){status = NSLocalizedString("finished_15", comment: "")}
        if(bet == 2.5 ){status = NSLocalizedString("finished_25", comment: "")}
        if(bet == 3.5 ){status = NSLocalizedString("finished_35", comment: "")}
        if(bet == 4.5 ){status = NSLocalizedString("finished_45", comment: "")}
        
        notif(dbidd: Int(dbidd), localTeam: localTeam, visitorTeam: visitorTeam, localScore: localScore, visitorScore: visitorScore, minute: minute, sstatus: status ,  boolStatus: boolStatus)
        callDelete(dbid: dbidd)
        
        
    }
    break
        
        
    case -3: // HALF TIME
    if (minute >= 0) {
   
        if (first) {
    boolStatus = false
            status = ""
        if (bet == 1.1) {
    print("if", "bet == 1.1 // btts yes")
            if (localScore > 0 && visitorScore > 0) {
                boolStatus = true
                status = NSLocalizedString("both_teams_scored", comment: "");
            }
                else{
                    boolStatus = false
                    status = NSLocalizedString("one_team_didnt_score", comment: "");

                }
    
    } else if (bet == -1.1) {
    print("if", "bet == -1.1 // btts no");
            if (Int(localScore) == 0 || Int(visitorScore) == 0) {
                boolStatus = true
                status = NSLocalizedString("one_team_didnt_score", comment: "")
            }else {
                boolStatus = false
                status = NSLocalizedString("both_temas_scored", comment: "")
            }
    } else if (bet == -8.8) {
    print("if", "bet == -8.8 // skor")
            boolStatus = true
            status = NSLocalizedString("score_info", comment: "")
    } else if (bet == -9.9) {
    print("if", "bet == -9.9 // no goal")
    if (Int(localScore) == 0 && Int(visitorScore) == 0) {
        boolStatus = true
        status = NSLocalizedString("no_goal", comment: "")
    }
    else{
        boolStatus = false
        status = NSLocalizedString("there_is_a_scorer", comment: "")
            }
    }
        
        
        else {
            if (bet > 0) {
    print("if", "bet > 0")
                if (Int(bet) < total) {
    print("if", "bet < total")
        status = NSLocalizedString("success", comment: "")
        boolStatus = true
                    if(total > 0 ){status = NSLocalizedString("there_is_a_scorer", comment: "")}
                    if(total > 1 ){status = NSLocalizedString("two_goals_in_match", comment: "")}
                    if(total > 2 ){status = NSLocalizedString("its_over_25", comment: "")}
                    if(total > 3 ){status = NSLocalizedString("its_over_35", comment: "")}
                    if(total > 4 ){status = NSLocalizedString("its_over_45", comment: "")}
                } else {
                    status = "\(bet)!"
                    boolStatus = false
                }
    } else if (Swift.abs(bet) > Double(total)) {
    print("else if", "Math.abs(bet) > total")
                status = NSLocalizedString("success", comment: "")
                boolStatus = true
                if(bet == -0.5 ){status = NSLocalizedString("no_goal", comment: "")}
                if(bet == -1.5 ){status = NSLocalizedString("it_is_over_eksi15", comment: "")}
                if(bet == -2.5 ){status = NSLocalizedString("it_is_over_eksi25", comment: "")}
                if(bet == -3.5 ){status = NSLocalizedString("it_is_over_eksi35", comment: "")}
                if(bet == -4.5 ){status = NSLocalizedString("it_is_over_eksi45", comment: "")}
            } else {
                status = "\(bet)!"
                boolStatus = false
            }
            
            
            
    }
            let aa = NSLocalizedString("half_time", comment: "")
            let bb =  "\(aa),\(status)"
            notif(dbidd: Int(dbidd), localTeam: localTeam, visitorTeam: visitorTeam, localScore: localScore, visitorScore: visitorScore, minute: minute, sstatus: bb ,boolStatus: boolStatus)
            callDelete(dbid: dbidd)

            
    }
    } else {
        status = NSLocalizedString("failed", comment: "")
        
        notif(dbidd: Int(dbidd), localTeam: localTeam, visitorTeam: visitorTeam, localScore: localScore, visitorScore: visitorScore, minute: minute, sstatus: status ,  boolStatus: boolStatus)
        callDelete(dbid: dbidd)

        
    }
    break
        
        
    case -4: // FULL TIME
    //Log.wtf("FULL TIME", "BET :  \(bet)" + " - TOTAL : \(total)")
        if (minute >= 0) {
    print("if", "min > 0 // yani maç oynanıyor")
            if (second) {
    print("if", "second // zamanı geldi")
                boolStatus = false
                status = NSLocalizedString("full_time", comment: "")
                if (bet == 1.1) {
    print("if", "bet == 1.1 // btts yes")
                    if ( localScore > 0 && visitorScore > 0) {
                        boolStatus = true
                        status = NSLocalizedString("both_teams_scored", comment: "")
                    } else { status = NSLocalizedString("one_team_didnt_score", comment: "")}
    }   else if (bet == -1.1) {
    print("if", "bet == -1.1 // btts no")
                    if (localScore == 0 || visitorScore == 0) {
                        boolStatus = true
                        status = NSLocalizedString("one_team_didnt_score", comment: "")
                    } else { status = NSLocalizedString("both_teams_scored", comment: "")}
    }   else if (bet == -8.8) {
    print("if", "bet == -8.8 // skor")
    status = NSLocalizedString("score_info", comment: "")
    boolStatus = true
    }   else if (bet == -9.9) {
       print("if", "bet == -9.9 // no goal")
       if (Int(localScore) == 0 && Int(visitorScore) == 0) {
        boolStatus = true
    status = NSLocalizedString("no_goal", comment: "")
       } else { status = NSLocalizedString("there_is_a_scorer", comment: "")}
    }
    else {
    if (bet > 0) {
    print("if", "bet > 0")
    if (Int(bet) < total) {
    print("if", "bet < total")
    status = NSLocalizedString("success", comment: "")
        boolStatus = true
        
        if(total > 0 ){status = NSLocalizedString("there_is_a_scorer", comment: "")}
        if(total > 1 ){status = NSLocalizedString("two_goals_in_match", comment: "")}
        if(total > 2 ){status = NSLocalizedString("its_over_25", comment: "")}
        if(total > 3 ){status = NSLocalizedString("its_over_35", comment: "")}
        if(total > 4 ){status = NSLocalizedString("its_over_45", comment: "")}
    } else {status = "It's \(bet) !" }
    } else if (Swift.abs(bet) > Double(total)) {
    print("else if", "Math.abs(bet) > total")
    status = NSLocalizedString("success", comment: "")
        boolStatus = true
        if(bet == -0.5 ){status = NSLocalizedString("no_goal", comment: "")}
        if(bet == -1.5 ){status = NSLocalizedString("it_is_over_eksi15", comment: "")}
        if(bet == -2.5 ){status = NSLocalizedString("it_is_over_eksi25", comment: "")}
        if(bet == -3.5 ){status = NSLocalizedString("it_is_over_eksi35", comment: "")}
        if(bet == -4.5 ){status = NSLocalizedString("it_is_over_eksi45", comment: "")}
    } else {
        
        status = "\(bet) !"}
    }
    
    let aa : String  = NSLocalizedString("full_time", comment: "")
                
    let bb = "\(aa),\(status)"
    notif(dbidd: Int(dbidd), localTeam: localTeam, visitorTeam: visitorTeam, localScore: localScore, visitorScore: visitorScore, minute: minute, sstatus: bb ,  boolStatus: boolStatus)
    callDelete(dbid: dbidd)
         
    }
    } else {
    print("else", "min !> 0 // macın minute'ı 0dan buyuk degil // mac  bitti demek")
            status = NSLocalizedString("full_time_failed", comment: "")
            boolStatus = false
            
            notif(dbidd: Int(dbidd), localTeam: localTeam, visitorTeam: visitorTeam, localScore: localScore, visitorScore: visitorScore, minute: minute, sstatus: status ,  boolStatus: boolStatus)
            callDelete(dbid: dbidd)

    }
    break
        
    default: // NORMAL DK LAR
    print("NORMAL DK LAR", "BET :  \(bet)"+" TOTAL :  \(total)" + " - ALARM MIN : \(alarmMin)")
        if (minute >= 0 && !second) {
    print("if", "min > 0 // yani maç oynanıyor")
            
            if (alarmMin <= minute) {
                status = NSLocalizedString("failed", comment: "")
                boolStatus = false
                print("if", "zamanı geldi")
            if (bet == 1.1) {
                    print("if", "bet == 1.1 // btts yes")
            if (localScore > 0 && visitorScore > 0) {
                boolStatus = true
                 status = NSLocalizedString("both_teams_scored", comment: "")
            } else { status = NSLocalizedString("one_team_didnt_score", comment: "")}
    }  else if (bet == -1.1) {
                print("if", "bet == -1.1 // btts no")
             if (Int(localScore) == 0 || Int(visitorScore) == 0) {
                boolStatus = true
                status = NSLocalizedString("one_team_didnt_score", comment: "")
             } else {  status = NSLocalizedString("both_teams_scored", comment: "")}
    }
            else if (bet == -8.8) {
    print("if", "bet == -8.8 // skor")
                status = NSLocalizedString("score_info", comment: "")
                boolStatus = true
    } else if (bet == -9.9) {
    print("if", "bet == -9.9 // no goal")
                    if (localScore == 0 && visitorScore == 0) {
                        boolStatus = true
                        status = NSLocalizedString("no_goal_yet", comment: "")
                    } else { status = NSLocalizedString("already_goal", comment: "")}
    }
            else {
                    if (bet > 0) {
                        print("if", "bet > 0")
                        if (Int(bet) < total) {
                            print("3. if", "bet < total")
                            status = NSLocalizedString("success", comment: "")
                            boolStatus = true
                            if(total > 0 ){status = NSLocalizedString("its_over_05", comment: "")}
                            if(total > 1 ){status = NSLocalizedString("its_over_15", comment: "")}
                            if(total > 2 ){status = NSLocalizedString("its_over_25", comment: "")}
                            if(total > 3 ){status = NSLocalizedString("its_over_35", comment: "")}
                            if(total > 4 ){status = NSLocalizedString("its_over_45", comment: "")}
                        }else {status = "\(bet) !"}
    }
                    else if (Swift.abs(bet) > Double(total)) {
                        print("else if", "Math.abs(bet) > total")
                        status = NSLocalizedString("success", comment: "")
                        boolStatus = true
                        if(bet == -0.5 ){status = NSLocalizedString("no_goal", comment: "")}
                        if(bet == -1.5 ){status = NSLocalizedString("it_is_over_eksi05", comment: "")}
                        if(bet == -2.5 ){status = NSLocalizedString("it_is_over_eksi15", comment: "")}
                        if(bet == -3.5 ){status = NSLocalizedString("it_is_over_eksi25", comment: "")}
                        if(bet == -4.5 ){status = NSLocalizedString("it_is_over_eksi35", comment: "")}
                    }else {
                        let aa  = NSLocalizedString("its", comment: "")
                        status = "\(aa)'\(bet) !"}
                }
                callDelete(dbid: dbidd)
               
                notif(dbidd: Int(dbidd), localTeam: localTeam, visitorTeam: visitorTeam, localScore: localScore, visitorScore: visitorScore, minute: minute, sstatus: status,  boolStatus: boolStatus)
               
    }
    } else {
    print("else", "min !> 0 // macın minute'ı 0dan buyuk degil // mac  bitti demek")
            status = NSLocalizedString("failed", comment: "")
            boolStatus = false
            
            callDelete(dbid: dbidd)
            notif(dbidd: Int(dbidd), localTeam: localTeam, visitorTeam: visitorTeam, localScore: localScore, visitorScore: visitorScore, minute: minute, sstatus: status ,  boolStatus: boolStatus)
            
    }
    break
    }
} //operation func finish
   
  
    func PostMatch (arrMatchId : Array<Int> , arrDbId : Array<Int64>){
        print("POST MATCH KISMINA GELDİİİ")
         let alert_url = URL(string: "http://opucukgonder.com/tipster/index.php/Service/liveLeague")!
        var alert_request = URLRequest(url: alert_url)
        alert_request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      
        alert_request.httpMethod = "POST"
    
        let matchIdArray = "match_id=\(arrMatchId)"
        //print(matchIdArray)
        //print(arrMatchId)
        alert_request.httpBody = matchIdArray.data(using: .utf8)
        
        let alert_session = URLSession.shared
        let alert_task = alert_session.dataTask(with: alert_request) { dataa, response, error in
        
            if error != nil{
                print ("Get Request Error")
            }
            else{
                if dataa != nil{
                    do{
                        
                        let alertResult = try JSONSerialization.jsonObject(with: dataa!) as! Array<Dictionary<String,Any>>
                        print(alertResult)
                     
                        DispatchQueue.main.async {
                            print("MAÇ POST EDİLDİ")
                            let alertArray : [Any]!  = alertResult 
                            
                            for i in 0 ..< alertArray.count  {
                                let matchObjects = alertArray[i] as! [String : AnyObject]
                               
                                let localTeam : String = String(describing: matchObjects["local"]!)
                                let visitorTeam : String = String(describing: matchObjects["visitor"]!)
                                let minute = matchObjects["minute"] as! Int
                                let localScore = matchObjects["localScore"] as! String
                                let visitorScore = matchObjects["visitorScore"] as! String
                                let first : Bool = matchObjects["first"] as! Bool
                                let second : Bool = matchObjects["second"] as! Bool
                                
                                self.operation(matchidd: arrMatchId[i], localTeam: localTeam, visitorTeam: visitorTeam, localScore: Int(localScore)!, visitorScore: Int(visitorScore)!, minute: minute, first: first, second: second, dbidd: Int64(arrDbId[i]))
                        }
                        }
                    }
                    catch{
                        let responseString = String(data: dataa!, encoding: .utf8)
                        print("raw response: \(String(describing: responseString))")
                    
                    }
                }
            }
    }
        alert_task.resume()
    }
    
    func StartTimer(){
     
         print("SERVİSE GİRDİİİİİ")
        if timer == nil {
            // One Signal Idsini Alma
            let status :OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
            let userID = status.subscriptionStatus.userId
            
            
            if userID != nil {
               UserDefaults.standard.setValue(userID, forKey: "oneSignal")
                oneSignalId = UserDefaults.standard.value(forKey: "oneSignal")! as! String
                print(oneSignalId)
            }
            
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.initializeTimer), userInfo: nil, repeats: true)
            print("TIMER ATEŞLENDİİİİ")
        }
    }
    func stopTimer() {
        if ( timer != nil && dbHelper.getAllData().count == 0) {
            timer?.invalidate()
            timer = nil
        }
    }
    func initializeTimer(){
        var arrMatchId = Array<Int>()
        var arrDbId = Array<Int64>()
        
        for k in 0 ..< dbHelper.getAllData().count{
            do{
                let arr : [Alert] = try dbHelper.getAllData()
                arrMatchId.append(arr[k].matchId)
                arrDbId.append(arr[k].id!)
            }
            catch{ print(" SERVICE DB ERROR") }
        }
        if (arrDbId.count != 0){
            PostMatch(arrMatchId: arrMatchId, arrDbId: arrDbId)
            print("MAÇI BURADA POST ETMEYE BAŞLAMASI LAZIM")
            let myMatchList = [Int](arrMatchId)
            UserDefaults.standard.set(myMatchList,forKey: "myMatchList")
        }
    }
    
    
}
