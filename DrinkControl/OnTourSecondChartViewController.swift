//
//  SecondChartViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/08.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Charts
//import Eureka
import Instructions
import SnapKit

class OnTourSecondChartViewController: UIViewController,CoachMarksControllerDataSource,CoachMarksControllerDelegate {
    //MARK:- IB function
    @IBAction func pushCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
     //MARK:-  Coarch
    var barChartForCoarch0 = BarChartView()
    var barChartForCoarch1 = BarChartView()
    
    let hintStr  = ["次は、「飲酒習慣」の画面です。\n\n一週間の【休肝日】と・・・。","【飲み過ぎ】の日数を表示します。"]
    private var pointOfInterest:UIView!
    let coachMarksController = CoachMarksController()
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        //表示するスポットライトの数。チュートリアルの数。
        return hintStr.count
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                          willShow coachMark: inout CoachMark,
                          beforeChanging change: ConfigurationChange,
                          at index: Int) {
    switch index {
    case 0: coachMark.arrowOrientation = .top
    case 1: coachMark.arrowOrientation = .bottom
    
    default:break
    }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        //指し示す場所を決める。　今回はpointOfInterestすなわちButtonga指し示される
        var point:UIView!
        switch index {
        case 0:
            point = barChartForCoarch0
        case 1:
            point = barChartForCoarch1
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
        
        performSegue(withIdentifier: "moveToChart3", sender: Any?.self)
    }
    
    //MARK:- View Rotation
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidAppear(animated)
        guard !shouldShowCoarch
            else {
                self.coachMarksController.start(in: .currentWindow(of: self))
                return
        }
    }
    
    override func viewDidLoad() {
        
      //  self.tabBarController?.tabBar.isHidden = true
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        
        let tempdata = chartDataArrayDummy
        let data = excessOrNoDrinkFullPeriod(array:tempdata,calc:Ecalc.noDrink)
        navigationItem.title = "習慣" //(data.first!.0)+"〜"+(data.last?.0)!
   
        let barChartView = drawBarChart(chartData: data, legend: "休肝日（日数）",  numXLabels: data.count,topOffset:40.0, buttomOffset:20.0,flagDateType: false, addLines: true,noDrink:true, showValue: true)
        self.view.addSubview(barChartView)
        barChartView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.4) }
        if shouldShowCoarch {barChartForCoarch0 = barChartView }
        
        let data1 = excessOrNoDrinkFullPeriod(array:tempdata,calc:Ecalc.excess)
        let barChartView2 = drawBarChart(chartData: data1, legend: "飲み過ぎ（日数）", numXLabels: data.count,topOffset:20.0, buttomOffset:20.0, flagDateType: false, addLines: false,showValue: true)
         self.view.addSubview(barChartView2)
        barChartView2.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(barChartView.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)}
         if shouldShowCoarch {barChartForCoarch1 = barChartView2 }
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
