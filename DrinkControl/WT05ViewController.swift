//
//  WT05ViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/10/24.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

// このコントローラーは以前は使っていたのだが、disclaimerをHomeViewでAlert形式で表示するのを機に、取りやめた。
//ところが、ここでFlagReadMeV3をTrueにしていたため、それ以外の人は繰り返し行われる羽目に。

import UIKit
import Lottie

class WT05ViewController: UIViewController {

    let messageStr = "　アプリ「減酒くん」は、日々の飲酒記録を通じて節度ある飲酒習慣を実現することを目的にしていますが、飲酒自体は性別、年齢、健康状態、妊娠の有無、持病、フラッシング反応（赤くなる）などの体質等々、様々な要因で健康への影響力は異なり、大きな個人差があります。ご自身に適した設定を判断しアプリで計算・表示される数字等の意味と限界をご理解の上でご自身の責任でご利用ください。\n厚生労働省のお酒に関連するサイトにはお酒の影響について参考となる情報があります。\n当アプリの使用の結果や健康等への影響に対してアプリ製作者（株）OHANAは一切責任を負いません。"
    
    @IBOutlet weak var disclmaimer: UILabel!
    @IBOutlet weak var showWT: UIButton!
    
    @IBAction func pressMoveOnButton(_ sender: UIButton) {
        performSegue(withIdentifier: "moveToPageMain", sender: Any?.self)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        showAnimation()
        disclmaimer.text = messageStr
        
        setButtonProperties(button: showWT,rgbaStr:"#F99F48" )
        showWT.setTitle( "同意", for: .normal)
        flagReadMeV3 = true //同意を真
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAnimation() {
    
         let animationView = AnimationView(name: "3152-star-success")

         animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
         animationView.center = self.view.center
         animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0
        // animationView.contentMode = .scaleAspectFit
        animationView.contentMode = .scaleAspectFill

         view.addSubview(animationView)
         animationView.play { finished in
             if finished {
                 animationView.removeFromSuperview()
             }
         }
                         
     }
}
