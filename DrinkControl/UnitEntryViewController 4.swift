//
//  UnitEntryViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/08/31.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit

class UnitEntryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
   
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var slider: UISlider!
    
    typealias cellArray = [cellTupple]
    typealias cellTupple = (title: String, desc: String, style:UITableViewCell.AccessoryType, c_order:Int)
    
    var twoDimArray = [cellArray]()
    var mySecsions = [String]()
    let sectionTitleArray = ["アルコール濃度（％）の設定"]
    
    var selectedIP = IndexPath(row: 0, section: 0)
    var selectedDrink:eDname = eDname.wine
    
    let sliderMax = 50.0
    let sliderMin = 1.0
    
    @IBAction func onChange(_ sender: UISlider) {
        
        twoDimArray[0][selectedIP.row].desc = Double(sender.value).decimalStr
        tableview.reloadData()
        
        let temp:Array<(title:String,desc:String)> = twoDimArray[0].map { (title:$0.0, desc:$0.1)}
        
        var array = [eDname:Double]()
        for i in temp {
            array [eDname(rawValue: i.title)!] = Double(i.desc)
        }
        eDname.alc_dic = array
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
    
        twoDimArray = loadDataForTable(data: eDname.alc_dic)
        mySecsions = sectionTitleArray
        
        slider.maximumValue = Float(sliderMax)
        slider.minimumValue = Float(sliderMin)
        slider.isContinuous = true
        slider.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    private func loadDataForTable(data:[eDname: Double])  -> [ cellArray]{
        
        var array = cellArray()
        
        let temp  = data.map { (title:$0.0.ctitle(emoji: false), desc:$0.1.decimalStr, c_order:$0.0.c_order )}
        
        for i in temp {
            let e:(cellTupple) = (title:i.title, desc:i.desc,  style:.none, c_order:i.c_order)
            array.append(e)
        }
        array.sort { (first, second) -> Bool in return first.c_order < second.c_order
        }
        
        return  [array]
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySecsions[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoDimArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        
        cell.textLabel?.text = twoDimArray[indexPath.section][indexPath.row].title
        cell.detailTextLabel?.text = twoDimArray[indexPath.section][indexPath.row].desc
        cell.accessoryType = twoDimArray[indexPath.section][indexPath.row].style
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        twoDimArray[0] = twoDimArray[0].map { ($0.0, $0.1, .none,$0.3)}
        self.selectedIP = indexPath
        twoDimArray[0][indexPath.row].style = .checkmark
        tableView.reloadData()
        
        let alc_name = twoDimArray[0][self.selectedIP.row].title
        let choosen_Value = eDname.alc_dic[eDname(rawValue: alc_name)!]
        
        slider.setValue(Float(choosen_Value!), animated: true)
        slider.isEnabled = true
    }
   
    
}
