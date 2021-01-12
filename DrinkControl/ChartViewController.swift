//
//  ChartViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/11/16.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import Charts
import Instructions

class ChartViewController: UIViewController,CoachMarksControllerDataSource,CoachMarksControllerDelegate {
    
    //MARK:-Properties
    var rawData:RawData = [] // Receive data from HomeViewController
    var twoDimArray = [tableArray]() // UITable
    var data = ChartData()
    let unitStr:String = "g"
    
    //MARK:- IBActions
    @IBAction func pressCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
  
    //MARK:-  Coarch
    let hintStr  = ["グラフビューは、あなたの飲酒習慣を３つの画面で【見える化】します。。\n最初は「飲酒量」の画面です\n📈は、時系列の飲酒量（純アルコール量）","📊は、平均の飲酒量です。"]
    private var pointOfInterest:UIView!
    let coachMarksController = CoachMarksController()
    var lineChartForCoach = LineChartView()
    var barChartForCoarch = BarChartView()
   
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        //表示するスポットライトの数。チュートリアルの数。
        return hintStr.count
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        //指し示す場所を決める。　今回はpointOfInterestすなわちButtonga指し示される
        var point:UIView!
        switch index {
        case 0:
            point = lineChartForCoach
        case 1:
            point = barChartForCoarch
        default:break
        }
        return coachMarksController.helper.makeCoachMark(for: point)
    }
    
    //tableview　でいうreturn cellに似てるのかなってイメージ。表示するチュートリアルメッセージなどがいじれる
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, withNextText: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = hintStr[index]
        coachViews.bodyView.nextLabel.text = nextLabel
        
        coachViews.bodyView.background.cornerRadius = 20
        coachViews.bodyView.background.borderColor = UIColor(hexRGB:"#F99F48" )!
        coachViews.bodyView.hintLabel.textColor = .black
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didEndShowingBySkipping skipped: Bool) {
        //dismiss(animated: true)
        //self.navigationController?.popViewController(animated: true)
        
        performSegue(withIdentifier: "showSecondChart", sender: Any?.self)
    }
    
     //   }
 
    //MARK:- View Rotation
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        guard !shouldShowCoarch
            else {
                if shownLastChartPage {self.tabBarController?.selectedIndex = 0}
                else {
                    self.coachMarksController.start(in: .currentWindow(of: self))}
                return
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        
    //    justFinishedCoachCources = .chart
        let data = shouldShowCoarch ? chartDataArrayDummy: setDataArray(rawdata: generateRawData())
        navigationItem.title = (data.last?.0)!
   //     navigationItem.prompt = (data.first!.0)+"〜"+
        let rect = CGRect(x:0, y: 44, width: self.view.frame.width, height: (self.view.frame.height * 0.5 - 22))
        switch graphType {
        case 0: let barChartView = drawBarChart(chartData: data, legend: "純アルコール量(g)", rect: rect, numXLabels: 5, topOffset: 35.0,flagDateType: true, addLines: true,showValue: false)
            self.view.addSubview(barChartView)
           // barChartForCoarch = barChartView
            
        case 1: let lineChartView = drawLineChart(chartData: data, legend: "純アルコール量(g)", rect: rect, numXLabels: 5,topOffset: 35.0, flagDateType: true, addLines: true,showValue: false)
            self.view.addSubview(lineChartView)
            if shouldShowCoarch {lineChartForCoach = lineChartView} //コーチの対象にする。
        default:break
        }
        
        let data1 = avgDrinkFullPeriods(array: data)
        let rect1 = CGRect(x:0, y: (self.view.frame.height * 0.5 + 22), width: self.view.frame.width, height:( self.view.frame.height * 0.5 - 69))
        let barChartView = drawBarChart(chartData: data1, legend: "純アルコール量の期間別平均（g）", rect: rect1, numXLabels:data1.count,topOffset:20.0, buttomOffset:30, flagDateType: false, addLines: true,noDrink:false, showValue: true)
        self.view.addSubview(barChartView)
        if shouldShowCoarch {barChartForCoarch = barChartView} //コーチの対象にする。
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
