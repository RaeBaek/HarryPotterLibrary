//
//  SeriesButton.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 3/27/25.
//

import UIKit

class SeriesButton: UIButton {
    let title: String
    let size: CGFloat
    
    init(frame: CGRect, title: String, size: CGFloat) {
        // iOS 15 이상부터 지원하는 코드
        // 개발 환경 세팅에서 iOS Minimum Deployments 버전을 16.0으로 설정했기에 사용
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(title, attributes: .init([.font: UIFont.systemFont(ofSize: size, weight: .regular)]))
        config.baseBackgroundColor = .systemGray5
        config.baseForegroundColor = .systemBlue
        config.cornerStyle = .capsule
        
        self.title = title
        self.size = size
        
        super.init(frame: frame)
        
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
