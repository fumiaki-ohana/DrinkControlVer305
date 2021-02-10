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
//import AMPopTip
import Instructions
import SnapKit

class DatEntryViewController: FormViewController,CoachMarksControllerDataSource,CoachMarksControllerDelegate {

 //MARK:- IB Properties and Functions
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
   @IBOutlet weak var moveToReview: UIButton!
    @IBOutlet var viewBackGround: UIView!
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        if flagChanged {
            showAlert(title: "データが入力/変更されています",message: "保存しないで続行しますか？") }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func pressMoveButton(_ sender: UIButton) {
           performSegue(withIdentifier: "showEvalViewSegue", sender: Any?.self)
       }
    
    @IBAction func pressNoDrinkBtn(_ sender: UIButton) {
        noDrinkDay()
    }
    
    // MARK:- Coarch properties
    private var pointOfInterest:UIView!
    let coachMarksController = CoachMarksController()
    let hintStr  = ["🍷昨夜はワインを200㎖。","🍺ビールも350㎖、🍶日本酒も200㎖飲みました。\n💡TIP(±50)はワンクリックでの増減量ccで、変更できます。","純アルコール量の合計を、自動的に計算します。\n\n💡ヒント:お酒の種類や、ワンクリックでの入力量は【⚙️設定】で変えられます。",
        "💡休肝日㊗️だった時は、ここをタップ！","好みでグラスの数での入力にも変更できます。（設定＞クイック入力）",
         "☝️入力が完了したら、レビュー画面に移動します。"]
    
