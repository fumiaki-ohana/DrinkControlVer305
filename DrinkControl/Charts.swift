//
//  Charts.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/11.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import Foundation
import Charts
import UIKit

enum Ecalc {
    case noDrink
    case excess
}

var grNoData = false // データがない場合は、グラフ表示を中止せる

//MARK:- Stacked Bar Charts

func drawStackedBarChart(chartData:StackedChartArray,  legend:String?,  numXLabels:Int, topOffset: CGFloat = 10, buttomOffset: CGFloat = 30.0, leftOffset:CGFloat = 10.0,rightOffset:CGFloat = 10.0, flagDateType: Bool,addLines:Bool = false,noDrink:Bool = false, showValue:Bool) -> BarChartView{
    
    let chartDataArray = chartData
    
    var dateStr:[String] = []
    if flagDateType {
        // グラフのX軸用に日付を加工する
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        dateStr = chartDataArray.map{f.date(from: $0.0)!.shortStr}
    }
    else {
        dateStr = chartDataArray.map{$0.0}
    }
    // グラフのY軸用の配列
    let valueArray = chartDataArray.map{($0.1)}
    
    //   self.title = " 純アルコール量の推移"
    //    let rect = CGRect(x:0, y: 30, width: self.view.frame.width, height: self.view.frame.height * 0.5)
    
    let chartView = BarChartView()
    
    chartView.dragEnabled = false
    chartView.pinchZoomEnabled = false
    chartView.doubleTapToZoomEnabled = false
    let l = chartView.legend
    l.horizontalAlignment = .center
    l.verticalAlignment = .bottom
    l.enabled = true
    
    chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    //  chartView.chartDescription?.text = chartDesc
    //x軸
    // X軸のラベルの位置を下に設定
    chartView.xAxis.labelPosition = .bottom
    // X軸のラベルの色を設定
    chartView.xAxis.labelTextColor = .systemGray
    // X軸の線、グリッドを非表示にする
    chartView.xAxis.drawGridLinesEnabled = false
    chartView.xAxis.drawAxisLineEnabled = false
    chartView.xAxis.labelCount = numXLabels //x軸に表示するラベルの数
    let chartFormatter = BarChartFormatter(labels: dateStr)
    chartView.xAxis.valueFormatter = chartFormatter
    //Y軸
    // 右側のY座標軸は非表示にする
    chartView.rightAxis.enabled = false
    
    // Y座標の値が0始まりになるように設定
    chartView.leftAxis.axisMinimum = 0.0
    chartView.leftAxis.drawZeroLineEnabled = true
    chartView.leftAxis.zeroLineColor = .systemGray
    // ラベルの数を設定
    chartView.leftAxis.labelCount = numXLabels
    // ラベルの色を設定
    chartView.leftAxis.labelTextColor = .systemGray
    // グリッドの色を設定
    chartView.leftAxis.gridColor = .systemGray
    // 軸線は非表示にす
    chartView.leftAxis.drawAxisLineEnabled = false
    
    // バー上にある値の表示(バー内か、バーより上か)
    chartView.drawValueAboveBarEnabled = true
    // それぞれのバーにグレーのエリアが描画される
    chartView.drawBarShadowEnabled = false
    //chartView.drawHighlightArrowEnabled = false
    
    // グラフの余白
    chartView.extraTopOffset = topOffset
    chartView.extraRightOffset = rightOffset
    chartView.extraBottomOffset = buttomOffset
    chartView.extraLeftOffset = leftOffset
    
    // データの読み込みと
    var entry = [BarChartDataEntry]()
    
    for (i, n) in valueArray.enumerated() {
        entry.append(BarChartDataEntry(x: Double(i), yValues: n))
    }
    
    let Colors: [NSUIColor] = [
        NSUIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0),
        NSUIColor(red: 241/255.0, green: 196/255.0, blue: 15/255.0, alpha: 1.0),
        NSUIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0),
        NSUIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0) ]
    
    //********
    let dataSet = BarChartDataSet(entries: entry, label: legend)
    dataSet.drawIconsEnabled = false
    dataSet.colors = Colors
    dataSet.stackLabels = [eval.good.rawValue, eval.improving.rawValue, eval.bad.rawValue, eval.veryBad.rawValue]
    let data = BarChartData(dataSet: dataSet)
    data.setValueFont(.systemFont(ofSize: 7, weight: .light))
