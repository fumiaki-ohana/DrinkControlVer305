//
//  AppDelegate.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2018/04/23.
//  Copyright © 2018年 Fumiaki Tsurumi. All rights reserved.
//
import UIKit
import RealmSwift
import SwiftyStoreKit
import SwiftTheme
import UserNotifications
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //    let customColor = UIColor.init(red: 242/255, green: 5/255, blue: 92/255, alpha: 94/100)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Mark: - Realm Version Configuration
        // Realmのコンフィギュレーション
        let schemaVer:UInt64 = 1
        let config = Realm.Configuration(schemaVersion: UInt64(schemaVer), deleteRealmIfMigrationNeeded: false)
        Realm.Configuration.defaultConfiguration = config
        
        // MARK:- Review request
        if  (processCompletedCountVar > hairCutForReview),#available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
         // FIXME: UserDefaultをリセットを変えろ
        //        unlocked = true
        
        
         if let bundleId = Bundle.main.bundleIdentifier {
         UserDefaults.standard.removePersistentDomain(forName: bundleId)
         }
        
        /*
         unlocked = false
         
         flagReadMeV3 = false
         flagReadMe = false
         saveTimes = 0
         flagConverted = false
         shouldShowVerInfo = true
         shouldShowCoarch = true
         shouldWarningOnRatingGraph = true
        //MARK:-FIXME
        saveTimes = 0
        shouldShowCoarch = true
        shouldShowVerInfo = true
        unlocked = false
        */
    
        //ユーザータイプの判定
        
        if unlocked {
            userType = .purchasedUser //購入済み
        }
        else if flagReadMe {
            userType = .currentUser // 既存ただし購入まだ、しかもV3より前のユーザー
        }
        //テーマを設定する
        if !(userType == .newUser) {
            if shouldShowCoarch {
                MyThemes.switchTo(theme: .norm)
            }
            else {
                MyThemes.restoreLastTheme()
                MyThemes.setTheme()
            }
        }
        else {
            MyThemes.switchToSimply(theme: .norm)
        }
        
        // 保存回数を強制的に0にする＞既存ユーザー
        if (userType == .currentUser), !flagConverted {
            let currentRemainTimes = 7 - saveTimes
            switch currentRemainTimes {
            case ...0: saveTimes = 2
            case 1: saveTimes = 1
            case 2...: saveTimes = 0
            default: saveTimes = 0
            }
            flagConverted = true
        }
        
        setupIAP()
        
        //ガイド未了の場合は、TUTORに飛ばす
        //TODO
        let storyboardName = shouldShowCoarch ? "StartUp":"PageMain" //新規ユーザーはイントロへ誘導
        //    let storyboardName = flagReadMeV3 ? "PageMain": "StartUp" //最初はすべてのユーザーが読む
        let storybord: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = storybord.instantiateInitialViewController()
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func setupIAP() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
/*
private extension AppDelegate {
    
    func forceUpdate () {
        
        let siren = Siren.shared
        siren.presentationManager = PresentationManager(forceLanguageLocalization: .japanese)
        siren.rulesManager = RulesManager(
            majorUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .force), // A.b.c.d
            minorUpdateRules: Rules(promptFrequency: .immediately, forAlertType: .option), // a.B.c.d
            patchUpdateRules: Rules(promptFrequency: .daily, forAlertType: .option), // a.b.C.d
            revisionUpdateRules: Rules(promptFrequency: .weekly, forAlertType: .skip) // a.b.c.D
        )
        siren.wail()
    }
}
*/

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // アプリ起動中でもアラートと音で通知
        completionHandler([.alert, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        
    }
}

