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
        config.attributedTitle = AttributedString("1", attributes: .init([.font: UIFont.systemFont(ofSize: 16, weight: .regular)]))
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        
        let view = UIButton(configuration: config)
        return view
    }()
    
    // 시리즈 버튼 아래로 보여질 스크롤뷰
    let seriesScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    // 최상단 HStackView
    let topHStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
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
        view.text = Constants.Title.author
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
        view.text = Constants.Title.released
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
        view.text = Constants.Title.page
        view.textColor = .black
        return view
    }()
    
    let pageNumberLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .gray
        return view
    }()
    
    // 헌정사 VStackView
    let dedicationVStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
        return view
    }()
    
    let dedicationLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.text = Constants.Title.dedication
        view.textColor = .black
        return view
    }()
    
    let dedicationContentLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .darkGray
        view.numberOfLines = 0
        return view
    }()
    
    // 요약 VStackView
    let summaryVStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
        return view
    }()
    
    let summaryLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.text = Constants.Title.summary
        view.textColor = .black
        return view
    }()
    
    let summaryContentLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .regular)
        view.textColor = .darkGray
        view.numberOfLines = 0
        return view
    }()
    
    // 더보기, 접기 버튼
    var moreButton: UIButton?
    
    // 챕터 VStackView
    let chaptersVStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
        return view
    }()
    
    let chaptersLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.text = Constants.Title.chapters
        view.textColor = .black
        return view
    }()
    
    let chaptersContentVStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading
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
        coverImage.image = Constants.Image.harrypotter1
        bookTitleLabel.text = harryPoterLibrary[0].title
        
        authoreNameLabel.text = harryPoterLibrary[0].author
        
        releasedDateLabel.text = harryPoterLibrary[0].releaseDate
        
        pageNumberLabel.text = "\(harryPoterLibrary[0].pages)"
        
        dedicationContentLabel.text = harryPoterLibrary[0].dedication
        
        let (bool, string) = checkedCharacters(harryPoterLibrary[0].summary)
        summaryContentLabel.text = string
        
        if bool {
            setMoreButton()
        }
        
        updateChapters()
    }
    
    private func updateChapters() {
        // 기존 뷰 제거
        chaptersContentVStackView.arrangedSubviews.forEach {
            chaptersContentVStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        // 새 챕터 추가
        for (index, chapter) in harryPoterLibrary[0].chapters.enumerated() {
            let chapterLabel = UILabel()
            chapterLabel.text = "\(index + 1). \(chapter)"
            chapterLabel.font = .systemFont(ofSize: 14, weight: .regular)
            chapterLabel.textColor = .darkGray
            chapterLabel.numberOfLines = 0
            chaptersContentVStackView.addArrangedSubview(chapterLabel)
        }
    }
    
    // 요약문이 450자 이상, 미만인지 먼저 체크
    private func checkedCharacters(_ originalText: String) -> (Bool, String) {
        let maxCharacters = 450
        
        if originalText.count > maxCharacters {
            if UserDefaults.standard.bool(forKey: "moreButtonEnable") {
                return (true, originalText)
            } else {
                return (true, String(originalText.prefix(maxCharacters)) + "...")
            }
        } else {
            return (false, originalText)
        }
    }
    
    private func setMoreButton() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        if UserDefaults.standard.bool(forKey: "moreButtonEnable") {
            config.attributedTitle = AttributedString("접기", attributes: .init([.font: UIFont.systemFont(ofSize: 13, weight: .regular)]))
        } else {
            config.attributedTitle = AttributedString("더 보기", attributes: .init([.font: UIFont.systemFont(ofSize: 13, weight: .regular)]))
        }
        
        moreButton = UIButton(configuration: config)
        moreButton?.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        seriesScrollView.addSubview(moreButton!)
        
        // moreButton의 제약조건을 잡기 위해 기존의 chaptersVStackView 제약조건 제거
        chaptersVStackView.snp.removeConstraints()
        
        // moreButton Layout 구성
        moreButton!.snp.makeConstraints {
            $0.top.equalTo(summaryVStackView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(5)
        }
        
        // moreButton 하단에 chaptersVStackView Layout 구성
        chaptersVStackView.snp.makeConstraints {
            $0.top.equalTo(moreButton!.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
    // 더 보기, 접기 상황에 맞게 버튼 title과 summaryContentLabel text 수정
    @objc private func moreButtonTapped() {
        if UserDefaults.standard.bool(forKey: "moreButtonEnable") {
            UserDefaults.standard.set(false, forKey: "moreButtonEnable")
            moreButton?.configuration?.attributedTitle = AttributedString("더 보기", attributes: .init([.font: UIFont.systemFont(ofSize: 13, weight: .regular)]))
        } else {
            UserDefaults.standard.set(true, forKey: "moreButtonEnable")
            moreButton?.configuration?.attributedTitle = AttributedString("접기", attributes: .init([.font: UIFont.systemFont(ofSize: 13, weight: .regular)]))
        }
        
        summaryContentLabel.text = checkedCharacters(harryPoterLibrary[0].summary).1
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
        
        [titleLabel, seriesButton, seriesScrollView].forEach {
            view.addSubview($0)
        }
        
        [topHStackView, dedicationVStackView, summaryVStackView, chaptersVStackView].forEach {
            seriesScrollView.addSubview($0)
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
        
        [dedicationLabel, dedicationContentLabel].forEach {
            dedicationVStackView.addArrangedSubview($0)
        }
        
        [summaryLabel, summaryContentLabel].forEach {
            summaryVStackView.addArrangedSubview($0)
        }
        
        [chaptersLabel, chaptersContentVStackView].forEach {
            chaptersVStackView.addArrangedSubview($0)
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
        
        seriesScrollView.snp.makeConstraints {
            $0.top.equalTo(seriesButton.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 책표지 크기 설정
        coverImage.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(coverImage.snp.width).multipliedBy(1.5)
        }
        
        // 책 표지의 높이를 따르는 topHStackView
        topHStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.width.equalTo(seriesScrollView.snp.width)
        }
        
        // 헌정사 VStack Layout
        dedicationVStackView.snp.makeConstraints {
            $0.top.equalTo(topHStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        // 요약 VStack Layout
        summaryVStackView.snp.makeConstraints {
            $0.top.equalTo(dedicationVStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
        }
        
        // 챕터 VStack Layout
        chaptersVStackView.snp.makeConstraints {
            $0.top.equalTo(summaryVStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }

}
