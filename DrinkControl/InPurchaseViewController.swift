//
//  InPurchaseViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/12/11.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class InPurchaseViewController: UIViewController {
    
    let appBundleId = "com.ohanainc.drinkcontrol.unlock"
    var nonConsumableIsAtomic = true
    
    @IBOutlet weak var localPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var unlockStatus: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var L1: UILabel!
    @IBOutlet weak var L2: UILabel!
    @IBOutlet weak var L3: UILabel!
   
    // MARK: IB actions
    
    @IBAction func pressCancel(_ sender: UIButton) {
    /*
       let index = navigationController!.viewControllers.count - 2
       navigationController?.popToViewController(navigationController!.viewControllers[index], animated: true)
    */
        self.navigationController?.popToRootViewController(animated: true)
      // self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func nonConsumablePurchase() { // 購入
        //    purchase(.nonConsumablePurchase, atomically: nonConsumableIsAtomic)
        purchase(atomically: nonConsumableIsAtomic)
    }
    
    @IBAction func restorePurchases() { // リストア
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for purchase in results.restoredPurchases {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                } else if purchase.needsFinishTransaction {
                    // Deliver content from server, then:
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
            }
            self.showAlert(self.alertForRestorePurchases(results))
        }
    }
    
    // MARK: View rotation
    
    override func viewDidAppear(_ animated: Bool) {
        let titl = "App内課金の説明"
        let compButtonTitle = "App内購入画面へ進む"
        let msg:[(title:String,subtitle:String,icon:String)] =
            [("データの保存制限（２回）を解除","購入画面でApp内課金を購入すると、制限を解除します。","Buy"),
             ("まだ課金はされません。","購入画面に進むだけでは、課金はされません。購入ボタンを押すまでは中止できます。","NotBuy"),("中止するためには","購入画面で、「中止／戻る」を選んでください。","Cancel"),
             ("既に購入済みの方へ","購入画面で【復元する】をタッチすると保存制限が解除されます。","Restore")]
        let item = showWhatsNew(titl: titl, compButtonTitle: compButtonTitle, msg: msg)
        present(item,animated: true)
    }
   
    override func viewDidLoad() {
        //        初期設定
        self.navigationItem.hidesBackButton = true
        
        let title = "App内課金"
        productName.text = ""
        localPrice.text = ""
        productDesc.text = ""
        
        checkUnlockStatus()
        
        setColor()
        
        navigationItem.title = title
        getInfo()// プロダクト情報
        verifyPurchase() // 購入状況のチェック
    }
     
    func checkUnlockStatus() {
        let msg:String = unlocked ? "購入済み。ロック解除されています。": "保存できる回数は残り"+String(remainSaveTime)+"回です。\n購入をご検討ください。"
        purchaseButton.isEnabled = !unlocked
        restoreButton.isEnabled = !unlocked
        unlockStatus.text = msg
    }
    
    // Mark:- プロダクト情報
    
    func getInfo() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([appBundleId]) { result in
            //      SwiftyStoreKit.retrieveProductsInfo([appBundleId + "." + purchase.rawValue]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            self.showAlert(self.alertForProductRetrievalInfo(result))
        }
    }
    
    // Mark:- レシートをチェック
    func verifyReceiptMain() {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            self.showAlert(self.alertForVerifyReceipt(result))
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "your-shared-secret")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    // Mark:- 購入をチェック
    
    func verifyPurchase()  {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                
                //      let productId = self.appBundleId + "." + purchase.rawValue
                let productId = self.appBundleId
                /*
                 switch purchase {
                 case .autoRenewableWeekly, .autoRenewableMonthly, .autoRenewableYearly:
                 let purchaseResult = SwiftyStoreKit.verifySubscription(
                 ofType: .autoRenewable,
                 productId: productId,
                 inReceipt: receipt)
                 self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: [productId]))
                 case .nonRenewingPurchase:
                 let purchaseResult = SwiftyStoreKit.verifySubscription(
                 ofType: .nonRenewing(validDuration: 60),
                 productId: productId,
                 inReceipt: receipt)
                 self.showAlert(self.alertForVerifySubscriptions(purchaseResult, productIds: [productId]))
                 default:
                 */
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                self.showAlert(self.alertForVerifyPurchase(purchaseResult, productId: productId))
                //             }
                
            case .error:
                self.showAlert(self.alertForVerifyReceipt(result))
            }
        }
    }
    
    // Mark:- 購入処理
    
    func purchase(atomically: Bool) {
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        //   SwiftyStoreKit.purchaseProduct(appBundleId + "." + purchase.rawValue, atomically: atomically) { result in
        SwiftyStoreKit.purchaseProduct(appBundleId, atomically: atomically) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let purchase) = result {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                //　ロック解除
                self.setUnlocked()
               
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }
}

