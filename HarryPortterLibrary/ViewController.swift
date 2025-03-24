//
//  ViewController.swift
//  HarryPortterLibrary
//
//  Created by 백래훈 on 3/24/25.
//

import UIKit

import SnapKit

class ViewController: UIViewController {
    
    let titleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    // iOS 15 이상부터 지원하는 코드
    // 개발 환경 세팅에서 iOS Minimum Deployments 버전을 16.0으로 설정했기에 사용
    let seriesButton = {
        var config = UIButton.Configuration.filled()
        config.title = "1"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        
        let view = UIButton(configuration: config)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        
        return view
    }()

    let dataService = DataService()
    var harryPoterLibrary: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        
        dataService.loadBooks { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                data.forEach {
                    self.harryPoterLibrary.append($0)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        titleLabel.text = harryPoterLibrary[0].title
        
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        [titleLabel, seriesButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        seriesButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            // UIButton.Configuration으로 작성한 UIButton은
            // 너비와 높이가 같을 경우 자동으로 원형이 됨.
            $0.width.equalTo(seriesButton.snp.height)
        }
    }

}
