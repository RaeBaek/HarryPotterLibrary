//
//  CustomVStackView.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 3/31/25.
//

import UIKit

final class CustomVStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.spacing = 8
        self.alignment = .leading
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