//    dataSet.drawValuesEnabled = true //各プロットのラベル表示
 //   dataSet.valueFormatter = BarChartValueFormatter() // バーの上の小数点を止める。
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 1
    data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
    data.setValueTextColor(.black)
    
    chartView.fitBars = true
    chartView.data = data
    
   
    dataSet.drawValuesEnabled = true //各プロットのラベル表示(今回は表示しない)
    dataSet.highlightColor = .red//各点を選択した時に表示されるx,yの線
   
    chartView.data = BarChartData(dataSet: dataSet)

    return chartView
}

//MARK:- Pie Chart

func drawPieChart(chartData:StackedChartArray,  legend:String?, topOffset: CGFloat = 10, buttomOffset: CGFloat = 10.0, leftOffset:CGFloat = 10.0,rightOffset:CGFloat = 10.0,centerText:String = "") -> PieChartView{
    
    let chartDataArray = chartData
    
    // グラフのY軸用の配列
    let total = chartDataArray[0].yval.reduce(0){ $0 + $1 }
    let valueArray = (total == 0) ? [0.0] : chartDataArray[0].yval.map{($0/total*100)}
   
  //  self.title = " 全期間"
    
    let chartView = PieChartView()
    /*
    let l = chartView.legend
    l.horizontalAlignment = .right
    l.verticalAlignment = .top
    l.orientation = .vertical
    l.xEntrySpace = 7
     ¥
    l.yEntrySpace = 0
    l.yOffset = 0
    chartView.legend.enabled = true
    */
    // entry label styling
    chartView.entryLabelColor = .red
    chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
    
    chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)

    // グラフの余白
    chartView.extraTopOffset = topOffset
    chartView.extraRightOffset = rightOffset
    chartView.extraBottomOffset = buttomOffset
    chartView.extraLeftOffset = leftOffset
    chartView.legend.enabled = false
    
    // データの読み込みと
    var entry = [PieChartDataEntry]()
    
    for  n in valueArray {
        entry.append(PieChartDataEntry(value:n))
    }
    
    let Colors: [NSUIColor] = [
        NSUIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0),
        NSUIColor(red: 241/255.0, green: 196/255.0, blue: 15/255.0, alpha: 1.0),
        NSUIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0),
        NSUIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0) ]
    
    //********
    let dataSet = PieChartDataSet(entries: entry, label: "")
    dataSet.drawIconsEnabled = false
    dataSet.colors = Colors
    dataSet.sliceSpace = 2
    
    let data = PieChartData(dataSet: dataSet)
    data.setValueFont(.systemFont(ofSize: 7, weight: .light))
    //   data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
    data.setValueTextColor(.black)
    
    let pFormatter = NumberFormatter()
    pFormatter.numberStyle = .percent
    pFormatter.maximumFractionDigits = 1
    pFormatter.multiplier = 1
    pFormatter.percentSymbol = " %"
    data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
    data.setValueFont(.systemFont(ofSize: 11, weight: .light))
    data.setValueTextColor(.black)
    
    chartView.data = data
    chartView.centerText = centerText
  
    return chartView
    
}
// MARK:- 棒グラフ
      
