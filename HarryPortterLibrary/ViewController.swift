//
//  ViewController.swift
//  HarryPortterLibrary
//
//  Created by 백래훈 on 3/24/25.
//

import UIKit

import SnapKit

class ViewController: UIViewController {
    
    // 대제목
    let titleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    // iOS 15 이상부터 지원하는 코드
    // 개발 환경 세팅에서 iOS Minimum Deployments 버전을 16.0으로 설정했기에 사용
    // 시리즈 버튼
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
    
    // 최상단 HStackView
    let topHStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .leading
        return view
    }()
    
    // 표지 이미지
    let coverImage = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // 우측 책 정보 VStackView
    let bookInfoVStack = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
        return view
    }()
    
    let bookTitleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.numberOfLines = 0
        return view
    }()
    
    // 저자 HStackView
    let authorHStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .leading
        return view
    }()
    
    let authorLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .bold)
        view.textColor = .black
        return view
    }()
    
    let authoreNameLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .regular)
        view.textColor = .darkGray
        return view
    }()
    
    // 출간일 HStackView
    let releaseHStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .leading
        return view
    }()
    
    let releasedLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .bold)
        view.textColor = .black
        return view
    }()
    
    let releasedDateLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .bold)
        view.textColor = .gray
        return view
    }()
    
    // 페이지 HStackView
    let pageHStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .leading
        return view
    }()
    
    let pageLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .bold)
        view.textColor = .black
        return view
    }()
    
    let pageNumberLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .gray
        return view
    }()

    let dataService = DataService()
    var harryPoterLibrary: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        
        fetchData()
        
    }
    
    private func fetchData() {
        dataService.loadBooks { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                data.forEach {
                    self.harryPoterLibrary.append($0)
                }
            case .failure(let error):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showAlert(error.rawValue)
                }
            }
        }
        
        titleLabel.text = harryPoterLibrary[0].title
        coverImage.image = UIImage(named: "harrypotter1")
        bookTitleLabel.text = harryPoterLibrary[0].title
        authorLabel.text = "Author"
        authoreNameLabel.text = harryPoterLibrary[0].author
        releasedLabel.text = "Released"
        releasedDateLabel.text = harryPoterLibrary[0].releaseDate
        pageLabel.text = "Page"
        pageNumberLabel.text = "\(harryPoterLibrary[0].pages)"
    }
    
    private func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: "다시 시도해 주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        [titleLabel, seriesButton, topHStackView].forEach {
            view.addSubview($0)
        }
        
        [authorLabel, authoreNameLabel].forEach {
            authorHStackView.addArrangedSubview($0)
        }
        
        [releasedLabel, releasedDateLabel].forEach {
            releaseHStackView.addArrangedSubview($0)
        }
        
        [pageLabel, pageNumberLabel].forEach {
            pageHStackView.addArrangedSubview($0)
        }
        
        [bookTitleLabel, authorHStackView, releaseHStackView, pageHStackView].forEach {
            bookInfoVStack.addArrangedSubview($0)
        }
        
        [coverImage, bookInfoVStack].forEach {
            topHStackView.addArrangedSubview($0)
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
        
        coverImage.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(coverImage.snp.width).multipliedBy(1.5)
        }
        
        topHStackView.snp.makeConstraints {
            $0.top.equalTo(seriesButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(view.safeAreaInsets).inset(16)
        }
    }

}
