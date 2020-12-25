//
//  HomeViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/08/19.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import RealmSwift
import FSCalendar

class HomeViewController: UIViewController,  FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance, UITableViewDataSource,UITableViewDelegate {
    
    // Mark: - Properties
    
    @IBOutlet weak var drinkCalendar: FSCalendar!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var configButton: UIBarButtonItem!
    
    @IBOutlet weak var calendarHeight:NSLayoutConstraint!
    
    var mySections = [String]()
    var twoDimArray = [[(title: String, desc: String, color:UIColor)]]()
    var drinkDaily = DrinkDailyRecord(dDate: Date(), drinks: [Drink](), totalUnits: 0)
    var selectedDate = Date()
    let sectionTitleArray = ["ドリンク数", "飲酒量"]
    
    // Mark: - View Rotation
    override func viewDidLoad() {
        super.viewDidLoad()
         
        mySections = sectionTitleArray
        twoDimArray = loadDataForTable(date: Date())
        
        let realm = try! Realm()
        drinkRecord_Results = realm.objects(DrinkRecord.self)
    }
    
       //    Mark: - Methods
    
    @IBAction func press_deleteButton(_ sender: UIBarButtonItem) {
        self.navigationItem.title = selectedDate.mediumStr+"を選択"
        let date = selectedDate
        let id = (date.toHashStr)
        let realm = try! Realm()
        if let object = realm.object(ofType: DrinkRecord.self, forPrimaryKey: id) {
            try! realm.write {
                realm.delete(object)
                twoDimArray = loadDataForTable(date: selectedDate)
                tableview.reloadData()
                drinkCalendar.reloadData()
            }
        }
    }
    
    
    private func loadDataForTable(date: Date)  ->  [[(title: String, desc: String, color:UIColor)]]{
        drinkDaily = DrinkDailyRecord(dDate: date, drinks: [Drink](), totalUnits: 0)
        let id = (date.toHashStr)
        self.navigationItem.title = date.mediumStr+"を選択"
        let realm = try! Realm()
        if let object = realm.object(ofType: DrinkRecord.self, forPrimaryKey: id) {
            //             データが存在する
            
            //Section 2 for tableview
            var array_1 = [(title: String, desc: String, color:UIColor)]()
            let pastDrinkArray: [(title:eDname,damount:Int)] = [
                (title:eDname.wine, damount:object.wine),
                (title:eDname.nihonsyu, damount:object.nihonsyu) ,
                (title:eDname.beer, damount:object.beer) ,
                (title:eDname.shocyu, damount:object.shocyu) ,
                (title:eDname.wisky, damount:object.wisky) ,
                (title:eDname.can, damount:object.can) ]
            for item in pastDrinkArray {
                let ditem = Drink(dname: item.title, damount: item.damount)
                drinkDaily!.drinks.append(ditem!) // Parse for segue
               
                //Section 2 for tableview
                if item.damount > 0 {
                    let t = item.title.ctitle (emoji: emojiSwitch)
                    let record = (title:t, desc:item.damount.decimalStr, color:UIColor.black)
                    array_1.append(record)
                }
            }
            // Parse for segue
            drinkDaily!.dDate = date
            if !(drinkDaily!.TU == object.totalUnits) {
           
                let realm = try! Realm()
                try! realm.write {
                    let value:[String:Any] = ["id":object.dDate!.toHashStr, "totalUnits":drinkDaily!.TU]
                    realm.create(DrinkRecord.self, value:value, update:true)
                }
            }
            //Section 1 for tableview
            deleteButton.isEnabled = true
            let desc:String = ""
            let diff = round((object.totalUnits - targetUnit)*10)/10
            let prefix = object.totalUnits == 0 ? "0":String(round(object.totalUnits*10)/10)
            let title = drinkDaily!.emojiStr + " " + prefix
            let color = (diff>1) ? UIColor.red:UIColor.black
            let array_0 = [(title: title, desc: desc, color:color)]
                
            return  [array_0, array_1]
        }
            // データが無い
        else {
            //Parse for segue
            deleteButton.isEnabled = false
            let pastDrinkArray: [(title:eDname,damount:Int)] = [
                (title:eDname.wine, damount:0),
                (title:eDname.nihonsyu, damount:0) ,
                (title:eDname.beer, damount:0) ,
                (title:eDname.shocyu, damount:0) ,
                (title:eDname.wisky, damount:0) ,
                (title:eDname.can, damount:0) ]
            for item in pastDrinkArray {
                let ditem = Drink(dname: item.title, damount: item.damount)
                drinkDaily!.drinks.append(ditem!) // Parse for segue
            }
            // Section 0 and 1 for table
            let title:String = ""
            let desc:String = "無し"
            let color:UIColor = UIColor.black
            let array_0 = [(title: title, desc: desc,color:color)]
            let array_1 = [(title:title, desc:desc, color:color)]
            
            return  [array_0, array_1]            }
    }
    
    //    Mark: - Calendar
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        twoDimArray = loadDataForTable(date: date)
        tableview.reloadData()
        
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
        let id = date.toHashStr
        let record = drinkRecord_Results.filter("id = %@",id).first
        return record?.totalUnits.dots ?? 0
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
       
