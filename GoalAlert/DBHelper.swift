







//
//  DBHelper.swift
//  GoalAlert
//
//  Created by Burhan TOPRAKMAN on 05/01/2018.
//  Copyright © 2018 Burhan TOPRAKMAN. All rights reserved.
//

import SQLite
import Foundation

public class DBHelper  {
    static let shared : DBHelper = DBHelper()
    private let db : Connection?
    private let alerts = Table("Alerts")
    private let id = Expression<Int64>("id")
    private let localTeam = Expression<String>("localteam")
    private let visitorTeam = Expression<String>("visitorteam")
    private let alarmMin = Expression<Int>("alarmmin")
    private let betValue = Expression<Double>("bet")
    private let matchId = Expression<Int>("matchid")
    
    private init(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do{
            db = try Connection("\(String(describing: path))/ishop.sqlite3")
            createDB()
        }catch{
            db = nil
            print("Unable reach Database")
        }
        
    }

func createDB(){
    do{
        try db!.run(alerts.create(ifNotExists: true) { table in
            table.column(id, primaryKey: true)
            table.column(localTeam)
            table.column(visitorTeam)
            table.column(alarmMin)
            table.column(betValue)
            table.column(matchId)
        })
        print("Create table succesfully")
    }catch{
        print("Unable create table")
    }
   
}
    
    func saveData(localteam :String , visitorteam : String , alarmmin : Int , bet : Double , matchid : Int) -> Int64? {
        do {
            let insert = alerts.insert(localTeam <- localteam, visitorTeam <- visitorteam , alarmMin <- alarmmin , betValue <- bet ,matchId <- matchid)
            
            let id = try db?.run(insert)
            print("Insert to alerts successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }

    }
    func getAllData() -> [Alert] {
        var products = [Alert]()
        
        do {
            for product in try db!.prepare(self.alerts) {
                let newProduct = Alert(id: product[id],
                                         localTeam: product[localTeam] ,
                                         visitorTeam: product[visitorTeam],
                                         alarmMin : product[alarmMin],
                                         bet: product[betValue],
                                         matchId : product[matchId])
               
                products.append(newProduct)
            }
        } catch {
            print("Cannot get list of product")
        }
        for product in products {
            print("each product = \(product)")
        }
        return products
    }
    
    func deleteData(dbid: Int64) -> Bool {
        do {
            let alertfilter = alerts.filter(id == dbid)
            try db!.run(alertfilter.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
}

