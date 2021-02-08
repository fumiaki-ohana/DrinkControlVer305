//
//  ThirdChartViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/09/24.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Charts

class ThirdChartViewController: UIViewController{
    
    //MARK:- IB function
    
    @IBAction func pressCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
       
       //MARK:- View Rotation
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if shouldWarningOnRatingGraph {
            let titl = "過去の感想（良い、悪いETC)です。"
            let msg = "⚠️入力が無かった日＝お酒を飲まなかった日とみなして、【🤗良い】としてカウントしています。"
            self.present(.okAlert(title:titl, message:msg ,astyle: .alert) )
            shouldWarningOnRatingGraph = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard !grNoData else {
            present(.okAlert(title: "データがありません", message: "グラフの表示を中止しました。"))
            return
        }
        navigationItem.leftBarButtonItem?.theme_tintColor = GlobalPicker.naviItemColor
        justFinishedCoachCources = .chart
              
        let tempdata = setDataArray(rawdata: generateRawData(reversed: false))
        let data = countRating(array:tempdata)
        navigationItem.leftBarButtonItem?.theme_tintColor = GlobalPicker.naviItemColor
        navigationItem.title = "反省"
        
        let rect = CGRect(x:0, y: 22, width: self.view.frame.width, height: (self.view.frame.height / 2 - 22))
        let threeWeeksData = [data[0],data[1],data[2]]
        let barChartView = drawStackedBarChart(chartData: threeWeeksData, legend: "", rect: rect, numXLabels: data.count,topOffset:40.0, buttomOffset:20.0,flagDateType: false, addLines: true,noDrink:true, showValue: true)
        self.view.addSubview(barChartView)
        barChartView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.4) }

        let wholePeriodData = [data[3]]
        let rect1 = CGRect(x:0, y: (self.view.frame.height / 2), width: self.view.frame.width, height: (self.view.frame.height / 2 - 22))
        let pieChartView = drawPieChart(chartData: wholePeriodData, legend: "全期間", rect: rect1, topOffset:40.0, buttomOffset:20.0,centerText: "全期間")
        self.view.addSubview(pieChartView)
        
        pieChartView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(barChartView.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(10)}
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
