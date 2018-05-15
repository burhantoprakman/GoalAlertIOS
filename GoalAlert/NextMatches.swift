//
//  NextMatches.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 04/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import Toaster

class NextMatches: UIViewController , UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var NextMatchesTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    private var n_result = [NextMatchesPojo]()
    private var day : Int!
    var date = Date()
    @IBOutlet weak var nTabItem: UITabBarItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "goalalertsu.jpg") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        day = 1
        NextMatchesTableView.delegate = self
        NextMatchesTableView.dataSource = self
        dateFunc()
        getNextMatches()
    
    }
    
    func dateFunc(){
        
        date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        dateLabel.text = result
        
        
    }
    
    
    
    @IBAction func nextMatchButton(_ sender: Any) {
        
        if (day != 8) {
            day=day+1
            let toast : Toast! = Toast(text: "Please Wait", delay: Delay.short, duration: Delay.long)
            toast.show()
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let result = formatter.string(from: date)
            dateLabel.text = result
            getNextMatches()
            
            
        }
    }
    
    
    @IBAction func prevMatchButton(_ sender: Any) {
        
        if (day != 1) {
          
            day = day-1;
            let toast : Toast! = Toast(text: "Please Wait", delay: Delay.short, duration: Delay.long)
            toast.show()
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let result = formatter.string(from: date)
            dateLabel.text = result
            getNextMatches()
            
        }
    }
    
    func getNextMatches()
    {
        var resultArray  = [NextMatchesPojo]()
        let url = URL(string: "http://opucukgonder.com/tipster/index.php/Service/next_matches")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let dayValue = String (day)
        let postString = "day=\(dayValue)"
        request.httpBody = postString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request ){ data, response, error in
            
            
            if error != nil{
                print("Get Request Error")
            }
            else{
                
                if data != nil {
                    
                    do {
                        let JsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Array<Dictionary<String,Any>>
                    
                        
                        DispatchQueue.main.async {
                            let totalarray : [Any]!  = JsonResult
                            
                            for i in 0 ..< totalarray.count  {
                                let matches = totalarray[i] as! [String : AnyObject]
                                let leaguename : String = String(describing: matches["league_name"]!)
                                let leagueId = matches["league_id"]! as! Int
                                let flags : String = String(describing: matches["flags"]!)
                                let matchArray = matches["match"] as! [Any]
                                var nextmatchpojo = NextMatchesPojo.init(leagueId: leagueId, leagueName: leaguename, flagg : flags)
                                resultArray.append(nextmatchpojo)
                                
                                for j in 0 ..< matchArray.count {
                                    
                                    let matchesinmatches = matchArray[j] as! [String : AnyObject]
                                    let matchId = matchesinmatches["match_id"] as! Int
                                    let localTeam : String = matchesinmatches["localteam"]! as! String
                                    let visitorTeam : String = matchesinmatches["visitorteam"]! as! String
                                    var hour =  matchesinmatches["hour"] as! Int
                                    let minute = matchesinmatches["minute"] as! Int
                                    
                                    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
                                    
                                    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
                                        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
                                    }
                                    let (h,m,_) = secondsToHoursMinutesSeconds(seconds: secondsFromGMT)
                                    
                                    
                                    var hourr = hour + h
                                    hourr %= 24
                                    var lastHour  = String ( hourr )
                                    var lastMinute = String ( minute + m )
                                    
                                    
                                    
                                    if( lastHour == "0"){
                                        lastHour = "00"
                                    }
                                    if( lastMinute == "0" ){
                                        lastMinute = "00"
                                    }
                                    
                                    
                                    nextmatchpojo = NextMatchesPojo.init(leagueId: leagueId, matchId: matchId, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, hour : lastHour , minute: lastMinute)
                                    resultArray.append(nextmatchpojo)
                                    
                                }
                                
                            }
                            
                        }
                        DispatchQueue.main.async {
                            self.n_result = resultArray
                            self.NextMatchesTableView.reloadData()
                        }
                        
                        
                    } // do bitişi
                    catch {
                        print("CATCH OLDU")
                    }
                }
                
            }
            
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:NextMatchesCell = self.NextMatchesTableView.dequeueReusableCell(withIdentifier: "nextmatchescell") as! NextMatchesCell
        let goCell  =  n_result[indexPath.row]
        cell.setArray(mdataset: goCell)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return n_result.count
    }

    
}
