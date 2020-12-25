//
//  testViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/12/23.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import WhatsNewKit

class testViewController: UIViewController {

    func showWhatsNew() {
        let titl = "Ver."+appVersion!+"の新機能"
        let msg:[(title:String,subtitle:String,icon:String)] = [("ホーム画面を一新しました。","過去の飲酒データをタップしても、編集画面に飛べます。","wine"),
                                                    ("通知機能","指定時刻に、飲酒の反省を読むよう促します。（設定＞通知の設定）","bell"),("休肝日の入力","タップするだけで飲酒ゼロを入力します。","dash"),
                                                    ("その他","追加・編集できるお酒の種類を増やしました。他にも多くの改良があります。","beer")]
        // Initialize default Configuration
        
        let configuration = WhatsNewViewController.Configuration(
            theme: .default,
            completionButton: .init(
                // Completion Button Title
                title: "使ってみる",
                // Completion Button Action
                action: .dismiss
            )
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
    override func viewDidLoad() {
       
        
        super.viewDidLoad()

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

}
