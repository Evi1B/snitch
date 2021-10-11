//
//  Helpers.swift
//  test
//
//  Created by evilb on 02.10.2021.
//

import Foundation

let kWinNotification = Notification.Name(rawValue: "kWinNotification")

class Helpers {
    static let shared = Helpers()
    
    private let defaults = UserDefaults.standard
    let kIsFirstRun = "kIsFirstRun"

    private init() {
        if UserDefaults.standard.object(forKey: kIsFirstRun) == nil {
            isFirstRun = true
        }
    }
    
    var isFirstRun : Bool {
        get {
            return defaults.bool(forKey: kIsFirstRun)
        }
        set{
            defaults.set(newValue, forKey: kIsFirstRun)
            defaults.synchronize()
        }
    }
}