    // MARK:- Properties
    var stepValue:Double = 0.0
    var dname =  ""
    var drinkDaily = DrinkDailyRecord(dDate: Date(), drinks:[eDname:Int]())
    var flagChanged = false
    let prefix = "(±"
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
            let msg = "全部0ccにリセットします。"+"\n"+"休肝日は:"+"\n"+noDrinkDaysFor7days+"\n"+noDrinkDaysFor30days
            self.present(.okPlusAlert(title:"やりましたね!", message: msg,astyle: .alert,okstr:"レビュー画面に進む",
                                      okHandler: {(action) -> Void in
                                        self.drinkDaily = zeroDrinkDay
                                        self.tableView.reloadData()
                                        self.performSegue(withIdentifier: "showEvalViewSegue", sender: Any.self)},
                                      cancelHandler:{(action) -> Void in
                                        self.drinkDaily = oldData
                                        self.tableView.reloadData()
                                      }
            ))
        }
    }
    
    // MARK:- Coarch
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return hintStr.count
    }
        
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        var point:UIView!
        switch index {
        case 0:
            let p = form.rowBy(tag: "wineEntry")
            point = p?.baseCell
        case 1:
            let p = form.rowBy(tag: "beerEntry")
            point = p?.baseCell
        case 2:
            let p = form.rowBy(tag: "totalUnits")
            point = p?.baseCell
        case 3:
            let p = form.rowBy(tag: "noDrink")
            point = p?.baseCell
        case 4:
            point = navigationController?.navigationBar
        case 5:
            point = moveToReview
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
                              willShow coachMark: inout CoachMark,
                              beforeChanging change: ConfigurationChange,
                              at index: Int) {
        var  point:UIView!
        switch index {
        case 0:
            let p = form.rowBy(tag: "wineEntry")
            point = p?.baseCell
            addAnimation(view: point)
        case 1:
            let p = form.rowBy(tag: "beerEntry")
            point = p?.baseCell
            addAnimation(view: point)
        case 2:
            let p = form.rowBy(tag: "totalUnits")
            point = p?.baseCell
            addAnimation(view: point)
        case 3:
            point = moveToReview
            addAnimation(view: point)
        default:break
        }
    }
    
       func coachMarksController(_ coachMarksController: CoachMarksController,
                                 didEndShowingBySkipping skipped: Bool) {
           
        performSegue(withIdentifier: "showEvalViewSegue", sender: Any?.self)
          
       }
   
   //MARK:- Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEvalViewSegue"  {
        let controller = segue.destination as!  EvalViewController
            controller.drinkDaily = shouldShowCoarch ? dailyDrinkDummy:self.drinkDaily
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if  (identifier == "showEvalViewSegue")
        {return true }
        else
        { guard !(drinkDaily.evaluation == eval.no.rawValue) else {
            let point = moveToReview
            addAnimation(view: point!)
            present(.okAlert(title: "飲酒結果のレヴューが必要です。", message: "レヴュー画面に進んでください。",astyle: .alert))
            return false
            }
            return true }
    }
    
    //MARK:- Eureka Table
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
     
     //MARK:- View Rotation
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         guard !shouldShowCoarch else {
            self.coachMarksController.start(in: .currentWindow(of: self))
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        viewBackGround.theme_backgroundColor = GlobalPicker.backgroundColor
      //  setButtonProperties(button: noButton)
        setButtonProperties(button:moveToReview,backColor:GlobalPicker.buttonTintColor2,titleColorOnDark:GlobalPicker.buttonTintColor3)
        
        if shouldShowCoarch {
            moveToReview.isEnabled = true
        }
        else{
            moveToReview.isEnabled = (drinkDaily.evaluation == eval.no.rawValue) ? false:true
        }

     //   doneBtn.isEnabled = false
        
        self.coachMarksController.dataSource = self
        self.coachMarksController.delegate = self
        
        moveToReview.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(35)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(50)
            make.left.equalTo(self.view).offset(5)
            make.right.equalTo(self.view).offset(-5)
            make.bottom.equalTo(moveToReview.snp.top).offset(-15)
        }
        
      //  tableView.frame =
      //          CGRect(x: 10, y: 50,  width: self.view.bounds.size.width-20, height: //(self.view.bounds.size.height - 360))
       
        view.theme_backgroundColor = GlobalPicker.barTintColor
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        navigationItem.title = "飲酒量を直接入力"
        
        cancelBtn.isEnabled = true
   //     self.moveToReview.tintColor = UIColor.white
        
     
    //MARK:- Eureka
        LabelRow.defaultCellUpdate = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.cellBackGround_dataEntry
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            //     cell.theme_tintColor = GlobalPicker.labelTextColor
        }
        
        StepperRow.defaultCellUpdate = { cell, row in
            cell.theme_backgroundColor = GlobalPicker.cellBackGround_dataEntry
            cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
            //    cell.theme_tintColor = GlobalPicker.labelTextColor
        }
        
        form +++
            Section(drinkDaily.dDate.mediumStr)
            <<< StepperRow() {
                $0.tag = "wineEntry"
                $0.cell.stepper.stepValue = alc_step[eDname.wine]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.wine]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+ml
                }
                $0.title = " "
                $0.value = Double(drinkDaily.drinks[eDname.wine] ?? 0)
            }
            .onChange {
                let v = floor(Double($0.value!))
                self.drinkDaily.drinks[eDname.wine] = Int(v)
                self.stepValue = alc_step[eDname.wine]!
                self.dname = eDname.wine.rawValue
                self.update()
                
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.titleLabel.attributedText = setAttribute(title1: eDname.wine.ctitle (emoji: emojiSwitch), title2: self.prefix+alc_quick[eDname.wine]!.decimalStrPlain+")")
           //     row.value = Double(self.drinkDaily.drinks[eDname.wine] ?? 0)
            }
            
            <<< StepperRow() {
                $0.tag = "nihonsyuEntry"
                $0.cell.stepper.stepValue = alc_step[eDname.nihonsyu]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.nihonsyu]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+ml
                }
                $0.title = " "
                $0.value = Double(drinkDaily.drinks[eDname.nihonsyu] ?? 0)
            }
            .onChange {
                let v = floor(Double($0.value!))
                self.drinkDaily.drinks[eDname.nihonsyu] = Int(v)
                self.stepValue = alc_step[eDname.nihonsyu]!
                self.dname = eDname.nihonsyu.rawValue
                self.update()
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.titleLabel.attributedText = setAttribute(title1: eDname.nihonsyu.ctitle (emoji: emojiSwitch), title2: self.prefix+alc_step[eDname.nihonsyu]!.decimalStrPlain+")")
           //     row.value = Double(self.drinkDaily.drinks[eDname.nihonsyu] ?? 0)
            }
            
            <<< StepperRow() {
                 $0.tag = "beerEntry"
                $0.cell.stepper.stepValue = alc_step[eDname.beer]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.beer]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+ml
                }
                $0.title = " "
                $0.value = Double(drinkDaily.drinks[eDname.beer] ?? 0)
            }
            .onChange {
                let v = floor(Double($0.value!))
                self.drinkDaily.drinks[eDname.beer] = Int(v)
                self.stepValue = alc_step[eDname.beer]!
                self.dname = eDname.beer.rawValue
                self.update()
                
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.titleLabel.attributedText = setAttribute(title1: eDname.beer.ctitle (emoji: emojiSwitch), title2: self.prefix+alc_step[eDname.beer]!.decimalStrPlain+")")
            //    row.value = Double(self.drinkDaily.drinks[eDname.beer] ?? 0)
            }
            
            <<< StepperRow() {
                 $0.tag = "shocyuEntry"
                $0.cell.stepper.stepValue = alc_step[eDname.shocyu]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.shocyu]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+ml
                }
                $0.title = " "
                $0.value = Double(self.drinkDaily.drinks[eDname.shocyu] ?? 0)
            }
            .onChange {
                let v = floor(Double($0.value!))
                self.drinkDaily.drinks[eDname.shocyu] = Int(v)
                self.stepValue = alc_step[eDname.shocyu]!
                self.dname = eDname.shocyu.rawValue
                self.update()
                
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.titleLabel.attributedText = setAttribute(title1: eDname.shocyu.ctitle (emoji: emojiSwitch), title2: self.prefix+alc_step[eDname.shocyu]!.decimalStrPlain+")")
            //    row.value = Double(self.drinkDaily.drinks[eDname.shocyu] ?? 0)
            }
            
            <<< StepperRow() {
                 $0.tag = "whiskyEntry"
                $0.title = " "
                $0.cell.stepper.stepValue = alc_step[eDname.whisky]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.whisky]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+ml
                }
                $0.title = " "
                $0.value = Double(self.drinkDaily.drinks[eDname.whisky] ?? 0)
            }
                
            .onChange {
                let v = floor(Double($0.value!))
                self.drinkDaily.drinks[eDname.whisky] = Int(v)
                self.stepValue = alc_step[eDname.whisky]!
                self.dname = eDname.whisky.rawValue
                self.update()
            }
            .cellUpdate() {cell, row in
                cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.titleLabel.attributedText = setAttribute(title1: eDname.whisky.ctitle (emoji: emojiSwitch), title2: self.prefix+alc_step[eDname.whisky]!.decimalStrPlain+")")
             //   row.value = Double(self.drinkDaily.drinks[eDname.whisky] ?? 0)
            }
            
            <<< StepperRow(){
                 $0.tag = "canEntry"
                $0.cell.stepper.stepValue = alc_step[eDname.can]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.can]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+ml
                }
                $0.title = " "
                $0.value = Double(self.drinkDaily.drinks[eDname.can] ?? 0)
            }
            .onChange {
                let v = floor(Double($0.value!))
                self.drinkDaily.drinks[eDname.can] = Int(v)
                self.stepValue = alc_step[eDname.can]!
                self.dname = eDname.can.rawValue
                self.update()
            }
            .cellUpdate() {cell, row in
                    cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.titleLabel.attributedText = setAttribute(title1: eDname.can.ctitle (emoji: emojiSwitch), title2: self.prefix+alc_step[eDname.can]!.decimalStrPlain+")")
           //     row.value = Double(self.drinkDaily.drinks[eDname.can] ?? 0)
            }
            
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
         
            +++ Section("計算結果：合計の純アルコール量")
               <<< LabelRow () {
                            
                              $0.tag = "totalUnits"
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
            
           if let totalUnitRow = self.form.rowBy(tag: "totalUnits") {
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
