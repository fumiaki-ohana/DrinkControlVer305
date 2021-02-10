//
//  WT02ViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/10/23.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit
import WhatsNewKit
import SnapKit

class WT02ViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func showWeb(_ sender: UIButton) {
        // url = 遷移したいサイトのURLをString型で指定
        let url = NSURL(string: "https://www.e-healthnet.mhlw.go.jp/information/alcohol/a-03-002.html")

        if UIApplication.shared.canOpenURL(url! as URL) {
          UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    let titleStr = "続く"
    let buttonTitle = "目標を設定してみる"
  
    // MARK:- View Rotation
    override func viewDidAppear(_ animated: Bool) {
        let titl = "減酒くん"
        let compButtonTitle = "続ける"
        let detailButtonTitle = "開発参考：厚生労働省e-ヘルスネットへ"
        let detailWebSite = "https://www.e-healthnet.mhlw.go.jp/information/alcohol"
        let msg:[(title:String,subtitle:String,icon:String)] =
            [("記録だけでは減らない！","毎朝反省→飲む前に読み返す。通知機能で習慣づけ。","good"),
             ("飲んだお酒を見える化","純アルコール量換算、休肝・飲み過ぎ日","ChartBarIcon"),("かんたん入力","量㎖とグラス数どちらでも入力。休肝日は一発入力","dash"),
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
