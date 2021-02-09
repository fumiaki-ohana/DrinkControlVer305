//
//  Extension.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/11/09.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import Foundation
import UIKit
import SwiftTheme
import Lottie
import WhatsNewKit

//Extension
//MARK:- Debugging
/*
func printForDebugging(data:RawData) { //グラフのデバッグのために、データを出力する
    for item in data {
        let line = item.date.mediumStr+","+item.value.decimalStrPlain+","+item.rating
        print(line)
    }
}

func printForDebuggingAdjusted(data:ChartArray) {
    for item in data {
        let line = item.xval+","+item.yval.decimalStrPlain+","+item.rating
        print(line)
    }
}
*/
//MARK:-アニメ

func showAnimation(parentView:UIView, lottieJason:String, scale:CGFloat = 100, fullScreen:Bool = false) {

    let animationView = AnimationView(name: lottieJason)
    
    if fullScreen {animationView.frame = CGRect(x: 0, y: 0, width: parentView.bounds.width, height: parentView.bounds.height)}
    else {
        animationView.frame = CGRect(x: 0, y: 0, width: parentView.bounds.width*scale/100, height: parentView.bounds.width*scale/100)}
    
    animationView.center = parentView.center
    animationView.loopMode = .playOnce
    animationView.animationSpeed = 0.5
    // animationView.contentMode = .scaleAspectFit
    animationView.contentMode = .scaleAspectFill
    
    parentView.addSubview(animationView)
    animationView.play { finished in
        if finished {
            animationView.removeFromSuperview()
         }
     }
            
 }

func addAnimation(view:UIView) {
       UIView.animate(withDuration: 1.0, delay: 0.0, options: .autoreverse, animations: {
           view.center.y -= 20.0
       }){ _ in
           view.center.y += 20.0
       }
   }

//MARK: - ボタンの修飾
func setButtonProperties(button:UIButton, rgbaStr:String) {
          
        //  button.theme_backgroundColor = GlobalPicker.buttonTintColor3
          button.backgroundColor = UIColor(rgba: rgbaStr)
          button.layer.borderWidth = 0.1
          // 枠線の幅
    button.layer.borderColor = UIColor.blue.cgColor                            // 枠線の色
          button.layer.cornerRadius = 10.0                                             // 角丸のサイズ
         // button.theme_setTitleColor(GlobalPicker.buttonTItleColor3, forState: .normal)
          button.setTitleColor(.white, for: .normal)
      }

func setButtonProperties(button:UIButton,backColor:ThemeColorPicker=GlobalPicker.buttonTintColor3,titleColor:ThemeColorPicker=GlobalPicker.buttonTitleColor,titleColorOnDark:ThemeColorPicker=GlobalPicker.buttonTintColor2) {
    
    button.theme_backgroundColor = backColor
    button.layer.cornerRadius = 10.0
    button.layer.borderWidth = 1.0
    // 枠線の幅
    button.layer.borderColor = UIColor.black.cgColor                            // 枠線の色
    // 角丸のサイズ
    switch MyThemes.current {
    case .dark :
        button.theme_setTitleColor(titleColorOnDark, forState:.normal)
        button.layer.borderColor = UIColor.white.cgColor
    default:
        button.theme_setTitleColor(titleColor, forState:.normal)
        button.layer.borderColor = UIColor.black.cgColor
    }
}

// MARK:- Extensions
extension Array where Element: Equatable {
    typealias E = Element

    func subtracting(_ other: [E]) -> [E] {
        return self.compactMap { element in
            if (other.filter { $0 == element }).count == 0 {
                return element
            } else {
                return nil
            }
        }
    }

    mutating func subtract(_ other: [E]) {
        self = subtracting(other)
    }
}

extension UIColor {
    convenience init?(hexRGBA: String?) {
        guard let rgba = hexRGBA, let val = Int(rgba.replacingOccurrences(of: "#", with: ""), radix: 16) else {
            return nil
        }
        self.init(red: CGFloat((val >> 24) & 0xff) / 255.0, green: CGFloat((val >> 16) & 0xff) / 255.0, blue: CGFloat((val >> 8) & 0xff) / 255.0, alpha: CGFloat(val & 0xff) / 255.0)
    }
    convenience init?(hexRGB: String?) {
        guard let rgb = hexRGB else {
            return nil
        }
        self.init(hexRGBA: rgb + "ff") // Add alpha = 1.0
    }
}

