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
    var stepValue:Double = 0.0
    var dname =  ""
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
            let msg = "全部0ccにリセットします。"+"\n"+"休肝日は:"+"\n"+noDrinkDaysFor7days+"\n"+noDrinkDaysFor30days
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        viewBackGround.theme_backgroundColor = GlobalPicker.backgroundColor
    //    setButtonProperties(button: noButton)
        setButtonProperties(button:moveToReview,backColor:GlobalPicker.buttonTintColor2,titleColorOnDark:GlobalPicker.buttonTintColor3)
        
        if shouldShowCoarch {
            moveToReview.isEnabled = true
        }
        else{
            moveToReview.isEnabled = (drinkDaily.evaluation == eval.no.rawValue) ? false:true
        }

     //   doneBtn.isEnabled = false
        
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
       
     //   tableView.frame =
     //            CGRect(x: 10, y: 50,  width: self.view.bounds.size.width-20, height: // (self.view.bounds.size.height - 160))
        
        view.theme_backgroundColor = GlobalPicker.barTintColor
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_sectionIndexBackgroundColor = GlobalPicker.groupBackground
        navigationItem.title = "クイック入力"
        let sectionTitle = drinkDaily.dDate.mediumStr+" -グラスなどの杯/本数で入力"
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
               
               //MARK:- quick entry section

               form = Section(sectionTitle)
                   
               <<< StepperRow() {
                   $0.tag = "wineEntry1"
                   $0.cell.stepper.stepValue = 0.5
                   $0.cell.stepper.minimumValue = 0.0
                   $0.cell.stepper.maximumValue = 10.0
                   $0.displayValueFor = {
                       guard let v = $0 else {return "0"}
                       return v.decimalStrPlain1
                   }
                $0.title = eDname.wine.rawValue
                $0.value = eDname.wine.Amount2Glasses(damount: self.drinkDaily.drinks[eDname.wine] ?? 0)
               }
               .onChange {
                   let v = $0.value!
                   self.drinkDaily.drinks[eDname.wine] = eDname.wine.Glasses2Amount(numGlass: v)
                self.dname = eDname.wine.rawValue
                   self.update()
               }
               
               .cellUpdate() {cell, row in
                   cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                   cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                   cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                   cell.titleLabel.attributedText = setAttribute(title1: eDname.wine.ctitle (emoji: emojiSwitch)+" ", title2: alc_quick[eDname.wine]!.decimalStrCC)
               }
       
               <<< StepperRow() {
                 $0.tag = "nihonsyuEntry1"
                 $0.cell.stepper.stepValue = 0.1
                 $0.cell.stepper.minimumValue = 0.0
                 $0.cell.stepper.maximumValue = 10.0
                 $0.displayValueFor = {
                     guard let v = $0 else {return "0"}
                     return v.decimalStrPlain1
                 }
                 $0.title = eDname.nihonsyu.rawValue
                 $0.value = eDname.nihonsyu.Amount2Glasses(damount: self.drinkDaily.drinks[eDname.nihonsyu] ?? 0)
               }
               .onChange {
                 let v = $0.value!
                 self.drinkDaily.drinks[eDname.nihonsyu] = eDname.nihonsyu.Glasses2Amount(numGlass: v)
                 self.dname = eDname.nihonsyu.rawValue
                 self.update()
               }
               .cellUpdate() {cell, row in
                   cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                   cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                   cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                cell.titleLabel.attributedText = setAttribute(title1: eDname.nihonsyu.ctitle (emoji: emojiSwitch)+" ", title2: alc_quick[eDname.nihonsyu]!.decimalStrCC)
         //           row.value = Double(self.drinkDaily.drinks[eDname.nihonsyu] ?? 0)
               }
               
                <<< StepperRow() {
                  $0.tag = "beerEntry1"
                  $0.cell.stepper.stepValue = 0.1
                  $0.cell.stepper.minimumValue = 0.0
                  $0.cell.stepper.maximumValue = 10.0
                  $0.displayValueFor = {
                      guard let v = $0 else {return "0"}
                      return v.decimalStrPlain1
                  }
                  $0.title = eDname.beer.rawValue
                  $0.value = eDname.beer.Amount2Glasses(damount: self.drinkDaily.drinks[eDname.beer] ?? 0)
                }
                .onChange {
                  let v = $0.value!
                  self.drinkDaily.drinks[eDname.beer] = eDname.beer.Glasses2Amount(numGlass: v)
            //      print(self.drinkDaily.drinks)
                  self.dname = eDname.beer.rawValue
                  self.update()
                }
                .cellUpdate() {cell, row in
                    cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.titleLabel.attributedText = setAttribute(title1: eDname.beer.ctitle (emoji: emojiSwitch)+" ", title2: alc_quick[eDname.beer]!.decimalStrCC)
              //      row.value = Double(self.drinkDaily.drinks[eDname.beer] ?? 0)
                }
               
                <<< StepperRow() {
                  $0.tag = "shocyuEntry1"
                  $0.cell.stepper.stepValue = 0.1
                  $0.cell.stepper.minimumValue = 0.0
                  $0.cell.stepper.maximumValue = 10.0
                  $0.displayValueFor = {
                      guard let v = $0 else {return "0"}
                      return v.decimalStrPlain1
                  }
                  $0.title = eDname.shocyu.rawValue
                  $0.value = eDname.shocyu.Amount2Glasses(damount: self.drinkDaily.drinks[eDname.shocyu] ?? 0)
                }
                .onChange {
                  let v = $0.value!
                  self.drinkDaily.drinks[eDname.shocyu] = eDname.shocyu.Glasses2Amount(numGlass: v)
                  self.dname = eDname.shocyu.rawValue
                  self.update()
                }
                .cellUpdate() {cell, row in
                    cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.titleLabel.attributedText = setAttribute(title1: eDname.shocyu.ctitle (emoji: emojiSwitch)+" ", title2: alc_quick[eDname.shocyu]!.decimalStrCC)
               //     row.value = Double(self.drinkDaily.drinks[eDname.nihonsyu] ?? 0)
                }
                
               
                <<< StepperRow() {
                  $0.tag = "whiskyEntry1"
                  $0.cell.stepper.stepValue = 0.1
                  $0.cell.stepper.minimumValue = 0.0
                  $0.cell.stepper.maximumValue = 10.0
                  $0.displayValueFor = {
                      guard let v = $0 else {return "0"}
                      return v.decimalStrPlain1
                  }
                  $0.title = eDname.whisky.rawValue
                  $0.value = eDname.whisky.Amount2Glasses(damount: self.drinkDaily.drinks[eDname.whisky] ?? 0)
                }
                .onChange {
                  let v = $0.value!
                  self.drinkDaily.drinks[eDname.whisky] = eDname.whisky.Glasses2Amount(numGlass: v)
                  self.dname = eDname.whisky.rawValue
                  self.update()
                }
                .cellUpdate() {cell, row in
                    cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                   cell.titleLabel.attributedText = setAttribute(title1: eDname.whisky.ctitle (emoji: emojiSwitch)+" ", title2: alc_quick[eDname.whisky]!.decimalStrCC)
                }
                
                <<< StepperRow() {
                  $0.tag = "canEntry1"
                  $0.cell.stepper.stepValue = 0.1
                  $0.cell.stepper.minimumValue = 0.0
                  $0.cell.stepper.maximumValue = 10.0
                  $0.displayValueFor = {
                      guard let v = $0 else {return "0"}
                      return v.decimalStrPlain1
                  }
                  $0.title = eDname.can.rawValue
                  $0.value = eDname.can.Amount2Glasses(damount: self.drinkDaily.drinks[eDname.can] ?? 0)
                }
                .onChange {
                  let v = $0.value!
                  self.drinkDaily.drinks[eDname.can] = Int(round(v * alc_quick[eDname.can]!))
                  self.dname = eDname.can.rawValue
                  self.update()
                }
                .cellUpdate() {cell, row in
                    cell.textLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.detailTextLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.valueLabel?.theme_textColor = GlobalPicker.labelTextColor
                    cell.titleLabel.attributedText = setAttribute(title1: eDname.can.ctitle (emoji: emojiSwitch)+" ", title2: alc_quick[eDname.can]!.decimalStrCC)
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
