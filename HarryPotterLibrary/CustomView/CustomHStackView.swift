//
//  CustomStackView.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 3/31/25.
//

import UIKit

final class CustomHStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.spacing = 8
        self.alignment = .bottom
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
