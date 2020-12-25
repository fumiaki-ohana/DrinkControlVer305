//
//  ThirdChartViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/09/24.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Charts
import Instructions

class ThirdChartViewController: UIViewController,CoachMarksControllerDataSource,CoachMarksControllerDelegate {
    
    //MARK:- IB function
    @IBAction func pushCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
     //MARK:-  Coarch
       var barChartForCoarch = BarChartView()
       var pieChartForCoarch = PieChartView()
       
       let hintStr  = ["最後は「反省」の画面です。\n\nユーザーは、　飲酒量を入力した時に、反省（必須）とコメント（任意）も入力します。 \n📊棒グラフはその過去三週間での分布です","⭕️円グラフは全期間です。"]
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
               point = barChartForCoarch
           case 1:
               point = pieChartForCoarch
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
        shownLastChartPage = true
        let layere_number = navigationController!.viewControllers.count
        
        
        self.navigationController?.popToViewController(navigationController!.viewControllers[layere_number-3], animated: true)
        
        //   let index = navigationController!.viewControllers.count - 2
        //   self.navigationController?.popToRootViewController(animated: true)
        //  navigationController?.popToViewController(navigationController!.viewControllers[index], animated: true)
        //  self.tabBarController?.selectedIndex = 0
    }
       
       //MARK:- View Rotation
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldShowCoarch {
            self.coachMarksController.start(in: .currentWindow(of: self))
        }
        else if shouldWarningOnRatingGraph {
            let titl = "【新機能】過去の感想のグラフです。"
            let msg = "⚠️入力が無い日は飲酒がゼロとみなし、【🤗良い】の日としてカウントしています。"
            self.present(.okAlert(title:titl, message:msg ,astyle: .alert) )
            shouldWarningOnRatingGraph = false
        }
    }
    
    override func viewDidLoad() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        justFinishedCoachCources = .chart
              
      //
        let tempdata = shouldShowCoarch ? chartDataArrayDummy: setDataArray(rawdata: generateRawData(reversed: false))
        let data = countRating(array:tempdata)
    
       // navigationItem.title = (data.first!.0)+"〜"+(data.last?.0)!
        navigationItem.title = "反省"
        
        let rect = CGRect(x:0, y: 22, width: self.view.frame.width, height: (self.view.frame.height / 2 - 22))
        let threeWeeksData = [data[0],data[1],data[2]]
        let barChartView = drawStackedBarChart(chartData: threeWeeksData, legend: "", rect: rect, numXLabels: data.count,topOffset:40.0, buttomOffset:20.0,flagDateType: false, addLines: true,noDrink:true, showValue: true)
        self.view.addSubview(barChartView)
        if shouldShowCoarch {barChartForCoarch = barChartView}
        
        let wholePeriodData = [data[3]]
        let rect1 = CGRect(x:0, y: (self.view.frame.height / 2), width: self.view.frame.width, height: (self.view.frame.height / 2 - 22))
        let pieChartView = drawPieChart(chartData: wholePeriodData, legend: "全期間", rect: rect1, topOffset:40.0, buttomOffset:20.0,centerText: "全期間")
        self.view.addSubview(pieChartView)
        if shouldShowCoarch {pieChartForCoarch = pieChartView}
        
    }
   
    //小数点表示を整数表示にする処理。バーの上部に表示される数字。
    public class BarChartValueFormatter: NSObject, IValueFormatter{
        public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String{
            return entry.y.decimalStrPlain
            //String(Int(entry.y))
            //   MATHEMATICAL BOLD SMALL G
            //   Unicode: U+1D420, UTF-8: F0 9D 90 A0)
        }
    }
    //x軸のラベルを設定する
    public class BarChartFormatter: NSObject, IAxisValueFormatter{
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            if labels.count == 1 {
                return labels[0]
            } else {
                return labels[Int(value)]
            }
        }
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
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




   /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
