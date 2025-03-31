//
//  Extension+UIView.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 3/31/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
