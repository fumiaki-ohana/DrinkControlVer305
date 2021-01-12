//
//  WT02ViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/10/23.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import WhatsNewKit

class WT02ViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    
    let titleStr = "続く"
    let buttonTitle = "目標を設定してみる"
    
    //MARK:- What's New
   /*
    func showWhatsNew() {
        
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
 */
  
    // MARK:- View Rotation
    override func viewDidAppear(_ animated: Bool) {
        let titl = "減酒くんについて"
        let compButtonTitle = "続ける"
        let detailButtonTitle = "参考：厚生労働省e-ヘルスネット"
        let detailWebSite = "https://www.e-healthnet.mhlw.go.jp/information/alcohol"
        let msg:[(title:String,subtitle:String,icon:String)] =
            [("記録するだけでは減りません！","一括入力→目標と比べる→反省→飲む前に読み返す。習慣づけをお手伝い","good"),
             ("お酒を見える化","飲んだお酒を純アルコール量に換算。休肝日や飲み過ぎ日もグラフ表示","ChartBarIcon"),("かんたん入力","ワンタップで好みの入力量を設定。休肝日は一発入力","dash"),
             ("自分好みに変える","お酒の変更、アルコール濃度も個別調整。7種類のアプリ色テーマETC・・カスタマイズ可能。","Paint")]
        let item = showWhatsNewPlus(titl: titl, compButtonTitle: compButtonTitle, detailButtonTitle:detailButtonTitle,webStr:detailWebSite, msg: msg)
        present(item,animated: true)
    }
     
    override func viewDidLoad() {
        self.overrideUserInterfaceStyle = .light
        super.viewDidLoad()
        setButtonProperties(button: nextButton,rgbaStr:"#F99F48" )
        nextButton.setTitle( buttonTitle, for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
