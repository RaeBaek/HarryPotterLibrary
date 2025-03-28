//
//  UserDefaultManager.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 3/28/25.
//

import Foundation

class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    private init() {}
    
    var currentSeriesButtonIndex: Void {
        didSet {
            
        }
        
        willSet(newValue) {
            UserDefaults.standard.set(newValue, forKey: "currentSeriesButtonIndex")
        }
        
    }
        
}
