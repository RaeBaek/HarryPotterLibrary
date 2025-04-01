//
//  Extension+UIButton.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 4/1/25.
//

import UIKit

extension UIButton {
    func applySelectedStyle() {
        configuration?.baseForegroundColor = .white
        configuration?.baseBackgroundColor = .systemBlue
    }
    
    func applyUnselectedStyle() {
        configuration?.baseForegroundColor = .systemBlue
        configuration?.baseBackgroundColor = .systemGray5
    }
}
