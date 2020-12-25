//
//  Tutor1ViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/05/04.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit

class Tutor1ViewController: UIViewController {

    override func viewDidLoad() {
        //super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
    //    super.setColorOnNavigationBar()
    //    view.theme_backgroundColor = GlobalPicker.backgroundColor
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
            MyThemes.before = MyThemes.current
            MyThemes.switchNight(isToNight: true)
        case .unspecified:
            break
        @unknown default:
            break
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
*/
}
