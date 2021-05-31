//
//  DatEntryViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/11/30.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import Eureka
import SnapKit

class QuickDataEntryViewController: FormViewController {
    
    let evalViewSegue  = "showEvalViewFromQuick"
    
    //MARK:- IB Properties and Functions
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var moveToReview: UIButton!
    @IBOutlet var viewBackGround: UIView!
    @IBOutlet weak var noButton: UIButton!
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        if flagChanged {
            showAlert(title: "データが入力/変更されています",message: "保存しないで続行しますか？") }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func pressMoveButton(_ sender: UIButton) {
        performSegue(withIdentifier: evalViewSegue, sender: Any?.self)
    }
    
    // MARK:- Properties
    // var stepValue:Double = 0.0
    //   var dname =  ""
    var drinkDaily = DrinkDailyRecord(dDate: Date(), drinks:[eDname:Int]())
    var flagChanged = false
    
    let maxLimit:Double = 9000
    let attributes: [NSAttributedString.Key : Any] = [
        .font : UIFont.systemFont(ofSize: 11.0), // 文字色
    ]
    //MARK:- Methods
    func noDrinkDay() {
        
        let oldData = drinkDaily
        var zeroDrinkDay = drinkDaily
        for (key, _) in zeroDrinkDay.drinks {
            zeroDrinkDay.drinks[key] = 0
        }
        let data = setDataArray(rawdata: generateRawData(modifiedData: zeroDrinkDay))
        let noDrinkDaysFor7days = "過去７日間"+(excessOrNoDrinkLatest1week(array: data, calc: Ecalc.noDrink)).decimalStrPlain+"日"
        let noDrinkDaysFor30days = "過去30日間"+(excessOrNoDrinkLatest1week(array: data, calc: Ecalc.noDrink)).decimalStrPlain+"日"
        
        
        showAnimation(parentView:self.view, lottieJason: "lf30_editor_st8bizys",scale:80)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            let msg = "全部0"+ml+"にリセットします。"+"\n"+"休肝日は:"+"\n"+noDrinkDaysFor7days+"\n"+noDrinkDaysFor30days
            self.present(.okPlusAlert(title:"やりましたね!", message: msg,astyle: .alert,okstr:"レビュー画面に進む",
                                      okHandler: { [self](action) -> Void in
                                        self.drinkDaily = zeroDrinkDay
                                        self.tableView.reloadData()
                                        self.performSegue(withIdentifier: self.evalViewSegue, sender: Any.self)},
                                      cancelHandler:{(action) -> Void in
                                        self.drinkDaily = oldData
                                        self.tableView.reloadData()
                                      }
            ))
        }
    }
    
    //MARK:- Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == evalViewSegue  {
            let controller = segue.destination as!  EvalViewController
            controller.drinkDaily = shouldShowCoarch ? dailyDrinkDummy:self.drinkDaily
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if  (identifier == evalViewSegue)
        {return true }
        else
        { guard !(drinkDaily.evaluation == eval.no.rawValue) else {
            let point = moveToReview
            addAnimation(view: point!)
            present(.okAlert(title: "飲酒のレヴューが必要です。", message: "レヴュー画面に進んでください。",astyle: .alert))
            return false
        }
        return true }
    }
    //MARK:- View Rotation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        viewBackGround.theme_backgroundColor = GlobalPicker.backgroundColor
        setButtonProperties(button:moveToReview,backColor:GlobalPicker.buttonTintColor2,titleColorOnDark:GlobalPicker.buttonTintColor3)
        
        
        if shouldShowCoarch {
            moveToReview.isEnabled = true
        }
        else{
            moveToReview.isEnabled = (drinkDaily.evaluation == eval.no.rawValue) ? false:true
        }
        
        moveToReview.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(35)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(50)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(moveToReview.snp.top).offset(-15)
        }
        
        view.theme_backgroundColor = GlobalPicker.barTintColor
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        
        navigationItem.title = "グラスの数でクイック入力"
        cancelBtn.isEnabled = true
        let entry_instruction = "👉入力したいお酒をタップします。"
        //入力のための数字指定
        let minimumValue:Double = 0.0
        let maximumValue:Double = 10.0
        let stepValue:Double = 0.1
        
        //MARK:- Eureka
        LabelRow.defaultCellUpdate = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.cellBackGround_dataEntry
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            //     cell.theme_tintColor = GlobalPicker.labelTextColor
        }
        
        PickerInlineRow<Double>.defaultCellUpdate = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.cellBackGround_dataEntry
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            //    cell.theme_tintColor = GlobalPicker.labelTextColor
        }
        
        //MARK:- quick entry section
        
        form = Section(drinkDaily.dDate.mediumStr+entry_instruction)
        //MARK:- Wine
            <<< PickerInlineRow<Double>("PickerInlineRow") { (row : PickerInlineRow<Double>) -> Void in
                let rowId:eDname = eDname.wine //TODO: 酒の種類を指定する
                row.tag = rowId.tag+"1"
                row.displayValueFor = { (rowValue: Double?) in
                    return rowValue.map { $0.decimalStrPlain1+"杯("+rowId.Glasses2Amount(numGlass: $0).decimalStrMl+")"}
                }
                row.value = rowId.Amount2Glasses(damount: self.drinkDaily.drinks[rowId] ?? 0)
                row.options = []
                for n in stride(from: minimumValue, to: maximumValue, by: stepValue) {
                    row.options.append(Double(n)) }
            }
            .cellUpdate() {cell, row in
                let rowId:eDname = eDname.wine //TODO: 酒の種類を指定する
                cell.textLabel?.attributedText = setAttribute(title1: rowId.ctitle (emoji: emojiSwitch), title2:  "(x"+alc_quick[rowId]!.decimalStrCC+")")
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                //cell.detailTextLabel?.text = "\(Int(row.value!))"+ml
            }
            .onChange {
                let rowId:eDname = eDname.wine //TODO: 酒の種類を指定する
                self.drinkDaily.drinks[rowId] = rowId.Glasses2Amount(numGlass: $0.value!)
                self.update()
            }
         //MARK:- Nihonsyu
            <<< PickerInlineRow<Double>("PickerInlineRow") { (row : PickerInlineRow<Double>) -> Void in
                let rowId:eDname = eDname.nihonsyu //TODO: 酒の種類を指定する
                row.tag = rowId.tag+"1"
                row.displayValueFor = { (rowValue: Double?) in
                    return rowValue.map { $0.decimalStrPlain1+"杯("+rowId.Glasses2Amount(numGlass: $0).decimalStrMl+")"}
                }
                row.value = rowId.Amount2Glasses(damount: self.drinkDaily.drinks[rowId] ?? 0)
                row.options = []
                for n in stride(from: minimumValue, to: maximumValue, by: stepValue) {
                    row.options.append(Double(n)) }
            }
            .cellUpdate() {cell, row in
                let rowId:eDname = eDname.nihonsyu //TODO: 酒の種類を指定する
                cell.textLabel?.attributedText = setAttribute(title1: rowId.ctitle (emoji: emojiSwitch), title2:  "(x"+alc_quick[rowId]!.decimalStrCC+")")
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                //cell.detailTextLabel?.text = "\(Int(row.value!))"+ml
            }
            .onChange {
                let rowId:eDname = eDname.nihonsyu //TODO: 酒の種類を指定する
                self.drinkDaily.drinks[rowId] = rowId.Glasses2Amount(numGlass: $0.value!)
                self.update()
            }
           //MARK:- Beer
            <<< PickerInlineRow<Double>("PickerInlineRow") { (row : PickerInlineRow<Double>) -> Void in
                let rowId:eDname = eDname.beer //TODO: 酒の種類を指定する
                row.tag = rowId.tag+"1"
                row.displayValueFor = { (rowValue: Double?) in
                    return rowValue.map { $0.decimalStrPlain1+"杯("+rowId.Glasses2Amount(numGlass: $0).decimalStrMl+")"}
                }
                row.value = rowId.Amount2Glasses(damount: self.drinkDaily.drinks[rowId] ?? 0)
                row.options = []
                for n in stride(from: minimumValue, to: maximumValue, by: stepValue) {
                    row.options.append(Double(n)) }
            }
            .cellUpdate() {cell, row in
                let rowId:eDname = eDname.beer //TODO: 酒の種類を指定する
                cell.textLabel?.attributedText = setAttribute(title1: rowId.ctitle (emoji: emojiSwitch), title2:  "(x"+alc_quick[rowId]!.decimalStrCC+")")
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                //cell.detailTextLabel?.text = "\(Int(row.value!))"+ml
            }
            .onChange {
                let rowId:eDname = eDname.beer //TODO: 酒の種類を指定する
                self.drinkDaily.drinks[rowId] = rowId.Glasses2Amount(numGlass: $0.value!)
                self.update()
            }
            //MARK:- Shocyu
            <<< PickerInlineRow<Double>("PickerInlineRow") { (row : PickerInlineRow<Double>) -> Void in
                let rowId:eDname = eDname.shocyu //TODO: 酒の種類を指定する
                row.tag = rowId.tag+"1"
                row.displayValueFor = { (rowValue: Double?) in
                    return rowValue.map { $0.decimalStrPlain1+"杯("+rowId.Glasses2Amount(numGlass: $0).decimalStrMl+")"}
                }
                row.value = rowId.Amount2Glasses(damount: self.drinkDaily.drinks[rowId] ?? 0)
                row.options = []
                for n in stride(from: minimumValue, to: maximumValue, by: stepValue) {
                    row.options.append(Double(n)) }
            }
            .cellUpdate() {cell, row in
                let rowId:eDname = eDname.shocyu //TODO: 酒の種類を指定する
                cell.textLabel?.attributedText = setAttribute(title1: rowId.ctitle (emoji: emojiSwitch), title2:  "(x"+alc_quick[rowId]!.decimalStrCC+")")
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                //cell.detailTextLabel?.text = "\(Int(row.value!))"+ml
            }
            .onChange {
                let rowId:eDname = eDname.shocyu //TODO: 酒の種類を指定する
                self.drinkDaily.drinks[rowId] = rowId.Glasses2Amount(numGlass: $0.value!)
                self.update()
            }
           //MARK:- Whisky
            <<< PickerInlineRow<Double>("PickerInlineRow") { (row : PickerInlineRow<Double>) -> Void in
                let rowId:eDname = eDname.whisky //TODO: 酒の種類を指定する
                row.tag = rowId.tag+"1"
                row.displayValueFor = { (rowValue: Double?) in
                    return rowValue.map { $0.decimalStrPlain1+"杯("+rowId.Glasses2Amount(numGlass: $0).decimalStrMl+")"}
                }
                row.value = rowId.Amount2Glasses(damount: self.drinkDaily.drinks[rowId] ?? 0)
                row.options = []
                for n in stride(from: minimumValue, to: maximumValue, by: stepValue) {
                    row.options.append(Double(n)) }
            }
            .cellUpdate() {cell, row in
                let rowId:eDname = eDname.whisky //TODO: 酒の種類を指定する
                cell.textLabel?.attributedText = setAttribute(title1: rowId.ctitle (emoji: emojiSwitch), title2:  "(x"+alc_quick[rowId]!.decimalStrCC+")")
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                //cell.detailTextLabel?.text = "\(Int(row.value!))"+ml
            }
            .onChange {
                let rowId:eDname = eDname.whisky //TODO: 酒の種類を指定する
                self.drinkDaily.drinks[rowId] = rowId.Glasses2Amount(numGlass: $0.value!)
                self.update()
            }
           //MARK:- can
            <<< PickerInlineRow<Double>("PickerInlineRow") { (row : PickerInlineRow<Double>) -> Void in
                let rowId:eDname = eDname.can //TODO: 酒の種類を指定する
                row.tag = rowId.tag+"1"
                row.displayValueFor = { (rowValue: Double?) in
                    return rowValue.map { $0.decimalStrPlain1+"杯("+rowId.Glasses2Amount(numGlass: $0).decimalStrMl+")"}
                }
                row.value = rowId.Amount2Glasses(damount: self.drinkDaily.drinks[rowId] ?? 0)
                row.options = []
                for n in stride(from: minimumValue, to: maximumValue, by: stepValue) {
                    row.options.append(Double(n)) }
            }
            .cellUpdate() {cell, row in
                let rowId:eDname = eDname.can //TODO: 酒の種類を指定する
                cell.textLabel?.attributedText = setAttribute(title1: rowId.ctitle (emoji: emojiSwitch), title2:  "(x"+alc_quick[rowId]!.decimalStrCC+")")
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                //cell.detailTextLabel?.text = "\(Int(row.value!))"+ml
            }
            .onChange {
                let rowId:eDname = eDname.can //TODO: 酒の種類を指定する
                self.drinkDaily.drinks[rowId] = rowId.Glasses2Amount(numGlass: $0.value!)
                self.update()
            }
         //MARK:- 休肝日のボタン
            <<< ButtonRow() {
                $0.tag = "noDrink"
                $0.title = "休肝日はここをタップ!"
                $0.cellStyle = .default
                // $0.cell.theme_tintColor = GlobalPicker.buttonTintColor3
            }
            .cellSetup() {cell ,row in
                cell.textLabel?.textAlignment = .center
                cell.theme_backgroundColor = GlobalPicker.buttonTintColor4
            }
            
            .onCellSelection { cell, row in
                self.noDrinkDay()
            }
            //MARK:- 計算結果
            +++ Section("計算結果：合計の純アルコール量")
            <<< LabelRow () {
                
                $0.tag = "totalUnits1"
                $0.title = drinkDaily.emojiStr
                $0.value = drinkDaily.totalAlchool.decimalStr
            }
            .cellUpdate { cell, row in             // .updateCellで実行される
                row.value = self.drinkDaily.totalAlchool.decimalStr
                row.title = self.drinkDaily.emojiStr
                cell.theme_backgroundColor = GlobalPicker.cellBackGround_dataEntry
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            }
        
    }
    
    func update() {
        flagChanged = true
        moveToReview.isEnabled = true
        //      doneBtn.isEnabled = true
        
        if let totalUnitRow = self.form.rowBy(tag: "totalUnits1") {
            // 対象のセレクトボックスにデータを入れるために.cellUpdateを呼ぶ
            totalUnitRow.updateCell()
            totalUnitRow.reload()
        }
    }
    
    //MARK:-User interface
    
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
    
    //MARK:- Night Mode
    
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
