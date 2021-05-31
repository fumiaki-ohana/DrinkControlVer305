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
import SnapKit

class OnTourChartViewController: UIViewController,CoachMarksControllerDataSource,CoachMarksControllerDelegate {
    
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
    let hintStr  = ["あなたの飲酒習慣を３つのグラフ画面で【見える化】します。\n\n最初の画面の📈は純アルコール量。📊は、平均です。"]
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
     //   case 1:
     //       point = barChartForCoarch
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
        
        performSegue(withIdentifier: "moveToChart2", sender: Any?.self)
    }
    
     //   }
 
    //MARK:- View Rotation
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        guard !shouldShowCoarch
            else {
                    self.coachMarksController.start(in: .currentWindow(of: self))
                return
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        
        let data = chartDataArrayDummy
        navigationItem.title = (data.last?.0)!

        let lineChartView = drawLineChart(chartData: data, legend: "純アルコール量(g)",  numXLabels: 5,topOffset: 35.0, flagDateType: true, addLines: true,showValue: false)
            self.view.addSubview(lineChartView)
            if shouldShowCoarch {lineChartForCoach = lineChartView}
        lineChartView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.4)}//コーチの対象にする。
        
        let data1 = avgDrinkFullPeriods(array: data)
     
        let barChartView = drawBarChart(chartData: data1, legend: "純アルコール量の期間別平均（g）",  numXLabels:data1.count,topOffset:20.0, buttomOffset:30, flagDateType: false, addLines: true,noDrink:false, showValue: true)
        self.view.addSubview(barChartView)
        
        barChartView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(lineChartView.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(10) }
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
