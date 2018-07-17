//
//  LiveScores.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 04/12/2017.
//  Copyright © 2017 Burhan TOPRAKMAN. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import Toaster
import OneSignal


class LiveScores: UIViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate , GADInterstitialDelegate
{
   
    
    @IBOutlet weak var liveScoreTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var out_btn_NOGOAL: UIButton!
    @IBOutlet weak var out_btn_DRAW: UIButton!
    @IBOutlet weak var out_btn_WINTONIL: UIButton!
    @IBOutlet weak var out_btn_05: UIButton!
    @IBOutlet weak var out_btn_15: UIButton!
    @IBOutlet weak var out_btn_25: UIButton!
    @IBOutlet weak var golhunfFilterView: UIView!
    @IBOutlet weak var out_homewin: UIButton!
    @IBOutlet weak var out_awaywin: UIButton!
    @IBOutlet weak var lTabItem: UITabBarItem!
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var sifirOtuz: UIButton!
    @IBOutlet weak var otuzAltmis: UIButton!
    @IBOutlet weak var atmisDoksan: UIButton!
    @IBOutlet weak var genericButton: UIButton!
    @IBOutlet weak var noMatchLabel: UILabel!
    
    private var huntFilter : Int = 0
    private var huntFilterMin : Int = 0
    
    @IBOutlet weak var buneview: UIView!
    private  var flag : Bool! = true
    private  var matrix =  Array(repeating: Array(repeating: Array(repeating: 0, count: 700), count: 700),count: 700)
    private var button : UIButton!
    private var selectedButton : UIButton!
    