            return [appearance.eventDefaultColor, UIColor.orange, UIColor.red]
    }
    
 
    // Mark: - Table Management
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoDimArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = twoDimArray[indexPath.section][indexPath.row].title
        cell.detailTextLabel?.text = twoDimArray[indexPath.section][indexPath.row].desc
        cell.textLabel?.textColor = twoDimArray[indexPath.section][indexPath.row].color
        return cell
    }
    
    // Mark:- Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDailyDrinkRecord" {
            let controller = segue.destination as!  MasterViewController
            controller.drinkDaily = self.drinkDaily
            //            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            //            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    
    @IBAction func unwindToHomeView(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? MasterViewController,
            let object = sourceViewController.drinkDaily {
            
            let data = DrinkRecord()
            data.id = object.dDate.toHashStr
            data.totalUnits = object.TU
            data.dDate = object.dDate
            
            for item in object.drinks {
                switch item.dname {
                case eDname.wine: data.wine = item.damount
                case eDname.nihonsyu: data.nihonsyu = item.damount
                case eDname.beer: data.beer = item.damount
                case eDname.shocyu: data.shocyu = item.damount
                case eDname.wisky: data.wisky = item.damount
                case eDname.can: data.can = item.damount }
            }
            
            let realm = try! Realm()
            try! realm.write{ realm.add(data,update:true)}
            
            twoDimArray = loadDataForTable(date: object.dDate)
            tableview.reloadData()
            drinkCalendar.reloadData()
        }
        
        else if sender.source is ConfigureTableViewController {
            
            self.theme = calConfig[calSet.theme]!
            self.launguage = calConfig[calSet.language]!
            self.schroolDirection = calConfig[calSet.scrollDir]!
            self.firstWeekDay = calConfig[calSet.firstWeekDay]!
      /*
            if self.drinkCalendar.firstWeekday != UInt(calConfig[calSet.firstWeekDay]!) {
                self.drinkCalendar.firstWeekday = UInt(calConfig[calSet.firstWeekDay]!)
            }
            if self.drinkCalendar.scrollDirection != FSCalendarScrollDirection(rawValue:UInt(calConfig[calSet.scrollDir]!)) {
                self.drinkCalendar.scrollDirection = FSCalendarScrollDirection(rawValue:UInt(calConfig[calSet.scrollDir]!))!
            }
        */
            twoDimArray = loadDataForTable(date: selectedDate)
            tableview.reloadData()
            drinkCalendar.reloadData()
        }
    }
    
    // Mark: - Appearance -------------------------------------------------
    
    let fillDefaultColors = [ 1: UIColor.orange, 2: UIColor.red]
    let borderDefaultColors =  [ 1: UIColor.yellow, 2: UIColor.orange]
    
    fileprivate var schroolDirection: Int = 0 {
         didSet {
            self.drinkCalendar.scrollDirection = FSCalendarScrollDirection(rawValue:UInt(calConfig[calSet.scrollDir]!))!
             }
     }
    
     fileprivate var firstWeekDay: Int = 0 {
         didSet {
            self.drinkCalendar.firstWeekday = UInt(calConfig[calSet.firstWeekDay]!)
     }
    }
    
     fileprivate var launguage: Int = 0 {
         didSet {
             switch (launguage) {
             case 0:
                 self.drinkCalendar.appearance.headerDateFormat = "YYYY年MM月"
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[0].text = "日"
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[1].text = "月"
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[2].text = "火"
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[3].text = "水"
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[4].text = "木"
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[5].text = "金"
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[6].text = "土"
                 
             case 1:
                 self.drinkCalendar.appearance.headerDateFormat = "yyyy-MM"
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[0].text = "Sun."
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[1].text = "Mon."
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[2].text = "Tue."
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[3].text = "Wed."
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[4].text = "Thu."
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[5].text = "Fri."
                 self.drinkCalendar.calendarWeekdayView.weekdayLabels[6].text = "Sat."
          
             default:
                 break;
             }
         }
     }
     
    
    fileprivate var theme: Int = 0 {
        didSet {
            switch (theme) {
            case 0:
                self.drinkCalendar.appearance.weekdayTextColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
                self.drinkCalendar.appearance.headerTitleColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
                self.drinkCalendar.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.drinkCalendar.appearance.selectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
                self.drinkCalendar.appearance.headerDateFormat = "MMMM yyyy"
                self.drinkCalendar.appearance.todayColor = UIColor(red: 198/255.0, green: 51/255.0, blue: 42/255.0, alpha: 1.0)
                self.drinkCalendar.appearance.borderRadius = 1.0
                self.drinkCalendar.appearance.headerMinimumDissolvedAlpha = 0.2
            case 1:
                self.drinkCalendar.appearance.weekdayTextColor = UIColor.red
                self.drinkCalendar.appearance.headerTitleColor = UIColor.darkGray
                self.drinkCalendar.appearance.eventDefaultColor = UIColor.green
                self.drinkCalendar.appearance.selectionColor = UIColor.blue
                self.drinkCalendar.appearance.headerDateFormat = "yyyy-MM";
                self.drinkCalendar.appearance.todayColor = UIColor.red
                self.drinkCalendar.appearance.borderRadius = 1.0
                self.drinkCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
            case 2:
                self.drinkCalendar.appearance.weekdayTextColor = UIColor.red
                self.drinkCalendar.appearance.headerTitleColor = UIColor.red
                self.drinkCalendar.appearance.eventDefaultColor = UIColor.green
                self.drinkCalendar.appearance.selectionColor = UIColor.blue
                self.drinkCalendar.appearance.headerDateFormat = "yyyy/MM"
                self.drinkCalendar.appearance.todayColor = UIColor.orange
                self.drinkCalendar.appearance.borderRadius = 0
                self.drinkCalendar.appearance.headerMinimumDissolvedAlpha = 1.0
            default:
                break;
            }
        }
    }
    
}
