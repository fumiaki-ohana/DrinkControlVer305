//
//  ChartViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/11/16.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    //MARK:-Properties
    var rawData:RawData = [] // Receive data from HomeViewController
    var twoDimArray = [tableArray]() // UITable
    var data = ChartData()
    let unitStr:String = "g"
    
    //MARK:- IBActions
    @IBAction func pressCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
  
    //MARK:- View Rotation
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        guard !grNoData else {
            present(.okAlert(title: "データがありません", message: "グラフの表示を中止しました。"))
            return
        }
        
        let data = setDataArray(rawdata: generateRawData())
          
        navigationItem.title = (data.last?.0)!
        navigationItem.leftBarButtonItem?.theme_tintColor = GlobalPicker.naviItemColor

        //　アルコール料
        let rect = CGRect(x:0, y: 44, width: self.view.frame.width, height: (self.view.frame.height * 0.5 - 22))
        switch graphType {
        case 0: let barChartView = drawBarChart(chartData: data, legend: "純アルコール量(g)", rect: rect, numXLabels: 5, topOffset: 35.0,flagDateType: true, addLines: true,showValue: false)
            self.view.addSubview(barChartView)
        case 1: let lineChartView = drawLineChart(chartData: data, legend: "純アルコール量(g)", rect: rect, numXLabels: 5,topOffset: 35.0, flagDateType: true, addLines: true,showValue: false)
            self.view.addSubview(lineChartView)
        default:break
        }
        
        let data1 = avgDrinkFullPeriods(array: data)
        let rect1 = CGRect(x:0, y: (self.view.frame.height * 0.5 + 22), width: self.view.frame.width, height:( self.view.frame.height * 0.5 - 69))
        let barChartView = drawBarChart(chartData: data1, legend: "純アルコール量の期間別平均（g）", rect: rect1, numXLabels:data1.count,topOffset:20.0, buttomOffset:30, flagDateType: false, addLines: true,noDrink:false, showValue: true)
        self.view.addSubview(barChartView)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Support Dark Mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard
            #available(iOS 13.0, *),
            traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)
            else { return }
        
        updateTheme()
    }
    
    private func updateTheme() {
        guard #available(iOS 12.0, *) else { return }
        
        switch traitCollection.userInterfaceStyle {
        case .light:
            MyThemes.switchNight(isToNight: false)
        case .dark:
            MyThemes.switchNight(isToNight: true)
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
}
