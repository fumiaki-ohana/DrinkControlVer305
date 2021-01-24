//
//  IntroInPurchaseViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/10/13.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit

class IntroInPurchaseViewController: UIViewController {
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light //強制的にテーマを切り替える
        MyThemes.switchTo(theme: .norm)
        setColor()

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
    
    func setColor() {
        setButtonProperties(button: purchaseButton)
     //   view.theme_backgroundColor = GlobalPicker.backgroundColor
    }
/*
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
  */

}
