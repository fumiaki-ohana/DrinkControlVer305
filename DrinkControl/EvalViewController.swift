//
//  EvalViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/10.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import Eureka
import Charts
import Instructions
import SnapKit

class EvalViewController: FormViewController,CoachMarksControllerDataSource,CoachMarksControllerDelegate {
    
    //MARK:- Properties
    var drinkDaily = DrinkDailyRecord(dDate: Date(), drinks:[eDname:Int]())
    var twoDimArray = [tableArray]() // UITable
    let unitStr:String = "g"
    let xChar = "\u{1F167}"
    var coarchChartView = LineChartView()
   
    @IBOutlet weak var BackToDataEntry: UIBarButtonItem!
   
    //MARK:- Coach
    // Coarch properties
        private var pointOfInterest:UIView!
        let coachMarksController = CoachMarksController()
    let hintStr=["あなたの飲酒量の推移です。"
        ,"直近7日間の状況です。","☝️昨夜のお酒は、どう思いますか？\n\nここでは適量を超えた飲酒量なので「悪い」を選びましたが、ご自身の基準でOK。","☝️コメントも残してお酒を飲む前に読み返しましょう。\n\n通知機能でお知らせも設定できます。"]
            
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        //表示するスポットライトの数。チュートリアルの数。
        return hintStr.count
    }
          
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              willShow coachMark: inout CoachMark,
                              beforeChanging change: ConfigurationChange,
                              at index: Int) {
        var  point:UIView!
        switch index {
        case 0: coachMark.arrowOrientation = .bottom
        case 2:
            let p =  form.rowBy(tag: "evaluation")
            point = p?.baseCell
            addAnimation(view: point)
            if let evalCell = self.form.rowBy(tag: "evaluation") {
                // 対象のセレクトボックスにデータを入れるために.cellUpdateを呼ぶ
                evalCell.updateCell()
                evalCell.reload()
            }
        case 3:
            let p =  form.rowBy(tag: "comment")
            point = p?.baseCell
            addAnimation(view: point)
        default:break
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        //指し示す場所を決める。
        var point:UIView!
        switch index {
        case 0:
            point = coarchChartView.self
        case 1:
            let p =  form.rowBy(tag: "7days")
            point = p?.baseCell
        case 2:
            let p =  form.rowBy(tag: "evaluation")
            point = p?.baseCell
            
        case 3:
            let p =  form.rowBy(tag: "comment")
            point = p?.baseCell
            
        default:break
        }
        return coachMarksController.helper.makeCoachMark(for: point)
    }
    
            
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
        justFinishedCoachCources = .dataEntry
        let index = navigationController!.viewControllers.count - 3
        navigationController?.popToViewController(navigationController!.viewControllers[index], animated: true)
        
    }

    // MARK:- View Rotation
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !shouldShowCoarch else {
        self.coachMarksController.start(in: .currentWindow(of: self))
        return
        }
    }
    
    override func viewDidLoad() {
        var data:ChartArray = []
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        data = shouldShowCoarch ? chartDataArrayDummy: setDataArray(rawdata: generateRawData(modifiedData: drinkDaily))
        let lastDateStr = data.last!.xval
        let sectionHeader:[String] = ["この日の純アルコール量:"+drinkDaily.totalAlchool.decimalStr,lastDateStr+"直近7日間"]
        navigationItem.title = drinkDaily.dDate.mediumStr
        
        //MARK:- Eureka form
        self.tableView?.rowHeight = 40.0
        
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.cellBackGround_dataEntry
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            //     cell.theme_tintColor = GlobalPicker.labelTextColor
        }
        TextAreaRow.defaultCellUpdate = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.cellBackGround_dataEntry
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            cell.textView.theme_textColor = GlobalPicker.labelTextColor
            //    cell.theme_tintColor = GlobalPicker.labelTextColor
        }
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        
        if drinkDaily.totalAlchool == 0 {drinkDaily.evaluation = eval.good.rawValue}// ゼロだったら、あらかじめ良いをデフォルトにする。
    
    //MARK:- Eureka
        form +++
            Section(){section in
                var header = HeaderFooterView<UILabel>(.class)
                header.height = { 44.0 }
                header.onSetupView = {view, _ in
                    view.theme_textColor = GlobalPicker.buttonTintColor4
                    view.text = sectionHeader[0]
                    view.font = UIFont.boldSystemFont(ofSize: 20)
                    view.textAlignment = .center
                }
                section.header = header
            }

            <<< SegmentedRow<String>() {
                $0.tag = "evaluation"
                //  $0.title = "🤔"
                $0.value = shouldShowCoarch ? eval.bad.rawValue : drinkDaily.evaluation
                $0.options = [eval.good.rawValue,
                              eval.improving.rawValue,
                              eval.bad.rawValue,
                              eval.veryBad.rawValue]
                //              eval.no.rawValue]
                $0.onChange {
                    self.drinkDaily.evaluation = $0.value!
                    
                }
                .cellUpdate {cell, row in
                    cell.theme_backgroundColor = GlobalPicker.cellBackGround_dataEntry
                    cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                }
                
            }
            
                    <<< TextAreaRow() {
                        let coarchComment = "【コメント】お酒のちゃんぽんは最大２種類まで。「まずはビール」はしばらく止めてみる。 "
                        $0.tag = "comment"
                        $0.value = shouldShowCoarch ? coarchComment : drinkDaily.comment
                     //   $0.title = "コメント"
                        $0.placeholder = "【コメント入力】"
                        $0.textAreaHeight = .dynamic(initialTextViewHeight: 30)
                        $0.onChange {
                            self.drinkDaily.comment = $0.value ?? ""
                            
                        }
                        .cellUpdate {cell, row in
                            cell.theme_backgroundColor = GlobalPicker.cellBackGround_dataEntry
                            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                        }
                        /*
                        .onChange({ [weak self] row in
                              self?.view.layoutIfNeeded() //or self?.tableView.layoutIfNeeded()
                        })
 */
 }
            
            +++ Section() {section in // "平均純アルコール量は"+terminalAverageDouble(num: 7, array: data).decimalStr)
            var header = HeaderFooterView<UILabel>(.class)
            header.height = { 44.0 }
            header.onSetupView = {view, _ in
                view.theme_textColor = GlobalPicker.buttonTintColor4
                view.text = sectionHeader[1]
                view.font = UIFont.boldSystemFont(ofSize: 20)
                view.textAlignment = .center
            }
            section.header = header
        }
   
            <<< LabelRow () {
                $0.title = "休肝日は"+excessOrNoDrinkLatest1week(array: data, calc: Ecalc.noDrink).decimalStrPlain+"日"
                $0.value = "飲み過ぎは"+excessOrNoDrinkLatest1week(array: data, calc: Ecalc.excess).decimalStrPlain+"日"
                $0.tag = "7days"
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
        
        <<< LabelRow () {
            $0.title = "純アルコール量の平均："
            $0.value = terminalAverageDouble(num: 7, array: data).decimalStr

            
        }
        .cellUpdate() {cell, row in
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(20)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
               switch graphType {

               case 0: let barChartView = drawBarChart(chartData: data, legend: "", numXLabels: 5, topOffset: 10,buttomOffset: 20, flagDateType: true, addLines: true,showValue: false,showlegend:false)
                self.view.addSubview(barChartView)
                barChartView.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(tableView.snp.bottom).offset(20)
                    make.left.equalTo(self.view).offset(10)
                    make.right.equalTo(self.view).offset(-10)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)}
                
               case 1: let lineChartView = drawLineChart(chartData: data, legend: "", numXLabels: 5, topOffset:10,buttomOffset:20, flagDateType: true, addLines: true,showValue: false,showlegend:false)
                self.view.addSubview(lineChartView)
                coarchChartView = lineChartView
                
                lineChartView.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(tableView.snp.bottom).offset(20)
                    make.left.equalTo(self.view).offset(10)
                    make.right.equalTo(self.view).offset(-10)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)}
               default:break
               }
        
        }
    
    
    //MARK:- Segue
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        /*
         if  (identifier == "showChartFromDataEntrySegue")
         {return true }
         else
         {
         */
        guard !(drinkDaily.evaluation == eval.no.rawValue) else {
            let p =  form.rowBy(tag: "evaluation")
            let point = p?.baseCell
            addAnimation(view: point!)
            present(.okAlert(title: "エラー", message: "感想を選んでください。"))
            
            return false
        }
        //      shouldWrapUpCoarch = true
        return true }
//}

    //MARK:- User interface
    func showAlert(title: String?, message: String?)  {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: OKstr,
                                     style: .default) { action in
                                        self.navigationController?.popViewController(animated: true)}
        
        let cancelAction = UIAlertAction(title: cancelTitleStr,
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Dark mode support
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


