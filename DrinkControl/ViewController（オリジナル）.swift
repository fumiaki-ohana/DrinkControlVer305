//
//  ViewController.swift
//  BWWalkthroughExample
//
//  Created by Yari D'areglia on 17/09/14.

import UIKit
import BWWalkthrough
import Lottie

class ViewController: UIViewController, BWWalkthroughViewControllerDelegate {
        
    @IBOutlet weak var showStartUpSwitch: UISwitch!
    @IBOutlet weak var introButton: UIButton!
 //   @IBOutlet weak var tutorButton: UIButton!
 //   @IBOutlet weak var recommendButton: UIButton!
    
    @IBOutlet weak var moveToHomeButton: UIButton!
    @IBAction func showStartUp(_ sender: UISwitch) {
        shouldShowWalkThrough = sender.isOn
    }
    
    override func viewDidLoad() {
        start_jobs()
    }
    
    func start_jobs () {
        MyThemes.switchTo(theme:.walkThrough)
           super.viewDidLoad()
        // showAnimation()
        //   showStartUpSwitch.isOn = shouldShowWalkThrough
    }
    
    override func viewWillAppear(_ animated: Bool) {
       show_remainTimes()
    }
    
    func show_remainTimes() {
        if !unlocked,(remainSaveTime <= haircutForNotice) {
                          self.noticeTop("保存できる回数は残り"+String(remainSaveTime)+"回です。",autoClear:false)
                      }
                      else {
                          self.clearAllNotice()
                      }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let messageStr = "減酒くんは飲酒習慣改善お手伝いアプリです。\n但し飲酒の影響には大きな個人差があるため、ご自身の判断の上での設定と利用をお願いします。\n使用の結果や影響に対して制作者は責任を負いません。"
        if !flagReadMe {
            present(.okAlertAlt(title: "初めにお読みください", message: messageStr, okStr: "了解して進む"))}
            flagReadMe = true
            setButtonProperties(button: introButton, color: 3)
     //     setButtonProperties(button: tutorButton, color: 1)
            setButtonProperties(button: moveToHomeButton, color: 2)
         
    }
    
    func setButtonProperties(button:UIButton, color:Int) {
        
        switch color {
        case 1 :button.theme_backgroundColor = GlobalPicker.buttonTintColor1
        case 2:button.theme_backgroundColor = GlobalPicker.buttonTintColor2
        case 3:button.theme_backgroundColor = GlobalPicker.buttonTintColor3
        default:break
        }
        
        button.layer.borderWidth = 0.1                                              // 枠線の幅
        button.layer.borderColor = UIColor.white.cgColor                            // 枠線の色
        button.layer.cornerRadius = 10.0                                             // 角丸のサイズ
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backToMain(_ sender: UIButton) {
           backToMainSub()
    
    }
    func backToMainSub () {
        dismiss(animated: true)
        MyThemes.restoreLastTheme()
    }
    /*
    @IBAction func presentTutor(_ sender: UIButton) {
        presentTutorSub()
    }
    
    func presentTutorSub() {
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewController(withIdentifier: "walk8")
        let page_one = stb.instantiateViewController(withIdentifier: "walk9")
        let page_two = stb.instantiateViewController(withIdentifier: "walk10")
        let page_three = stb.instantiateViewController(withIdentifier: "walk11")
        let page_four = stb.instantiateViewController(withIdentifier: "walk12")
        let page_five = stb.instantiateViewController(withIdentifier: "walk13")
        let page_six = stb.instantiateViewController(withIdentifier: "walk14")
        let page_seven = stb.instantiateViewController(withIdentifier: "walk15")
        let page_eight = stb.instantiateViewController(withIdentifier: "walk16")
        let page_nine = stb.instantiateViewController(withIdentifier: "walk17")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_zero)
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_four)
        walkthrough.add(viewController:page_five)
        walkthrough.add(viewController:page_six)
        walkthrough.add(viewController:page_seven)
        walkthrough.add(viewController:page_eight)
        walkthrough.add(viewController:page_nine)
        
        
        self.present(walkthrough, animated: true, completion: nil)
    }
   */
    @IBAction func presentFunction(_ sender: UIButton) {
        presentFunctionSub()
           }
    
    func presentFunctionSub() {
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let helpFunction = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewController(withIdentifier: "walk0")
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        let page_four = stb.instantiateViewController(withIdentifier: "walk4")
        let page_five = stb.instantiateViewController(withIdentifier: "walk5")
   
         
        // Attach the pages to the master
        helpFunction.delegate = self
        helpFunction.add(viewController:page_zero)
        helpFunction.add(viewController:page_one)
        helpFunction.add(viewController:page_two)
        helpFunction.add(viewController:page_three)
        helpFunction.add(viewController:page_four)
        helpFunction.add(viewController:page_five)
 
        
        
        self.present(helpFunction, animated: true, completion: nil)
    }
   
    /*
    @IBAction func presentRecommend(_ sender: UIButton) {
        presentRecommendSub()
    }
    func presentRecommendSub() {
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
           let helpFunction = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
           let page_zero = stb.instantiateViewController(withIdentifier: "walk18")
           
           // Attach the pages to the master
           helpFunction.delegate = self
           helpFunction.add(viewController:page_zero)
           self.present(helpFunction, animated: true, completion: nil)
    }
    */
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

