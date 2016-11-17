//
//  AppDelegate.swift
//  krombopulos-hw6
//
//  Created by Team Krombopulos on 9/20/16.
//  Copyright © 2016 Team Krombopulos. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        GMSServices.provideAPIKey("AIzaSyBNpE_sNKtWK-05u6Qm2IGWgmkqLOxs1F8")
        return true
    }
    
}
