//
//  WT01ViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/07/17.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import WhatsNewKit

class WT01ViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    let titleStr = "続く"
    //MARK:- What's New
    
    func showWhatsNew() {
        let titl = "減酒くんの機能"
        let msg:[(title:String,subtitle:String,icon:String)] =
            [("習慣づけをお手伝い","『一括入力→目標と比べる→反省→飲む前に読み返す。』記録だけではお酒は減りません！","good"),
             ("お酒を見える化","お酒の種類に関わらず、純アルコール量に換算。休肝日や飲み過ぎ日もグラフ表示","ChartBarIcon"),("かんたん入力","ワンタップで入力する量を自由に設定。入力の指定時間を通知","dash"),
             ("自分好みに変える","豊富なカスタマイズ機能。よく飲むお酒を選び、アルコール濃度も個別調整。7種類のアプリ色テーマ・・ほんの一例です。","Paint")]
        
        // Initialize default Configuration
        
        let configuration = WhatsNewViewController.Configuration(
            theme: .default,
            completionButton: .init(
                // Completion Button Title
                title: "続ける",
                // Completion Button Action
                action: .dismiss)
            )
        
        // Initialize WhatsNew
        let whatsNew = WhatsNew(
            // The Title
            title: titl,
            // The features you want to showcase
            items: [
                WhatsNew.Item(
                    title: msg[0].title,
                    subtitle: msg[0].subtitle,
                    image: UIImage(named: msg[0].icon)
                ),
                WhatsNew.Item(
                    title:  msg[1].title,
                    subtitle: msg[1].subtitle,
                    image: UIImage(named: msg[1].icon)
                ),
                WhatsNew.Item(
                    title:  msg[2].title,
                    subtitle: msg[2].subtitle,
                    image: UIImage(named: msg[2].icon)
                ),
                WhatsNew.Item(
                    title:  msg[3].title,
                    subtitle: msg[3].subtitle,
                    image: UIImage(named: msg[3].icon)
                )
            ]
        )

        // Initialize WhatsNewViewController with WhatsNew
        let whatsNewViewController = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: configuration
        )

        // Present it 🤩
        self.present(whatsNewViewController, animated: true)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        showWhatsNew()
    }
    
    //MARK:- View Rotation
    override func viewDidLoad() {
        self.overrideUserInterfaceStyle = .light
        super.viewDidLoad()
       
        setButtonProperties(button: nextButton,rgbaStr:"#F99F48" )
        nextButton.setTitle( titleStr, for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