extension Int {
    // Intを三桁ごとにカンマが入ったStringへ
    var decimalStr: String {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.groupingSeparator = ","
        decimalFormatter.groupingSize = 3
        return decimalFormatter.string(from: self as NSNumber)! + "\u{33C4}" // ㏄
    }
    var decimalStrPlain: String {
           let decimalFormatter = NumberFormatter()
           decimalFormatter.numberStyle = NumberFormatter.Style.decimal
           decimalFormatter.groupingSeparator = ","
           decimalFormatter.groupingSize = 3
           return decimalFormatter.string(from: self as NSNumber)! 
       }
}

extension String {
    
    func SubString(from f:Int, lenght n:Int) -> String? {
        guard self.count >= f + n else {return ""}
        let begin = self.index(self.startIndex, offsetBy:f)
        let upto = self.index(begin, offsetBy:n)
        return String(self[begin..<upto])
    }
}

func setAttribute(title1:String, title2:String ) -> NSAttributedString {
    let stringAttributes1: [NSAttributedString.Key : Any] = [
        .font : UIFont.systemFont(ofSize: 18.0)
    ]
    let string1 = NSAttributedString(string: title1, attributes: stringAttributes1)

    let stringAttributes2: [NSAttributedString.Key : Any] = [
       // .foregroundColor : UIColor.red,
        .font : UIFont.boldSystemFont(ofSize: 12.0)
    ]
    let string2 = NSAttributedString(string: title2, attributes: stringAttributes2)
    
    let mutableAttributedString = NSMutableAttributedString()
    mutableAttributedString.append(string1)
    mutableAttributedString.append(string2)

    return mutableAttributedString
}


extension Double {
    var decimalStrDay: String {
        let decimalFormatter = "%.0f"
    //    let decimalFormatter = "%4d"
        return String(format:decimalFormatter,self)+"日"
    }
    
    
    var decimalStrPlain: String {
        let decimalFormatter = "%.0f"
    //    let decimalFormatter = "%4d"
        return String(format:decimalFormatter,self)
    }
    
    var decimalStrPlain1: String {
        let decimalFormatter = "%.1f"
    //    let decimalFormatter = "%4d"
        return String(format:decimalFormatter,self)
    }
    
    var decimalStr: String {
        let decimalFormatter = "%.0f"
    //    let decimalFormatter = "%4d"
        return String(format:decimalFormatter,self)+"𝐠"
    }
    
    var decimalStrCC: String {
        let decimalFormatter = "%.0f"
    //    let decimalFormatter = "%4d"
        return String(format:decimalFormatter,self)+ml
    }
    
    
    var decimalStrFloor: String {
        let decimalFormatter = "%.0f"
        return String(format:decimalFormatter,floor(self))+"𝐠"
    }
    //    パーセント
    var percentStr: String {
        let decimalFormatter = "%.1f"
        return String(format:decimalFormatter,floor(self)) + "\u{FE6A}" //%
    }
    //    ブロック
    var returnBlock: String {
        let blockChar = "\u{1F377}"
        let times = Int( (self).rounded(.toNearestOrEven) ) > 14 ? 14 : Int( (self).rounded(.toNearestOrEven) )
        return  String(repeating:blockChar, count:times)
    }
    //    カレンダーの上のドット🍷
    var dots: Int{
        get {
            if targetUnit == Double(0) {return 3}
            else {
                let n = Int( (self / targetUnit).rounded(.toNearestOrAwayFromZero) ) > 3 ? 3 : Int( (self / targetUnit).rounded(.toNearestOrAwayFromZero) )
                return n }
        }
    }
    
}
extension String{
    var dateConverted: Date {
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        return f.date(from: self)!
    }
}

extension Date {
    var mediumStr: String {
        let f = DateFormatter()
        f.timeStyle = .none
        f.dateStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        return f.string(from: (self as Date))}
    
    var shortStr: String {
        let f = DateFormatter()
      //  f.timeStyle = .none
      //  f.dateStyle = .short
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "MM/dd"
        let date = f.string(from: (self as Date))
        return date }
    
    var toHashStr: String {
        let f = DateFormatter()
        
        f.timeStyle = .none
        f.dateStyle = .short
        f.locale = Locale(identifier: "ja_JP")
        return f.string(from: self)}
    
    var timeStr: String {
        let f = DateFormatter()
        
        f.timeStyle = .full
        f.dateStyle = .none
        f.locale = Locale(identifier: "ja_JP")
        return f.string(from: self)
    }
        
        
    }

extension Date {
    