    var selectItem : Int = 0
    var send_localTeam : String = ""
    var send_visitorTeam : String = ""
    var send_matchId : Int = 0
    var send_minute : Int  = 0
    var send_localScore : Int  = 0
    var send_visitorScore : Int  = 0
    var sayac : Int = 0
    var isMatchLength : Bool = false
    var matchLength : Int = 0
    var result = [LiveScorePojo]()
    var resultSariCanlar = [LiveScorePojo]()
    var filtered = [LiveScorePojo]()
    var isSearching : Bool = false
    var interstitial: GADInterstitial!
    var toast1: Toast = Toast(text: "Please Wait", delay: Delay.short, duration: Delay.long)

    
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
        self.view.backgroundColor = hexStringToUIColor(hex:"#355873")
        if let image = UIImage(named: "goalalertsu.jpg"){
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        
            self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: .default)
            self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 40, width: 150, height: 30)
              self.navigationController?.navigationBar.contentMode = .center
            toast1.view.layoutMargins.bottom = 30
        }
       
        self.liveScoreTableView.addSubview(self.refreshControl)
        huntFilter = 0
        huntFilterMin = 0
        
        noMatchLabel.text = NSLocalizedString("no_match_for_filter", comment: "")
        noMatchLabel.textColor = UIColor.white
    
        
        let attrs = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Georgia-Bold", size: 10)!
        ]
        if let downcastStrings = self.tabBarController?.tabBar.items
        {
            downcastStrings[0].image = UIImage(named: "Image")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            downcastStrings[0].title = NSLocalizedString("live", comment: "")
            downcastStrings[0].setTitleTextAttributes(attrs , for: .normal)
            downcastStrings[1].title = NSLocalizedString("nextmatch", comment: "")
            downcastStrings[1].setTitleTextAttributes(attrs , for: .normal)
            downcastStrings[1].image = UIImage(named: "Image-3")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            downcastStrings[2].title = NSLocalizedString("result", comment: "")
            downcastStrings[2].setTitleTextAttributes(attrs, for: .normal)
            downcastStrings[2].image = UIImage(named: "Image-1")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            downcastStrings[3].title = NSLocalizedString("alerts", comment: "")
            downcastStrings[3].setTitleTextAttributes(attrs , for: .normal)
            downcastStrings[3].image = UIImage(named: "Image-2")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
      
        out_btn_NOGOAL.setTitle(NSLocalizedString("no_goal", comment: ""), for: .normal)
        out_btn_DRAW.setTitle(NSLocalizedString("draw", comment: ""), for: .normal)
        out_btn_WINTONIL.setTitle(NSLocalizedString("win_to_nil", comment: ""), for: .normal)
        genericButton.setTitle(NSLocalizedString("set_generic", comment: ""), for: .normal)
        out_homewin.setTitle(NSLocalizedString("home_win", comment: ""), for: .normal)
        out_awaywin.setTitle(NSLocalizedString("away_win", comment: ""), for: .normal)
        out_btn_05.setTitle(NSLocalizedString("one_or_two_goal", comment: ""), for: .normal)
        out_btn_15.setTitle("-2.5", for: .normal)
         out_btn_25.setTitle("+2.5", for: .normal)
        
        let tempImageView = UIImageView(image: UIImage(named: "bg.jpg"))
        tempImageView.frame = self.liveScoreTableView.frame
        self.liveScoreTableView.backgroundView = tempImageView;
        
        //Bottom BannerAd
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        

        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        
       
        //TableView Sources
        liveScoreTableView.delegate = self
        liveScoreTableView.dataSource = self
        searchBar.delegate = self
        definesPresentationContext = true
        
        
      
       
      
        golhunfFilterView.backgroundColor = hexStringToUIColor(hex:"#355873")
        buneview.backgroundColor = hexStringToUIColor(hex:"#355873")
        
        out_btn_05.layer.cornerRadius = out_btn_05.frame.height / 3
        out_btn_05.backgroundColor = hexStringToUIColor(hex:"#192A50")
        out_btn_05.layer.borderWidth = 2
        out_btn_05.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        
        out_btn_15.layer.cornerRadius = out_btn_05.frame.height / 3
        out_btn_15.backgroundColor = hexStringToUIColor(hex:"#192A50")
        out_btn_15.layer.borderWidth = 2
        out_btn_15.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        
        out_btn_25.layer.cornerRadius = out_btn_05.frame.height / 3
         out_btn_25.backgroundColor = hexStringToUIColor(hex:"#192A50")
        out_btn_25.layer.borderWidth = 2
        out_btn_25.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        
        out_btn_NOGOAL.layer.cornerRadius = out_btn_05.frame.height / 3
         out_btn_NOGOAL.backgroundColor = hexStringToUIColor(hex:"#192A50")
        out_btn_NOGOAL.layer.borderWidth = 2
        out_btn_NOGOAL.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        
        out_btn_WINTONIL.layer.cornerRadius = out_btn_05.frame.height / 3
         out_btn_WINTONIL.backgroundColor = hexStringToUIColor(hex:"#192A50")
        out_btn_WINTONIL.layer.borderWidth = 2
        out_btn_WINTONIL.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        out_btn_DRAW.layer.cornerRadius = out_btn_05.frame.height / 3
         out_btn_DRAW.backgroundColor = hexStringToUIColor(hex:"#192A50")
        out_btn_DRAW.layer.borderWidth = 2
        out_btn_DRAW.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        
        out_homewin.layer.cornerRadius = out_btn_05.frame.height / 3
         out_homewin.backgroundColor = hexStringToUIColor(hex:"#192A50")
        out_homewin.layer.borderWidth = 2
        out_homewin.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        
        out_awaywin.layer.cornerRadius = out_btn_05.frame.height / 3
         out_awaywin.backgroundColor = hexStringToUIColor(hex:"#192A50")
        out_awaywin.layer.borderWidth = 2
        out_awaywin.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        
        
        sifirOtuz.layer.cornerRadius = out_btn_05.frame.height / 3
         sifirOtuz.backgroundColor = hexStringToUIColor(hex:"#192A50")
        sifirOtuz.layer.borderWidth = 2
        sifirOtuz.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        
        otuzAltmis.layer.cornerRadius = out_btn_05.frame.height / 3
         otuzAltmis.backgroundColor = hexStringToUIColor(hex:"#192A50")
        otuzAltmis.layer.borderWidth = 2
        otuzAltmis.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        
        
        atmisDoksan.layer.cornerRadius = out_btn_05.frame.height / 3
         atmisDoksan.backgroundColor = hexStringToUIColor(hex:"#192A50")
        atmisDoksan.layer.borderWidth = 2
        atmisDoksan.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        
        genericButton.layer.cornerRadius = out_btn_05.frame.height / 3
        genericButton.backgroundColor = hexStringToUIColor(hex:"#192A50")
        genericButton.layer.borderWidth = 1
        genericButton.layer.borderColor = hexStringToUIColor(hex: "#3E7ACA").cgColor
        		
        
        //Date Func
        date()
        getLiveMatches(url : URL(string: "http://opucukgonder.com/tipster/index.php/Service/lastLiveNew"))
      
        
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:LiveScoresCell = self.liveScoreTableView.dequeueReusableCell(withIdentifier: "livescorecell") as! LiveScoresCell
        if(result.count != 0 || filtered.count != 0 ){
            
            var bellColor : Bool = false
            for i in 0 ..< resultSariCanlar.count{
        
                    if(resultSariCanlar[i].matchId == result[indexPath.row].matchId){
                        bellColor = true
                    }
                    else{
                        bellColor = false
                    }

            }
            
            
            if(isSearching == true){
                let aaa  =  filtered[indexPath.row]
                cell.setArray(mdataset: aaa,color:bellColor)
            }
            else {
                let aaa  =  result[indexPath.row]
                cell.setArray(mdataset: aaa,color:bellColor)
            }
            cell.out_alarmButton.tag = indexPath.row
            cell.out_alarmButton.addTarget(self, action: #selector(alarmClickedd(sender:)), for: .touchUpInside )
            cell.selectionStyle = .none
            
        }
        
       
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearching == true){
            return filtered.count
        }
        else { return result.count }
    }
    
 
   
    
    func alarmClickedd( sender: UIButton) {
    
        if (isSearching == true){
            
            send_localTeam = filtered[sender.tag].localTeam
            send_visitorTeam = filtered[sender.tag].visitorTeam
            send_matchId = filtered[sender.tag].matchId
            send_minute = filtered[sender.tag].minute
            send_localScore = filtered[sender.tag].localScore
            send_visitorScore = filtered[sender.tag].visitorScore
        }else{
        send_localTeam = result[sender.tag].localTeam
        send_visitorTeam = result[sender.tag].visitorTeam
        send_matchId = result[sender.tag].matchId
         send_minute = result[sender.tag].minute
         send_localScore = result[sender.tag].localScore
         send_visitorScore = result[sender.tag].visitorScore
         }
       
   
         /*if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            
        } */
        
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateAlertVC") as! CreateAlertVC
            myVC.matchId = send_matchId
            myVC.localTeam  = send_localTeam
            myVC.visitorTeam = send_visitorTeam
            myVC.Minute = send_minute
            myVC.LocalTeamScore = send_localScore
            myVC.visitorTeamScore = send_visitorScore
            myVC.isGeneric = false
            myVC.genericArray = result
        
           self.present(myVC, animated: true)
    
       
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
      getLiveMatches(url : URL(string: "http://opucukgonder.com/tipster/index.php/Service/lastLiveNew"))
    }
    override func viewWillAppear(_ animated: Bool) {
        getLiveMatches(url : URL(string: "http://opucukgonder.com/tipster/index.php/Service/lastLiveNew"))
    }

   
    func getLiveMatches(url : URL!){
       
        var liveArray  = [LiveScorePojo]()
        let userid = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId!
        let config = URLSessionConfiguration.default
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "deviceid=\(userid)"
        let session: URLSession = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())
        request.httpBody = postString.data(using: .utf8)
        
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if error != nil{
                print("Get Request Error")
            }
            else{
                
            if data != nil {
                
                do {
                    
                   
                    let JsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                   
            
                    DispatchQueue.main.async {
                        let totalarray = JsonResult["lives"] as! NSArray
                        let sariCanlarArray = JsonResult["sariCanlar"] as! NSArray
                        /*for k in 0 ..< sariCanlarArray.count{
                            let aa = sariCanlarArray[k] as! [String:Any]
                            let saricanlarPojo = LiveScorePojo.init(leagueId: 0, matchId: aa["match_id"] as! Int, localScore: 0, visitorScore: 0, minute: 0, preLocalScore: 0, preVisitorScore: 0, preMinute: 0, leagueName: "", localTeam: "", visitorTeam: "", flagg: "", ilkflag: false, isMatchLength: false)
                             self.resultSariCanlar.append(saricanlarPojo)
                        }*/
                       
                        if(self.matchLength != 0){
                            if(self.matchLength == totalarray.count){
                                self.isMatchLength = true
                            }
                            else{
                                self.isMatchLength = false
                            }
                        }
                        self.matchLength = totalarray.count
                      
                        for i in 0 ..< totalarray.count  {
                            let matches = totalarray[i] as! [String:Any]
                            let leaguename : String = String(describing: matches["league_name"]!)
                            let leagueId = matches["league_id"]! as! Int
                            let flags : String = String(describing: matches["flags"]!)
                            let matchArray = matches["match"] as! [Any]
                            var livepojo = LiveScorePojo.init(leagueId: leagueId, leagueName: leaguename, flagg : flags)
                            
                            var isLeaugeFirst:Bool = true;
                        
                            for j in 0 ..< matchArray.count {
                          
                                
                                
                                let matchesinmatches = matchArray[j] as! [String : AnyObject]
                                let matchId = matchesinmatches["match_id"] as! Int
                                let localTeam : String = String(describing: matchesinmatches["localteam"]!)
                                let visitorTeam : String = String(describing: matchesinmatches["visitorteam"]!)
                                let minute = matchesinmatches["minute"] as! Int
                                let localScore = matchesinmatches["localScore"] as! Int
                                let visitorScore = matchesinmatches["visitorScore"] as! Int
                             
                                switch (self.huntFilter) {
                                
                                case 1:
                                    
                              
                                    
                                    if( (localScore == 0 ) && (visitorScore == 0)) {
                                        if(self.methodForHuntFilterMin(minute: minute)){
                                           
                                        if (isLeaugeFirst) {
                                            liveArray.append(livepojo)
                                            isLeaugeFirst = false;
                                        }
                                      
                                        if (self.flag)
                            
                                        {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore , visitorScore: visitorScore, minute: minute, preLocalScore: -1, preVisitorScore: -1, preMinute: -1, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg : flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                        }
                                        else {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore , visitorScore: visitorScore, minute: minute , preLocalScore: self.matrix[i][j][0], preVisitorScore: self.matrix[i][j][1], preMinute: self.matrix[i][j][2], leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                    
                                            
                                            
                                        }
                                        
                                        self.matrix[i][j][0] = localScore
                                        self.matrix[i][j][1] = visitorScore
                                        self.matrix[i][j][2] = minute
                                        
                                        liveArray.append(livepojo)
                                    }
                                         }
                                    self.liveScoreTableView.reloadData()
                                    
                                    break
                                    
                                case 2:
                             
                                    
                                    if ((localScore == visitorScore) && (visitorScore > 0) && (localScore > 0) ) {
                                        if(self.methodForHuntFilterMin(minute: minute)){
                                        if (isLeaugeFirst) {
                                            liveArray.append(livepojo)
                                            isLeaugeFirst = false;
                                        }
                                        if (self.flag) {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId , localScore: localScore , visitorScore: visitorScore, minute: minute , preLocalScore: -1, preVisitorScore: -1, preMinute: -1, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                       
                                        }
                                        else
                                        {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore , visitorScore: visitorScore , minute: minute , preLocalScore: self.matrix[i][j][0], preVisitorScore: self.matrix[i][j][1], preMinute: self.matrix[i][j][2], leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                            
                                            
                                            
                                            
                                        }
                                        
                                        self.matrix[i][j][0] = localScore
                                        self.matrix[i][j][1] = visitorScore
                                        self.matrix[i][j][2] = minute
                                        
                                        liveArray.append(livepojo)
                                    }
                                    }
                                    self.liveScoreTableView.reloadData()
                                    break
                                    
                                case 3:
                                    
                                
                                    
                                    if (((localScore  == 0) && (visitorScore > 0)) || ((visitorScore == 0) && (localScore  > 0)) ) {
                                        if(self.methodForHuntFilterMin(minute: minute)){
                                        if (isLeaugeFirst) {
                                            liveArray.append(livepojo)
                                            isLeaugeFirst = false;
                                        }
                                        if (self.flag) {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId , localScore: localScore, visitorScore: visitorScore, minute: minute, preLocalScore: -1, preVisitorScore: -1, preMinute: -1, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                    
                                        }
                                        else {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore , visitorScore: visitorScore, minute:
                                                minute, preLocalScore: self.matrix[i][j][0], preVisitorScore: self.matrix[i][j][1], preMinute: self.matrix[i][j][2], leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                   }
                                        
                                        self.matrix[i][j][0] = localScore
                                        self.matrix[i][j][1] = visitorScore
                                        self.matrix[i][j][2] = minute
                                        
                                        liveArray.append(livepojo)
                                    }
                                    }
                                    self.liveScoreTableView.reloadData()
                                    break
                                    
                                case 4:
                              
                                    
                                    
                                    if ((localScore  + visitorScore) > 0 && (localScore  + visitorScore) < 3) {
                                        if(self.methodForHuntFilterMin(minute: minute)){
                                        if (isLeaugeFirst) {
                                            liveArray.append(livepojo)
                                            isLeaugeFirst = false;
                                        }
                                        if (self.flag) {
                                            livepojo =  LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute: minute, preLocalScore: -1, preVisitorScore: -1, preMinute: -1, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                               
                                        }
                                        else
                                        {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute:
                                                minute, preLocalScore: self.matrix[i][j][0], preVisitorScore: self.matrix[i][j][1], preMinute: self.matrix[i][j][2], leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                            }
                        
                                        self.matrix[i][j][0] = localScore
                                        self.matrix[i][j][1] = visitorScore
                                        self.matrix[i][j][2] = minute
                                        
                                        liveArray.append(livepojo)
                                    }
                                    }
                          self.liveScoreTableView.reloadData()
                                    break
                                case 5:
                                    
                                  
                                    if ((localScore  + visitorScore) < 3 ) {
                                         if(self.methodForHuntFilterMin(minute: minute)){
                                        if (isLeaugeFirst) {
                                            liveArray.append(livepojo)
                                            isLeaugeFirst = false;
                                        }
                                        if (self.flag) {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute: minute, preLocalScore: -1, preVisitorScore: -1, preMinute: -1, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                            
                                        }
                                        else {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute:
                                                minute, preLocalScore: self.matrix[i][j][0], preVisitorScore: self.matrix[i][j][1], preMinute: self.matrix[i][j][2], leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                        }
                                        
                                        self.matrix[i][j][0] = localScore
                                        self.matrix[i][j][1] = visitorScore
                                        self.matrix[i][j][2] = minute
                                        
                                        
                                        liveArray.append(livepojo)
                                    }
                                    }
                                    self.liveScoreTableView.reloadData()
                                    break
                                case 6:
                                
                                    
                                    if ((localScore + visitorScore )  > 2) {
                                         if(self.methodForHuntFilterMin(minute: minute)){
                                        if (isLeaugeFirst) {
                                            liveArray.append(livepojo)
                                            isLeaugeFirst = false;
                                        }
                                        if (self.flag) {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute: minute, preLocalScore: -1, preVisitorScore: -1, preMinute: -1, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                        }
                                        else {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute:
                                                minute , preLocalScore: self.matrix[i][j][0], preVisitorScore: self.matrix[i][j][1], preMinute: self.matrix[i][j][2], leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                        }
                                        
                                        self.matrix[i][j][0] = localScore
                                        self.matrix[i][j][1] = visitorScore
                                        self.matrix[i][j][2] = minute
                                        
                                      liveArray.append(livepojo)
                                    }
                                    }
                                    self.liveScoreTableView.reloadData()
                                    break
                                case 7:
                                    
                              
                                    if (localScore > visitorScore ) {
                                         if(self.methodForHuntFilterMin(minute: minute)){
                                        if (isLeaugeFirst) {
                                            liveArray.append(livepojo)
                                            isLeaugeFirst = false;
                                        }
                                        if (self.flag) {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute: minute, preLocalScore: -1, preVisitorScore: -1, preMinute: -1, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                        }
                                        else {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute:
                                                minute , preLocalScore: self.matrix[i][j][0], preVisitorScore: self.matrix[i][j][1], preMinute: self.matrix[i][j][2], leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                        }
                                        
                                        self.matrix[i][j][0] = localScore
                                        self.matrix[i][j][1] = visitorScore
                                        self.matrix[i][j][2] = minute
                                        
                                        liveArray.append(livepojo)
                                    }
                                    }
                                    self.liveScoreTableView.reloadData()
                                    break
                                case 8:
                                    
                                   
                                    
                                    if (localScore < visitorScore ) {
                                         if(self.methodForHuntFilterMin(minute: minute)){
                                        if (isLeaugeFirst) {
                                            liveArray.append(livepojo)
                                            isLeaugeFirst = false;
                                        }
                                        if (self.flag) {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute: minute, preLocalScore: -1, preVisitorScore: -1, preMinute: -1, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                        }
                                        else {
                                            livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute:
                                                minute , preLocalScore: self.matrix[i][j][0], preVisitorScore: self.matrix[i][j][1], preMinute: self.matrix[i][j][2], leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                        }
                                        
                                        self.matrix[i][j][0] = localScore
                                        self.matrix[i][j][1] = visitorScore
                                        self.matrix[i][j][2] = minute
                                        
                                        liveArray.append(livepojo)
                                    }
                                    }
                                    self.liveScoreTableView.reloadData()
                                    break
                            
                                    
                                default:
                                    
                                    if(self.methodForHuntFilterMin(minute: minute)){
                                    if (isLeaugeFirst) {
                                        liveArray.append(livepojo)
                                        isLeaugeFirst = false;
                                    }
                                    if (self.flag) {
                                        livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute: minute, preLocalScore: -1, preVisitorScore: -1, preMinute: -1, leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                    }
                                    else {
                                        livepojo = LiveScorePojo.init(leagueId: leagueId, matchId: matchId, localScore: localScore, visitorScore: visitorScore, minute:
                                            minute, preLocalScore: self.matrix[i][j][0], preVisitorScore: self.matrix[i][j][1], preMinute: self.matrix[i][j][2], leagueName: leaguename, localTeam: localTeam, visitorTeam: visitorTeam, flagg: flags, ilkflag: self.flag,isMatchLength: self.isMatchLength)
                                    }
                                    
                                    self.matrix[i][j][0] = localScore
                                    self.matrix[i][j][1] = visitorScore
                                    self.matrix[i][j][2] = minute
                                    
                                   liveArray.append(livepojo)
                                         }
                                    self.liveScoreTableView.reloadData()
                                
                                    
                                    break
                                }
                                self.flag = false

                                if(liveArray.count == 0){
                                    self.noMatchLabel.isHidden = false
                                    self.liveScoreTableView.isHidden = true
                                }else{
                                    self.noMatchLabel.isHidden = true
                                    self.liveScoreTableView.isHidden = false
                                }
                            }
                        }
                        
                        
                        
                    }
                    DispatchQueue.main.async {
                
                        
                        
                        if( self.isSearching == true){
                            self.filtered = liveArray
                        }else{
                            self.result = liveArray
                        }
                        
                        if(self.result.count > 0 || self.filtered.count > 0 ) {
                         self.liveScoreTableView.reloadData()
                            }
                        self.refreshControl.endRefreshing()
                        self.getLiveMatches(url:  URL(string: "http://opucukgonder.com/tipster/index.php/Service/lastLiveNew"))
                    }
               
                   
                }
                    
                catch{
                    
                    print("ERROR")
                }
                self.flag = false
                
                }
            
            }
            
        }
         if isSearching == true {
            task.cancel()
        }
         else {
            task.resume()
            
        }
      
    }
    
    

  
    @IBAction func openSearch(_ sender: Any) {
        searchBar.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        if(searchText != ""){
        filtered.removeAll()
        if(self.result.count != 0){
            for i in 0..<result.count{
                let aq : LiveScorePojo = result[i]
                if(aq.localTeam != nil){
                    if(searchBar.text!.lowercased().count <= aq.localTeam.count || searchBar.text!.count <= aq.visitorTeam.count ){
                        
                        if((aq.localTeam.lowercased().contains(searchBar.text!.lowercased())) || (aq.visitorTeam.lowercased().contains((searchBar.text!.lowercased())))){
                            filtered.append(aq)
                            isSearching = true
                            
                        }
                      
                    }}}
           
            
               self.liveScoreTableView.reloadData()
        }
        }
        else{
            
            searchBar.isHidden = true
            isSearching = false
            self.liveScoreTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        
        // Remove focus from the search bar.
        searchBar.endEditing(true)
         isSearching = false
    }
    

    @IBAction func genericAlarmClicked(_ sender: Any) {
        let myVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateAlertVC") as! CreateAlertVC
        myVC.matchId = send_matchId
        myVC.localTeam  = "Generic Alarm"
        myVC.visitorTeam = send_visitorTeam
        myVC.Minute = send_minute
        myVC.LocalTeamScore = send_localScore
        myVC.visitorTeamScore = send_visitorScore
        myVC.isGeneric = true
        myVC.genericArray = result
          self.present(myVC, animated: true)
    }
    
    /* ------------------------------------------------------------------------------------------- */
    
    
  /*  func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        
        myVC.matchId = send_matchId
        myVC.localTeam  = send_localTeam
        myVC.visitorTeam = send_visitorTeam
        myVC.Minute = send_minute
        myVC.LocalTeamScore = send_localScore
        myVC.visitorTeamScore = send_visitorScore
    }*/
    func date(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        dateLabel.text = result
        
        
    }
    
    

    
    func colorReset(i : Int) {
    
        if (huntFilter == i) {
            
            huntFilter = 0
            switch (i) {
            case 1:
                
                out_btn_NOGOAL.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break
                
            case 2:
                out_btn_DRAW.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break
                
            case 3:
                out_btn_WINTONIL.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break
                
            case 4:
                out_btn_05.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break
                
            case 5:
                out_btn_15.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break
                
            case 6:
                out_btn_25.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break
            case 7:
                out_homewin.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break
            case 8:
                out_awaywin.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break
        
            default:
               
                break
                
            }
            
        }
        else
            
        {
            huntFilter = i
            
            out_btn_NOGOAL.backgroundColor = hexStringToUIColor(hex: "#192A50")
              out_btn_DRAW.backgroundColor = hexStringToUIColor(hex: "#192A50")
              out_btn_WINTONIL.backgroundColor = hexStringToUIColor(hex: "#192A50")
              out_btn_05.backgroundColor = hexStringToUIColor(hex: "#192A50")
              out_btn_15.backgroundColor = hexStringToUIColor(hex: "#192A50")
              out_btn_25.backgroundColor = hexStringToUIColor(hex: "#192A50")
              out_homewin.backgroundColor = hexStringToUIColor(hex: "#192A50")
              out_awaywin.backgroundColor = hexStringToUIColor(hex: "#192A50")
           
            
            switch (i) {
            case 1:
                out_btn_NOGOAL.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break
                
            case 2:
                out_btn_DRAW.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break
                
            case 3:
                out_btn_WINTONIL.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break
                
            case 4:
                out_btn_05.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break
                
            case 5:
                out_btn_15.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break
                
            case 6:
                out_btn_25.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break
            case 7:
                out_homewin.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break
            case 8:
                out_awaywin.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break
        
            default:
                break
            }
        
        
        }
    }
    
    func colorResetForMin(i : Int) {
        if (huntFilterMin == i) {
            huntFilterMin = 0;
            switch (i) {
                
            case 9:
                sifirOtuz.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break;
                
            case 10:
                otuzAltmis.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break;
                
            case 11:
                atmisDoksan.backgroundColor = hexStringToUIColor(hex:"#192A50")
                break;
                
            default:
                break
            }
        } else {
            huntFilterMin = i;
            
            sifirOtuz.backgroundColor = hexStringToUIColor(hex: "#192A50")
            otuzAltmis.backgroundColor = hexStringToUIColor(hex: "#192A50")
            atmisDoksan.backgroundColor = hexStringToUIColor(hex: "#192A50")
            
            switch (i) {
            case 9:
                sifirOtuz.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break;
            case 10:
                otuzAltmis.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break;
            case 11:
                atmisDoksan.backgroundColor = hexStringToUIColor(hex:"#3E7ACA")
                break;
            default:
                break
            }
        }
    }
    
    func methodForHuntFilterMin(minute : Int) -> Bool {
        var boolReturn : Bool = true
        switch (huntFilterMin) {
        case 9:
            if (minute <= 30 && minute > 0){boolReturn = true}
            else{boolReturn = false}
            break
            
        case 10:
            if (minute <= 60 && minute > 30 || minute == 0){ boolReturn = true}
                
            else{ boolReturn = false}
            break
            
        case 11:
            if (minute <= 90 && minute > 60){boolReturn = true}
            else{boolReturn = false}
            break
            
        default:
            break
        }
        return boolReturn;
    }
    
    @IBAction func btn_NOGOAL(_ sender: Any) {
     
            colorReset(i: 1)
        
        
    }
    
    @IBAction func btn_DRAW(_ sender: Any) {
        
        
            colorReset(i: 2)
        
    
    }
    @IBAction func btn_WINTONIL(_ sender: Any) {

            colorReset(i: 3)
      
        
    }
    @IBAction func btn_05(_ sender: Any) {
    
            colorReset(i: 4)
        
        
    }
    @IBAction func btn_15(_ sender: Any) {
        

            colorReset(i: 5)
       
        
    }
    @IBAction func btn_25(_ sender: Any) {
      
            colorReset(i: 6)
        
        
    }
    
    @IBAction func home_win(_ sender: Any) {
     
            colorReset(i: 7)
        
    }
    @IBAction func away_win(_ sender: Any) {
        
      
            colorReset(i: 8)
        }
    
    
    @IBAction func sifirOtuzClicked(_ sender: Any) {
      
            colorResetForMin(i: 9)
        
    }
    @IBAction func otuzAltmisClicked(_ sender: Any) {
    
            colorResetForMin(i: 10)
        
    }
    @IBAction func altmisDoksanClicked(_ sender: Any) {

            colorResetForMin(i: 11)
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }
    
}

