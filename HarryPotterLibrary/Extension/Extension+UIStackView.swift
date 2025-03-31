//
//  Extension+UIStackView.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 3/31/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