func drawBarChart(chartData:ChartArray,  legend:String?, numXLabels:Int, topOffset: CGFloat = 10, buttomOffset: CGFloat = 30.0, leftOffset:CGFloat = 10.0,rightOffset:CGFloat = 10.0, flagDateType: Bool,addLines:Bool = false,noDrink:Bool = false, showValue:Bool,showlegend:Bool = true) -> BarChartView{
          
          let chartDataArray = chartData
          var dateStr:[String] = []
          if flagDateType {
              // グラフのX軸用に日付を加工する
              let f = DateFormatter()
              f.timeStyle = .none
              f.dateStyle = .medium
              f.locale = Locale(identifier: "ja_JP")
              dateStr = chartDataArray.map{f.date(from: $0.0)!.shortStr}
          }
          else {
              dateStr = chartDataArray.map{$0.0}
          }
          // グラフのY軸用の配列
          let valueArray = chartDataArray.map{($0.1)}
          
          //   self.title = " 純アルコール量の推移"
          //    let rect = CGRect(x:0, y: 30, width: self.view.frame.width, height: self.view.frame.height * 0.5)
          
          let chartView = BarChartView()
          
          chartView.dragEnabled = false
          chartView.pinchZoomEnabled = false
          chartView.doubleTapToZoomEnabled = false
          chartView.legend.enabled = showlegend
          
          chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
          //  chartView.chartDescription?.text = chartDesc
          //x軸
          // X軸のラベルの位置を下に設定
          chartView.xAxis.labelPosition = .bottom
          // X軸のラベルの色を設定
          chartView.xAxis.labelTextColor = .systemGray
          // X軸の線、グリッドを非表示にする
          chartView.xAxis.drawGridLinesEnabled = false
          chartView.xAxis.drawAxisLineEnabled = false
          chartView.xAxis.labelCount = numXLabels //x軸に表示するラベルの数
          let chartFormatter = BarChartFormatter(labels: dateStr)
          chartView.xAxis.valueFormatter = chartFormatter
          //Y軸
          // 右側のY座標軸は非表示にする
          chartView.rightAxis.enabled = false
          
          // Y座標の値が0始まりになるように設定
          chartView.leftAxis.axisMinimum = 0.0
          chartView.leftAxis.drawZeroLineEnabled = true
          chartView.leftAxis.zeroLineColor = .systemGray
          // ラベルの数を設定
          chartView.leftAxis.labelCount = numXLabels
          // ラベルの色を設定
          chartView.leftAxis.labelTextColor = .systemGray
          // グリッドの色を設定
          chartView.leftAxis.gridColor = .systemGray
          // 軸線は非表示にす
          chartView.leftAxis.drawAxisLineEnabled = false
          
          // バー上にある値の表示(バー内か、バーより上か)
          chartView.drawValueAboveBarEnabled = true
          // それぞれのバーにグレーのエリアが描画される
          chartView.drawBarShadowEnabled = false
          //chartView.drawHighlightArrowEnabled = false
          
          // グラフの余白
          chartView.extraTopOffset = topOffset
          chartView.extraRightOffset = rightOffset
          chartView.extraBottomOffset = buttomOffset
          chartView.extraLeftOffset = leftOffset
          
          if addLines {
              if noDrink {
                  //一週間の休肝日
                  let ll1 = ChartLimitLine(limit: Double(numOfNoDrinkDays), label: "目標の休肝日:"+numOfNoDrinkDays.decimalStrPlain+"日")
                  ll1.lineWidth = 4
                  ll1.lineDashLengths = [5, 5]
                  ll1.labelPosition = .bottomRight
                  ll1.valueFont = .systemFont(ofSize: 10)
                  
                  let leftAxis = chartView.leftAxis
                  leftAxis.addLimitLine(ll1)
                  leftAxis.gridLineDashLengths = [5, 5]
                  leftAxis.drawLimitLinesBehindDataEnabled = false
                  
              }
              else {
              //上限のライン
              let ll1 = ChartLimitLine(limit: targetUnit*10, label: "１日の上限目標"+(targetUnit * 10).decimalStr)
              ll1.lineWidth = 4
              ll1.lineDashLengths = [5, 5]
              ll1.labelPosition = .topRight
              ll1.valueFont = .systemFont(ofSize: 10)
              
              let leftAxis = chartView.leftAxis
              leftAxis.addLimitLine(ll1)
              leftAxis.gridLineDashLengths = [5, 5]
              leftAxis.drawLimitLinesBehindDataEnabled = false
              //平均のライン
              let average = valueArray.reduce(0) { return $0 + $1 } / Double(valueArray.count)
              let ll2 = ChartLimitLine(limit: average, label: "期間平均"+average.decimalStr)
              ll2.lineWidth = 4
              ll2.lineDashLengths = [3, 3]
              ll2.labelPosition = .topLeft
              ll2.valueFont = .systemFont(ofSize: 10)
              leftAxis.addLimitLine(ll2)
              
              leftAxis.gridLineDashLengths = [5, 5]

              leftAxis.drawLimitLinesBehindDataEnabled = false
              }
          }
          // データの読み込みと
          var entry = [BarChartDataEntry]()
          
          for (i, n) in valueArray.enumerated() {
              entry.append(BarChartDataEntry(x: Double(i), y: n))
          }
          let dataSet = BarChartDataSet(entries: entry, label: legend)
          
          dataSet.drawValuesEnabled = false
          
          let themeIndex:Int = MyThemes.currentTheme().rawValue
          dataSet.colors = [UIColor(hexRGB: GlobalPicker.gr_lineColor[themeIndex])!]
          dataSet.drawValuesEnabled = false //各プロットのラベル表示(今回は表示しない)
          dataSet.highlightColor = .red//各点を選択した時に表示されるx,yの線
          
          if showValue {
              dataSet.drawValuesEnabled = true //各プロットのラベル表示
              dataSet.valueFormatter = BarChartValueFormatter() // バーの上の小数点を止める。
          }
          else {
              dataSet.drawValuesEnabled = false //各プロットのラベル表示
          }
          
          chartView.data = BarChartData(dataSet: dataSet)
        return chartView
      }
      
      //小数点表示を整数表示にする処理。バーの上部に表示される数字。
      public class BarChartValueFormatter: NSObject, IValueFormatter{
          public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String{
              return entry.y.decimalStrPlain//String(Int(entry.y))
              //   MATHEMATICAL BOLD SMALL G
              //   Unicode: U+1D420, UTF-8: F0 9D 90 A0)
          }
      }
      //x軸のラベルを設定する
      public class BarChartFormatter: NSObject, IAxisValueFormatter{
          var labels: [String] = []
          
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
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
      
   // MARK:- 線グラフ
    func drawLineChart(chartData:ChartArray,  legend:String?, numXLabels:Int,topOffset: CGFloat = 10.0, buttomOffset: CGFloat = 30.0, leftOffset:CGFloat = 10.0,rightOffset:CGFloat = 10.0, flagDateType: Bool,addLines:Bool,showValue: Bool,showlegend:Bool = true) -> LineChartView {
        // グラフのX軸用に日付を加工する
        var dateStr:[String] = []
        if flagDateType {
            // グラフのX軸用に日付を加工する
            let f = DateFormatter()
            f.timeStyle = .none
            f.dateStyle = .medium
            f.locale = Locale(identifier: "ja_JP")
            dateStr = chartData.map{f.date(from: $0.0)!.shortStr}
        }
        else {
            dateStr = chartData.map{$0.0}
        }
        // グラフのY軸用の配列
        let valueArray = chartData.map{($0.1)}
        
        //     self.title = " 純アルコール量の推移"
     //   let rect = CGRect(x:0, y: 30, width: view.frame.width, height: self.view.frame.height * 0.5)
        let chartView = LineChartView()
        
        chartView.dragEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.legend.enabled = showlegend
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        //chartView.chartDescription?.text = chartDesc
        
        // グラフの余白
        chartView.extraTopOffset = topOffset
        chartView.extraRightOffset = 0.0
        chartView.extraBottomOffset = 0.0
        chartView.extraLeftOffset = 0.0
        
        //x軸
        // X軸のラベルの位置を下に設定
        chartView.xAxis.labelPosition = .bottom
        // X軸のラベルの色を設定
        chartView.xAxis.labelTextColor = .systemGray
        // X軸の線、グリッドを非表示にする
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.labelCount = Int(5) //x軸に表示するラベルの数
        let chartFormatter = LineChartFormatter(labels: dateStr)
        chartView.xAxis.valueFormatter = chartFormatter
        //Y軸
        // 右側のY座標軸は非表示にする
        chartView.rightAxis.enabled = false
        
        // Y座標の値が0始まりになるように設定
        chartView.leftAxis.axisMinimum = 0.0
        chartView.leftAxis.drawZeroLineEnabled = true
        chartView.leftAxis.zeroLineColor = .systemGray
        // ラベルの数を設定
        chartView.leftAxis.labelCount = 5
        // ラベルの色を設定
        chartView.leftAxis.labelTextColor = .systemGray
        // グリッドの色を設定
        chartView.leftAxis.gridColor = .systemGray
        // 軸線は非表示にする
        chartView.leftAxis.drawAxisLineEnabled = false
        
        //上限のライン
        let ll1 = ChartLimitLine(limit: targetUnit*10, label: "１日の上限目標"+(targetUnit * 10).decimalStr)
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .topRight
        ll1.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = chartView.leftAxis
        leftAxis.addLimitLine(ll1)
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = false
        //平均のライン
        let average = valueArray.reduce(0) { return $0 + $1 } / Double(valueArray.count)
        let ll2 = ChartLimitLine(limit: average, label: "期間平均"+average.decimalStr)
        ll2.lineWidth = 4
        ll2.lineDashLengths = [3, 3]
        ll2.labelPosition = .topLeft
        ll2.valueFont = .systemFont(ofSize: 10)
        leftAxis.addLimitLine(ll2)
        
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = false
        // データの読み込みと
        var entry = [ChartDataEntry]()
        
        for (i, n) in valueArray.enumerated() {
            entry.append(ChartDataEntry(x: Double(i), y: n))
        }
        let dataSet = LineChartDataSet(entries: entry, label: legend)
        //     let dataSet = BarChartDataSet(entries: entry, label: "純アルコール量（g）")
        dataSet.drawFilledEnabled = true
        dataSet.drawValuesEnabled = false
        
        let themeIndex:Int = MyThemes.currentTheme().rawValue
        
        dataSet.circleColors = [UIColor(hexRGB:GlobalPicker.gr_dotColor[themeIndex])!]
        dataSet.lineWidth = 3.0 //線の太さ
        dataSet.circleRadius = 3 //プロットの大きさ
        dataSet.drawCirclesEnabled = true //プロットの表示(今回は表示しない)
        dataSet.fillAlpha = 0.4 //グラフの透過率(曲線は投下しない)
        dataSet.fillColor = UIColor(hexRGB: GlobalPicker.gr_fillColor[themeIndex])!
        dataSet.drawFilledEnabled = true //グラフ下の部分塗りつぶし
        
        dataSet.colors = [UIColor(hexRGB: GlobalPicker.gr_lineColor[themeIndex])!]
        dataSet.drawValuesEnabled = false //各プロットのラベル表示(今回は表示しない)
        dataSet.highlightColor = .red//各点を選択した時に表示されるx,yの線
        
        if showValue {
            dataSet.drawValuesEnabled = true //各プロットのラベル表示
            dataSet.valueFormatter = BarChartValueFormatter() // バーの上の小数点を止める。
        }
        else {
            dataSet.drawValuesEnabled = false //各プロットのラベル表示
        }
        
        chartView.data = LineChartData(dataSet: dataSet)
  //      self.view.addSubview(chartView)
  //      lineChartForCoach = chartView
        return chartView
    }
    //x軸のラベルを設定
    
    public class LineChartFormatter: NSObject, IAxisValueFormatter{
        var labels: [String] = []
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
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

//MARK:- ChartのためのArray作成

func generateRawData(reversed:Bool = false) -> RawData {
    var data:RawData = []
    if let dbData = drinkRecord_Results {
      
        for i in dbData {
            if let d = i.dDate {
            let n = i.totalUnits * 10
            let r = i.evaluation
            let item = (date:d,value:n,rating:r)
            data.append(item)// as! (Date, Double))
            }
        }
        if reversed {
            data.sort { (A, B) -> Bool in
            return A.date > B.date
            }}
            else {
                data.sort { (A, B) -> Bool in
                               return A.date < B.date
            }}
        }
    return data
}

func generateRawData(modifiedData:DrinkDailyRecord, reversed:Bool = false) -> RawData {
    var data:RawData = []
    if let dbData = drinkRecord_Results {
        for i in dbData {
             if let d = i.dDate {
            let n = i.totalUnits * 10
            let r = i.evaluation
            let item = (date:d,value:n,rating:r)
            data.append(item)// as! (Date, Double))
            }
        }
    }
    if let firstIndex = data.firstIndex(where:{$0.date == modifiedData.dDate}) {
        data[firstIndex].date = modifiedData.dDate
        data[firstIndex].value = modifiedData.totalAlchool
    }
    else {
        let item = (date:modifiedData.dDate,value:modifiedData.totalAlchool,rating:modifiedData.evaluation)
        data.append(item)
    }
    
    if reversed {
        data.sort { (A, B) -> Bool in
            return A.date > B.date
        }}
    else {
        data.sort { (A, B) -> Bool in
            return A.date < B.date
        }}
    return data
}

func setDataArray(rawdata: RawData) -> ChartArray{ //基本となるデータ配列
    var chartDataArray:ChartArray = [] // fullfilled data array
    //--------------------------------------------------------
    func getDaysArray(start:Date,end:Date) -> [String] { // 日付のデータ配列（空データ）を作る
        //***********************************************************
        func getIntervalDays(start:Date? = nil, end:Date?) ->Double {
            var retInterval:Double!
            let formatter = DateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
            formatter.dateFormat = "yyyy-MM-dd"
            
            if start == nil {
                retInterval = 0
            } else {
                retInterval = end?.timeIntervalSince(start!)
            }
            let ret = retInterval/86400
            return floor(ret)  // n日
        }
         //***********************************************************
      
        var result:[String] = []
        
        // 今日
        
        var components = DateComponents()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let interval = Int(getIntervalDays(start:start, end:end))
        
        for i in 0...interval{
            
            components.setValue(i,for: Calendar.Component.day)
            let wk = calendar.date(byAdding: components, to: start)!
            let wkStr = wk.mediumStr
            result.append(wkStr)
        }
        return result
    } //-------------------------------------------------------
    // データが入力されていない日付を見つけ出し、０を代入して全区間の配列を作る
    let tempDateArray = rawdata.map{($0.0.mediumStr)}
    let firstDate = rawdata.first?.0
    let lastDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    let lastDayOnArray = rawdata.last?.0
    lastDate = (lastDayOnArray! > lastDay) ? lastDayOnArray!: lastDay
    let tempWholeArray = getDaysArray(start: firstDate!, end: lastDate)
    
    for i in tempWholeArray {
        if let index = tempDateArray.firstIndex(where: {$0 == i }){
            let v = rawdata[index].1
            let r = rawdata[index].2
            let item = (i,v,r)
            chartDataArray.append(item)
        }
        else {
            let v = 0.0
            let r = eval.good.rawValue
            let item = (i,v,r)
            chartDataArray.append(item)
        }
    }
    /*
     chartDataArray.sort { (A, B) -> Bool in
     return A.0 < B.0
     }
     */
    return chartDataArray
}

//MARK:- Methods
func terminalAverageDouble(num:Int, array: [(String,Double,String)] ) -> Double {
    let data = array.map{($0.1)}
    var v:Double = 0.0
    
    guard data.count > 0 else {
        return 0
    }
    
    if num == 0 {
        v = data.reduce(0) { return $0 + $1 } / Double(data.count)
    }
    else {
        let terminalArray = data.suffix(num)
        v = terminalArray.reduce(0) { return $0 + $1 } / Double(num)
    }
    return v
}

func avgDrinkFullPeriods(array:ChartArray) -> ChartArray{//期間毎の平均値のデータ配列
    var valueArray:ChartArray = []
    let totalCount = array.count
    let nodata = "n/a"
    
    for i in [7,14,21,array.count] {
        let value = terminalAverageDouble(num: i, array: array)
        let item = ("過去"+String(i)+"日",value,"")
        valueArray.append(item)
    }
    
    if totalCount < 7 {
        valueArray[0] = (xval:"過去7日"+nodata,yval:0.0,"")
        valueArray[1] = (xval:"過去14日"+nodata,yval:0.0,"")
        valueArray[2] = (xval:"過去21日"+nodata,yval:0.0,"")}
    else if totalCount < 14 {
        valueArray[1] = (xval:"過去14日"+nodata,yval:0.0,"")
        valueArray[2] = (xval:"過去21日"+nodata,yval:0.0,"")}
    else if totalCount < 21 {
        valueArray[2] = (xval:"過去21日"+nodata,yval:0.0,"") }
    
    valueArray[3].xval = "期間"
    return valueArray
}

func terminalRatingCountDouble(num:Int, array: [(String,Double,String)] ) -> [Double] {
    let data = array.map{($0.2)}
    var v:[Double] = []
    
    guard data.count > 0 else {
        return [0,0,0,0]
    }
    /*
    if num == 0 {
        v = data.reduce(0) { return $0 + $1 } / Double(data.count)
    }
    else {
 */
    let terminalArray = data.suffix(num)
    let good = Double( terminalArray.filter { $0  == eval.good.rawValue  }.count)
    let norm = Double( terminalArray.filter { $0  == eval.improving.rawValue }.count)
    let bad = Double( terminalArray.filter { $0  == eval.bad.rawValue }.count)
    let verybad = Double( terminalArray.filter { $0  == eval.veryBad.rawValue }.count)
    v = [good,norm,bad,verybad]
  //  }
    return v
}

func countRating(array:ChartArray) -> StackedChartArray {
    
    var valueArray:StackedChartArray = []
    let totalCount = array.count
    let nodata = "n/a"
    
    for i in [7,14,21,array.count] {
        let value:[Double] = terminalRatingCountDouble(num: i, array: array)
        let item:(xval:String, yval:[Double]) = (xval:"過去"+String(i)+"日",yval:value)
        valueArray.append(item)
    }
    
  if totalCount < 7 {
        valueArray[0] = (xval:"過去7日"+nodata,yval:[0,0,0,0])
        valueArray[1] = (xval:"過去14日"+nodata,yval:[0,0,0,0])
        valueArray[2] = (xval:"過去21日"+nodata,yval:[0,0,0,0])}
    else if totalCount < 14 {
        valueArray[1] = (xval:"過去14日"+nodata,yval:[0,0,0,0])
        valueArray[2] = (xval:"過去21日"+nodata,yval:[0,0,0,0])}
    else if totalCount < 21 {
        valueArray[2] = (xval:"過去21日"+nodata,yval:[0,0,0,0]) }
    
    valueArray[3].xval = "期間"
    return valueArray
}

func excessOrNoDrinkLatest1week (array: ChartArray, calc:Ecalc) -> Double {
    let data = array.map{($0.1)}
 //   let haircut = numOfexcessOrNoDrinkFullPeriodDays
    guard !(data.count == 0) else { return 0}
    
    let last7array = data.suffix(7)
    let value  = Double(( calc == Ecalc.noDrink ) ? last7array.filter { $0 == 0 }.count : last7array.filter {$0 > Double(excessDrinkHairCut)*targetUnit*10 }.count)
    return value
}

func excessOrNoDrinkLatest30days (array: ChartArray, calc:Ecalc) -> Double {
    let data = array.map{($0.1)}
 //   let haircut = numOfexcessOrNoDrinkFullPeriodDays
    guard !(data.count == 0) else { return 0}
    
    let last30array = data.suffix(30)
    let value  = Double(( calc == Ecalc.noDrink ) ? last30array.filter { $0 == 0 }.count : last30array.filter {$0 > Double(excessDrinkHairCut)*targetUnit*10 }.count)
    return value
}

func excessOrNoDrinkFullPeriod (array: ChartArray, calc:Ecalc) -> ChartArray {
    let dataRVS = array.map{($0.1)}.reversed()
    let data:[Double] = dataRVS.map{($0)}
//    var data:[Double] = []
//    for i in dataRVS {
//        data.append(i)
//    }
          let base:Int = 7
          let haircut:Double = Double(excessDrinkHairCut) * targetUnit * 10
          let noData = "データ無し"
          let titleStr = ["直近一週間","２週前","３週前","4週前"]
    
       var array:ChartArray = []
          
          for i in 0...3 {
            let item:(xval:String, yval:Double,rating:String) = (xval:titleStr[i],yval:0.0,"")
              array.append(item)
          }
          
          if data.count >= 28 {
              for i in  0...3 {
                  let parialArray = data[base*i...base+base*i-1]
               array[i].yval = Double(( calc == Ecalc.noDrink ) ? parialArray.filter { $0  == 0 }.count : parialArray.filter { $0 >  haircut }.count)
              }
          }
          else if data.count >= 21 {
              for i in  0...2 {
                  let parialArray = data[base*i...base+base*i-1]
               array[i].yval = Double(( calc == Ecalc.noDrink ) ? parialArray.filter { $0  == 0 }.count : parialArray.filter { $0 >  haircut }.count)
                  array[3].xval = noData
              }
          }
          else if data.count >= 14 {
              for i in  0...1 {
                  let parialArray = data[base*i...base+base*i-1]
               array[i].yval = Double(( calc == Ecalc.noDrink ) ? parialArray.filter { $0  == 0 }.count : parialArray.filter { $0  >  haircut }.count)
                  array[2].xval = noData
                  array[3].xval = noData
              }
          }
          else if data.count >= 7 {
           array[0].yval = Double(( calc == Ecalc.noDrink ) ? data.filter { $0  == 0 }.count : data.filter { $0  >  haircut }.count)
              array[1].xval = noData
              array[2].xval = noData
              array[3].xval = noData
          }
          
          return array
      }

