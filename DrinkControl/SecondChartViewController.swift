//
//  SecondChartViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/08.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class SecondChartViewController: UIViewController{
    //MARK:- IB function
    @IBAction func pushCancel(_ sender: UIBarButtonItem) {
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
        navigationItem.leftBarButtonItem?.theme_tintColor = GlobalPicker.naviItemColor
        let tempdata = setDataArray(rawdata: generateRawData(reversed: false))
        let data = excessOrNoDrinkFullPeriod(array:tempdata,calc:Ecalc.noDrink)
        navigationItem.title = "習慣" //(data.first!.0)+"〜"+(data.last?.0)!
    //    let rect = CGRect(x:0, y: 44, width: self.view.frame.width, height: (self.view.frame.height * 0.5 - 22))
        let barChartView = drawBarChart(chartData: data, legend: "休肝日（日数）",numXLabels: data.count,topOffset:40.0, buttomOffset:20.0,flagDateType: false, addLines: true,noDrink:true, showValue: true)
        self.view.addSubview(barChartView)
        barChartView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.4) }
        
   //     let rect1 = CGRect(x:0, y: (self.view.frame.height * 0.5 + 22), width: self.view.frame.width, height:( self.view.frame.height * 0.5 - 69))
        let data1 = excessOrNoDrinkFullPeriod(array:tempdata,calc:Ecalc.excess)
        let barChartView2 = drawBarChart(chartData: data1, legend: "飲み過ぎ（日数）",  numXLabels: data.count,topOffset:20.0, buttomOffset:20.0, flagDateType: false, addLines: false,showValue: true)
        self.view.addSubview(barChartView2)
        barChartView2.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(barChartView.snp.bottom).offset(10)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(10)}
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
