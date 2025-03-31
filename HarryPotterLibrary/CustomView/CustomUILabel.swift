//
//  CustomUILabel.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 3/31/25.
//

import UIKit

final class CustomUILabel: UILabel {
    init(frame: CGRect, size: CGFloat, weight: UIFont.Weight, text: String?, textColor: UIColor) {
        super.init(frame: frame)
        
        self.font = .systemFont(ofSize: size, weight: weight)
        self.text = text ?? "empty"
        self.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