extension InPurchaseViewController {
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: OKstr, style: .cancel, handler: nil))
        return alert
    }
    
    func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {
        
        if let product = result.retrievedProducts.first {
            productName.text = product.localizedTitle
            localPrice.text = product.localizedPrice
            productDesc.text = product.localizedDescription
            
            //      let priceString = product.localizedPrice!
            //      return alertWithTitle("製品名:"+product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
            return alertWithTitle("既に購入済みの方へ",message: "無料で購入履歴を復元できます。「復元」をタッチしてください。")
            
        } else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("App内課金情報をダウンロードできません。", message: "製品IDが不明: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "原因不明。ネット接続を確認してください。"
            return alertWithTitle("App内課金情報をダウンロードできません。", message: errorString)
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("購入成功: \(purchase.productId)")
            return alertWithTitle("購入成功", message: "ありがとうございました！")
            
        //          return nil
        case .error(let error):
            print("購入失敗: \(error)")
            switch error.code {
            case .unknown: return alertWithTitle("購入失敗", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("購入失敗", message: "支払いが許可されていない。")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("購入失敗", message: "App内課金のIDに誤り")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("購入失敗", message: "このデバイスは支払いが許可されていない。")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("購入失敗", message: "App内課金は販売されていない。")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("購入失敗", message: "クラウドへのアクセスが許可されていない。")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("購入失敗", message: "ネットワークに接続できない。")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("購入失敗", message: "クラウドサービスは取り消された。")
            default:
                return alertWithTitle("購入失敗", message: (error as NSError).localizedDescription)
            }
        }
    }
    
    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
        
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            return alertWithTitle("復元に失敗", message: "不明なエラー。時間をおいて試して下さい。")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            setUnlocked()
            return alertWithTitle("復元に成功", message: "購入履歴を復元しました。")
            
        } else {
            print("Nothing to Restore")
            return alertWithTitle("復元対象がありません", message: "購入履歴が見つかりません。")
        }
    }
    
   func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {
        
        switch result {
        case .success(let receipt):
            print("Verify receipt Success: \(receipt)")
            return alertWithTitle("購入レシートを確認", message: "リモートでレシートを確認。")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                return alertWithTitle("購入レシートの確認結果", message: "購入レシート無し。再度トライして下さい。")
            case .networkError(let error):
                return alertWithTitle("購入レシートの確認結果", message: "レシート確認中にネットワークエラー: \(error)")
            default:
                return alertWithTitle("購入レシートの確認結果", message: "レシートの確認に失敗: \(error)")
            }
        }
    }
    
    func alertForVerifySubscriptions(_ result: VerifySubscriptionResult, productIds: Set<String>) -> UIAlertController {
        
        switch result {
        case .purchased(let expiryDate, let items):
            print("\(productIds) is valid until \(expiryDate)\n\(items)\n")
            return alertWithTitle("製品は購読されました。", message: "購読は次の日まで有効： \(expiryDate)")
        case .expired(let expiryDate, let items):
            print("\(productIds) is expired since \(expiryDate)\n\(items)\n")
            return alertWithTitle("購読は終了", message: "購読は次の日か失効中： \(expiryDate)")
        case .notPurchased:
            print("\(productIds) has never been purchased")
            return alertWithTitle("購読・購入無し", message: "購入履歴が無い。")
        }
    }
    
    func alertForVerifyPurchase(_ result: VerifyPurchaseResult, productId: String) -> UIAlertController {
        
        switch result {
        case .purchased:
            print("\(productId) is purchased")
            return alertWithTitle("App内課金を購入", message: "データ保存制限を解除")
        case .notPurchased:
            print("\(productId) has never been purchased")
            return alertWithTitle("App内課金の購入履歴", message: "購入履歴はありません。")
        }
    }
    
    // Mark:- Methods
    
    func setUnlocked() {
        let msg:String = "App内課金は購入済み。ロックを解除。"
        purchaseButton.isEnabled = false
        restoreButton.isEnabled = false
        unlockStatus.text = msg
        unlocked = true
  //      showAnimation()
    
    }
    
// MARK:- 色の設定
    func setColor() {
        
        func setLabelColorOnDarkMode (){
            productDesc.theme_textColor = GlobalPicker.buttonTintColor3
            productDesc.theme_textColor = GlobalPicker.buttonTintColor3
            unlockStatus.theme_textColor = GlobalPicker.buttonTintColor3
            L1.theme_textColor = GlobalPicker.buttonTintColor3
            L2.theme_textColor = GlobalPicker.buttonTintColor3
            L3.theme_textColor = GlobalPicker.buttonTintColor3
        }
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        if MyThemes.current == .dark {setLabelColorOnDarkMode()}
        
        setButtonProperties(button: purchaseButton)
        setButtonProperties(button: restoreButton, backColor: GlobalPicker.buttonTintColor2,titleColorOnDark:GlobalPicker.buttonTitleColor)
        setButtonProperties(button: cancelButton, backColor: GlobalPicker.backgroundColor, titleColor: GlobalPicker.buttonTintColor3,titleColorOnDark:GlobalPicker.buttonTitleColor)
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