    init(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil) {
        self.init()
        if let value = year   { self.year   = value }
        if let value = month  { self.month  = value }
        if let value = day    { self.day    = value }
        if let value = hour   { self.hour   = value }
        if let value = minute { self.minute = value }
        if let value = second { self.second = value }
    }
    
    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            setComponentValue(newValue, for: .year)
        }
    }
    
    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            setComponentValue(newValue, for: .month)
        }
    }
    
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            setComponentValue(newValue, for: .day)
        }
    }
    
    var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            setComponentValue(newValue, for: .hour)
        }
    }
    
    var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            setComponentValue(newValue, for: .minute)
        }
    }
    
    var second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            setComponentValue(newValue, for: .second)
        }
    }
    
    private mutating func setComponentValue(_ value: Int, for component: Calendar.Component) {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.setValue(value, for: component)
        if let date = calendar.date(from: components) {
            self = date
        }
    }
    
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .japan
        calendar.locale   = .japan
        return calendar
    }
}

extension TimeZone {
    
    static let japan = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    
    static let japan = Locale(identifier: "ja_JP")
}

extension UIAlertController {
    
    func setMessageAlignment(_ alignment : NSTextAlignment) {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = alignment
        
        let messageText = NSMutableAttributedString(
            string: self.message ?? "",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        )
        self.setValue(messageText, forKey: "attributedMessage")
    }
    
    
    func pruneNegativeWidthConstraints() { // https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
    
    static func noButtonAlert(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    }
    
    
    static func okPlusAlert(title: String?,
                        message: String?,astyle:Style = .actionSheet,
                        okstr:String = OKstr,
                        okHandler: ((UIAlertAction) -> Void)? = nil,
                        cancelstr:String = "キャンセル",
                        cancelHandler: ((UIAlertAction) -> Void)? = nil)-> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: astyle)
        alert.setMessageAlignment(.left)
        let defaultAction: UIAlertAction = UIAlertAction(title: okstr, style: .default, handler: okHandler)
        let cancelAction:UIAlertAction = UIAlertAction(title: cancelstr, style: .cancel, handler: cancelHandler)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        alert.pruneNegativeWidthConstraints()
        
        return alert
    }
    
    static func okAlert(alignment:NSTextAlignment = .center, title: String?,
                        message: String?,astyle:Style = .actionSheet,okstr:String = OKstr,
                        okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: astyle)
        alert.setMessageAlignment(alignment)
        alert.addAction(.init(title: okstr, style: .default, handler: okHandler))
        alert.pruneNegativeWidthConstraints()
        
        return alert
    }
    /*
     static func okAlertAlt(title: String?,
     message: String?,
     okStr: String?,
     okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
     let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
     alert.addAction(.init(title: okStr, style: .default, handler: okHandler))
     return alert
     }
     */
}

extension UIViewController {
    func present(_ alert: UIAlertController, completion: (() -> Void)? = nil) {
        present(alert, animated: true, completion: completion)
    }
    
}

func showWhatsNewPlus(titl:String,compButtonTitle:String,detailButtonTitle: String, webStr:String,  msg:[(title:String,subtitle:String,icon:String)]) -> WhatsNewViewController{
    // Initialize default Configuration
    
    let completionButton = WhatsNewViewController.CompletionButton(
        title: compButtonTitle,
        action: .dismiss
    )
    
    let detailButton = WhatsNewViewController.DetailButton(
        title: detailButtonTitle,
        action: .website(url: webStr)
    )
    
    let configuration = WhatsNewViewController.Configuration(
        theme: .default,
        detailButton: detailButton,
        completionButton: completionButton
        )
            /*
            .init(

            // Completion Button Title
            title: compButtonTitle,
            // Completion Button Action
            action: .dismiss
        )*/
    
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
    
    return whatsNewViewController
}

func showWhatsNew(titl:String,compButtonTitle:String,detailButtonTitle: String? = nil, webStr:String? = nil,  msg:[(title:String,subtitle:String,icon:String)]) -> WhatsNewViewController{
    
    // Initialize default Configuration
    
    let configuration = WhatsNewViewController.Configuration(
        theme: .default,
        completionButton: .init(

            // Completion Button Title
            title: compButtonTitle,
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
    
    return whatsNewViewController
}
/*
 
 　　使い方
 // OKボタンのみのAlertを表示
 present(.okAlert(title: nil, message: "グループを作成しました"))
 
 // OKボタンのついたErrorを表示するAlertを表示
 present(.errorAlert(error:　NSError(domain: "hoge", code: 0, userInfo: nil)) { _ in
 // ユーザが閉じたあとに行う処理を記述
 })
 
 // UITextFieldつきのAlertを表示
 present(.fieldAlert(
 title: "グループの作成", message: "グループ名を入力してください", placeholder: "グループ名",
 handler: { [weak self] (inputText) in
 // 入力されたテキストを使う処理を記述
 }))
 
 // 0.3秒後に自動で閉じる
 present(.noButtonAlert(title: "✅", message: "保存しました"), 0.3) { [weak self] in
 // ユーザが閉じたあとに行う処理を記述
 }
 */
