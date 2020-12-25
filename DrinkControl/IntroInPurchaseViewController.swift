//
//  IntroInPurchaseViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/10/13.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit


class IntroInPurchaseViewController: UIViewController {

    @IBOutlet weak var L1: UILabel!
    @IBOutlet weak var L2: UILabel!
    @IBOutlet weak var L3: UILabel!
    @IBOutlet weak var L4: UILabel!
    
    @IBOutlet weak var purchaseButton: UIButton!
    @IBAction func pressCancel(_ sender: UIBarButtonItem) {
        let index = navigationController!.viewControllers.count - 2
        navigationController?.popToViewController(navigationController!.viewControllers[index], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        switch MyThemes.current {
        case .dark : L1.textColor = .white
        L2.textColor = .white
        L3.textColor = . white
        L4.textColor = . white
        
        default:  break
        }
        
        setButtonProperties(button: purchaseButton)
        view.theme_backgroundColor = GlobalPicker.backgroundColor
    }
       
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
