//
//  UserDefaultManager.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 3/28/25.
//

import Foundation

enum UserDefaultsKey {
    static let currentSeriesButtonIndex = "currentSeriesButtonIndex"
    static func moreButtonEnableKey(_ index: Int) -> String {
        return "moreButtonEnable_\(index)"
    }
}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    func getCurrentSeriesButtonIndex() -> Int {
        return defaults.integer(forKey: UserDefaultsKey.currentSeriesButtonIndex)
    }
    
    func setCurrentSeriesButtonIndex(_ index: Int) {
        defaults.set(index, forKey: UserDefaultsKey.currentSeriesButtonIndex)
    }
    
    func getMoreButtonEnable(_ index: Int) -> Bool {
        return defaults.bool(forKey: UserDefaultsKey.moreButtonEnableKey(index))
    }
    
    func setMoreButtonEnable(_ index: Int, _ enable: Bool) {
        defaults.set(enable, forKey: UserDefaultsKey.moreButtonEnableKey(index))
    }
    
}
