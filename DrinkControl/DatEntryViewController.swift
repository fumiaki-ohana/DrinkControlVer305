//
//  DatEntryViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/11/30.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import Eureka
//import AMPopTip
import Instructions

class DatEntryViewController: FormViewController,CoachMarksControllerDataSource,CoachMarksControllerDelegate {

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
           performSegue(withIdentifier: "showEvalViewSegue", sender: Any?.self)
       }
    
    
    @IBAction func pressNoDrinkBtn(_ sender: UIButton) {
        noDrinkDay()
    }
    
   
    
    // MARK:- Properties
    var stepValue:Double = 0.0
    var dname =  ""
    var drinkDaily = DrinkDailyRecord(dDate: Date(), drinks:[eDname:Int]())
    var flagChanged = false
    
    let maxLimit:Double = 9000
    let attributes: [NSAttributedString.Key : Any] = [
        .font : UIFont.systemFont(ofSize: 11.0), // 文字色
    ]
    
    func noDrinkDay() {
           
           let oldData = drinkDaily
           var zeroDrinkDay = drinkDaily
           for (key, _) in zeroDrinkDay.drinks {
                              zeroDrinkDay.drinks[key] = 0
                          }
           let data = setDataArray(rawdata: generateRawData(modifiedData: zeroDrinkDay))
           let noDrinkDaysFor7days = "過去７日間"+(excessOrNoDrinkLatest1week(array: data, calc: Ecalc.noDrink)).decimalStrPlain+"日"
           let noDrinkDaysFor30days = "過去30日間"+(excessOrNoDrinkLatest1week(array: data, calc: Ecalc.noDrink)).decimalStrPlain+"日"
           
           
           showAnimation(parentView:self.view, lottieJason: "782-check-mark-success",scale:80)
       
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
    // Coarch properties
    private var pointOfInterest:UIView!
    let coachMarksController = CoachMarksController()
    let hintStr  = ["さて、昨夜は🍷ワインを200cc飲みました。\n💡設定画面で、お酒の種類を変更できます。","🍺ビールを350cc、🍶日本酒も200cc飲みました。\n💡(±50)はワンクリックの増減量です。設定画面で自由に変更できます。","ワイン、ビール、日本酒に含まれている純アルコール量の合計が、自動的に計算されます！",
        "💡休肝日㊗️の時は、最初からここをタップ！",
         "☝️入力が終わったら、レビュー画面に移動します。"]
    
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
            point = noButton
        case 4:
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
     
   //MARK:- table
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
        setButtonProperties(button: noButton)
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
        
        /*
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //制約を追加 top:150 left:50 width:70 height:70
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 59.0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0.0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -119.0).isActive = true
        */
       
        tableView.frame =
                 CGRect(x: 10, y: 70,  width: self.view.bounds.size.width-20, height: (self.view.bounds.size.height - 170))
       
        view.theme_backgroundColor = GlobalPicker.barTintColor
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        navigationItem.title = "入力"
        
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
            
       //     Section(header:drinkDaily.dDate.mediumStr,footer:"(±設定中のワンクリック増減幅 cc)")
           Section(drinkDaily.dDate.mediumStr)
            <<< StepperRow() {
                $0.tag = "wineEntry"
                $0.cell.stepper.stepValue = alc_step[eDname.wine]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.wine]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"cc"
                }
                $0.title = eDname.wine.ctitle (emoji: emojiSwitch)+"(±"+alc_step[eDname.wine]!.decimalStrPlain+")"
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
                row.value = Double(self.drinkDaily.drinks[eDname.wine] ?? 0)
            }
            
            <<< StepperRow() {
                $0.tag = "nihonsyuEntry"
                $0.cell.stepper.stepValue = alc_step[eDname.nihonsyu]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.nihonsyu]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"cc"
                }
                $0.title = eDname.nihonsyu.ctitle (emoji: emojiSwitch)+"(±"+alc_step[eDname.nihonsyu]!.decimalStrPlain+")"
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
                row.value = Double(self.drinkDaily.drinks[eDname.nihonsyu] ?? 0)
            }
            
            <<< StepperRow() {
                 $0.tag = "beerEntry"
                $0.cell.stepper.stepValue = alc_step[eDname.beer]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.beer]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"cc"
                }
                $0.title = eDname.beer.ctitle (emoji: emojiSwitch)+"(±"+alc_step[eDname.beer]!.decimalStrPlain+")"
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
                row.value = Double(self.drinkDaily.drinks[eDname.beer] ?? 0)
            }
            
            <<< StepperRow() {
                 $0.tag = "shocyuEntry"
                $0.cell.stepper.stepValue = alc_step[eDname.shocyu]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.shocyu]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"cc"
                }
                $0.title = eDname.shocyu.ctitle (emoji: emojiSwitch)+"(±"+alc_step[eDname.shocyu]!.decimalStrPlain+")"
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
                row.value = Double(self.drinkDaily.drinks[eDname.shocyu] ?? 0)
            }
            
            <<< StepperRow() {
                 $0.tag = "whiskyEntry"
                $0.title = eDname.whisky.ctitle (emoji: emojiSwitch)+"(±"+alc_step[eDname.whisky]!.decimalStrPlain+")"
                $0.cell.stepper.stepValue = alc_step[eDname.whisky]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.whisky]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"cc"
                }
                //    $0.title = eDname.whisky.ctitle (emoji: emojiSwitch)+"("+alc_step[eDname.whisky]!.decimalStrPlain+")"
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
                row.value = Double(self.drinkDaily.drinks[eDname.whisky] ?? 0)
            }
            
            <<< StepperRow() {
                 $0.tag = "canEntry"
                $0.cell.stepper.stepValue = alc_step[eDname.can]!
                $0.cell.stepper.minimumValue = 0
                $0.cell.stepper.maximumValue = alc_limit[eDname.can]!
                $0.displayValueFor = {
                    guard let v = $0 else {return "0"}
                    return "\(Int(v))"+"cc"
                }
                $0.title = eDname.can.ctitle (emoji: emojiSwitch)+"(±"+alc_step[eDname.can]!.decimalStrPlain+")"
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
                row.value = Double(self.drinkDaily.drinks[eDname.can] ?? 0)
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
   /*
    func reflectRowValue() {
        
        for item in drinkDaily.drinks {
            let tagName = item.key.rawValue+"Entry"
            if let rowRef = self.form.rowBy(tag: tagName) {
                rowRef.updateCell()
                rowRef.reload()
            }
        }
        update()
       }
    */
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
