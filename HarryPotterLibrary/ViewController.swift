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
    
    // 시리즈 HStackView
    let seriesHStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .center
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
    var userDefaultManager = UserDefaultManager.shared
    
    // 이전 선택된 버튼을 추적할 변수
    private var previousSelectedButton: UIButton?
    
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
        
        // 최초 실행 시, currentSeriesButtonIndex가 없다면 1로 설정
        if UserDefaults.standard.value(forKey: "currentSeriesButtonIndex") == nil {
            UserDefaults.standard.set(1, forKey: "currentSeriesButtonIndex")  // 최초 실행 시 1로 설정
        }
        
        if let index = UserDefaults.standard.value(forKey: "currentSeriesButtonIndex") as? Int {
            setPageInfo(index)
        }
        
        setSeriesButton()
    }
    
    private func setPageInfo(_ index: Int) {
        let libraryIndex = index - 1
        
        titleLabel.text = harryPoterLibrary[libraryIndex].title
        coverImage.image = UIImage(named: "harrypotter\(index)") //Constants.Image.harrypotter1
        bookTitleLabel.text = harryPoterLibrary[libraryIndex].title
        
        authoreNameLabel.text = harryPoterLibrary[libraryIndex].author
        releasedDateLabel.text = harryPoterLibrary[libraryIndex].releaseDate
        pageNumberLabel.text = "\(harryPoterLibrary[libraryIndex].pages)"
        
        dedicationContentLabel.text = harryPoterLibrary[libraryIndex].dedication
        
        let (bool, string) = checkedCharacters(index, harryPoterLibrary[libraryIndex].summary)
        summaryContentLabel.text = string
        
        // moreButton의 제약조건을 잡기 위해 기존의 chaptersVStackView 제약조건 제거
        moreButton?.removeFromSuperview()
        chaptersVStackView.snp.removeConstraints()
        
        if bool {
            setMoreButton(index)
        } else {
            setConstraints()
        }
        
        updateChapters(libraryIndex)
    }
    
    // 시리즈 버튼 설정
    private func setSeriesButton() {
        if let index = UserDefaults.standard.value(forKey: "currentSeriesButtonIndex") as? Int {
            for i in 1...harryPoterLibrary.count {
                let seriesButton = SeriesButton(frame: .zero, title: "\(i)", size: 16)
                
                if i == index {
                    seriesButton.configuration?.baseForegroundColor = .white
                    seriesButton.configuration?.baseBackgroundColor = .systemBlue
                    
                    previousSelectedButton = seriesButton
                }
                
                seriesButton.tag = i
                seriesButton.addTarget(self, action: #selector(seriesButtonTapped(_:)), for: .touchUpInside)
                
                seriesHStackView.addArrangedSubview(seriesButton)
                seriesButton.snp.makeConstraints {
                    $0.width.equalTo(seriesButton.snp.height)
                }
            }
        }
        
    }
    
    // 각각의 시리즈 버튼 클릭 시
    @objc private func seriesButtonTapped(_ sender: UIButton) {
        // 이전 버튼이 있는 경우, 색상 리셋
        if let previousSelectedButton {
            previousSelectedButton.configuration?.baseForegroundColor = .systemBlue
            previousSelectedButton.configuration?.baseBackgroundColor = .systemGray5
        }
        
        sender.configuration?.baseForegroundColor = .white
        sender.configuration?.baseBackgroundColor = .systemBlue
        
        previousSelectedButton = sender
        
        UserDefaults.standard.set(sender.tag, forKey: "currentSeriesButtonIndex")
        
        setPageInfo(sender.tag)
    }
    
    // 챕터 스택 뷰 내용 업데이트
    private func updateChapters(_ index: Int) {
        // 기존 뷰 제거
        chaptersContentVStackView.arrangedSubviews.forEach {
            chaptersContentVStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        // 새 챕터 추가
        for chapter in harryPoterLibrary[index].chapters {
            let chapterLabel = UILabel()
            chapterLabel.text = chapter.title
            chapterLabel.font = .systemFont(ofSize: 14, weight: .regular)
            chapterLabel.textColor = .darkGray
            chapterLabel.numberOfLines = 0
            chaptersContentVStackView.addArrangedSubview(chapterLabel)
        }
    }
    
    // 요약문이 450자 이상, 미만인지 먼저 체크
    private func checkedCharacters(_ index: Int, _ originalText: String) -> (Bool, String) {
        let maxCharacters = 450
        
        if originalText.count > maxCharacters {
            if UserDefaults.standard.bool(forKey: "moreButtonEnable_\(index)") {
                return (true, originalText)
            } else {
                return (true, String(originalText.prefix(maxCharacters)) + "...")
            }
        } else {
            return (false, originalText)
        }
    }
    
    // 더보기 버튼 설정
    private func setMoreButton(_ index: Int) {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        if UserDefaults.standard.bool(forKey: "moreButtonEnable_\(index)") {
            config.attributedTitle = AttributedString("접기", attributes: .init([.font: UIFont.systemFont(ofSize: 13, weight: .regular)]))
        } else {
            config.attributedTitle = AttributedString("더 보기", attributes: .init([.font: UIFont.systemFont(ofSize: 13, weight: .regular)]))
        }
        
        moreButton = UIButton(configuration: config)
        moreButton?.tag = index
        moreButton?.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        seriesScrollView.addSubview(moreButton!)
        
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
    @objc private func moreButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        
        if UserDefaults.standard.bool(forKey: "moreButtonEnable_\(index)") {
            UserDefaults.standard.set(false, forKey: "moreButtonEnable_\(index)")
            moreButton?.configuration?.attributedTitle = AttributedString("더 보기", attributes: .init([.font: UIFont.systemFont(ofSize: 13, weight: .regular)]))
        } else {
            UserDefaults.standard.set(true, forKey: "moreButtonEnable_\(index)")
            moreButton?.configuration?.attributedTitle = AttributedString("접기", attributes: .init([.font: UIFont.systemFont(ofSize: 13, weight: .regular)]))
        }
        
        summaryContentLabel.text = checkedCharacters(index, harryPoterLibrary[index - 1].summary).1
    }
    
    // 알림 보여주기
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
        
        [titleLabel, seriesHStackView, seriesScrollView].forEach {
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
        
        seriesHStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            // UIButton.Configuration으로 작성한 UIButton은
            // 너비와 높이가 같을 경우 자동으로 원형이 됨.
        }
        
        seriesScrollView.snp.makeConstraints {
            $0.top.equalTo(seriesHStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
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
