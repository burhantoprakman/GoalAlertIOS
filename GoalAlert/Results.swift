//
//  Results.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 04/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit

class Results: UIViewController , UITableViewDelegate , UITableViewDataSource{
    @IBOutlet weak var ResultTableView: UITableView!
    @IBOutlet weak var rdateLabel: UILabel!
    private var r_result = [ResultPojo]()
    private var day : Int!
    var date = Date()
  
    @IBOutlet weak var rTabItem: UITabBarItem!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "goalalertsu.jpg") {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        }
        day = 1
      
        // Do any additional setup after loading the view, typically from a nib.
        ResultTableView.dataSource = self
        ResultTableView.delegate  = self
        dateFunc()
        getPreviousMatches()
        
        
    }
    
    @IBAction func nextDayButton(_ sender: Any) {
            if (day != 1) {
            day = day-1;
            //Toast.makeText(getContext(), "Please wait", Toast.LENGTH_SHORT).show();
        
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let result = formatter.string(from: date)
            rdateLabel.text = result
            getPreviousMatches()
       
        }

    }
    @IBAction func previousDayButton(_ sender: Any) {
        
        if (day != 8) {
            day = day+1
            //Toast.makeText(getContext(), "Please wait", Toast.LENGTH_SHORT).show();
           
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let result = formatter.string(from: date)
            rdateLabel.text = result
            getPreviousMatches()
    
        }
        
    }
    
    func dateFunc(){
        
        date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        rdateLabel.text = result
        
        
    }
    
  
    
    
    
    func getPreviousMatches()
    {
        var resultArray  = [ResultPojo]()
        let url = URL(string: "http://opucukgonder.com/tipster/index.php/Service/previous_matches")!
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
                        print(JsonResult)
                        
                        DispatchQueue.main.async {
                            let totalarray : [Any]!  = JsonResult
                            
                            for i in 0 ..< totalarray.count  {
                                let matches = totalarray[i] as! [String : AnyObject]
                                let leaguename : String = String(describing: matches["league_name"]!)
                                let leagueId = matches["league_id"]! as! Int
                                let flags : String = String(describing: matches["flags"]!)
                                let matchArray = matches["match"] as! [Any]
                                var resultpojo = ResultPojo.init(leagueId: leagueId, leagueName: leaguename, flagg : flags)
                                resultArray.append(resultpojo)
                                
                                for j in 0 ..< matchArray.count {
                                    
                                    let matchesinmatches = matchArray[j] as! [String : AnyObject]
                                    let matchId = matchesinmatches["match_id"] as! Int
                                    let localTeam : String = String(describing: matchesinmatches["localteam"]!)
                                    let visitorTeam : String = String(describing: matchesinmatches["visitorteam"]!)
                                    let localScore = matchesinmatches["localScore"] as! Int
                                    let visitorScore = matchesinmatches["visitorScore"] as! Int
                                    resultpojo = ResultPojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags)
                                    resultArray.append(resultpojo)
                                
                            }
                            
                        }
                        
                    }
                        DispatchQueue.main.async {
                            self.r_result = resultArray
                            self.ResultTableView.reloadData()
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
        
        let cell:ResultCell = self.ResultTableView.dequeueReusableCell(withIdentifier: "resultcell") as! ResultCell
        let goCell  =  r_result[indexPath.row]
        cell.setArray(mdataset: goCell)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return r_result.count
    }

  
    
    
}
