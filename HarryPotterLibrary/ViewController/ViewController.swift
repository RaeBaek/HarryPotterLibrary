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
    let bookInfoVStack = CustomVStackView()
    
    let bookTitleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.numberOfLines = 0
        return view
    }()
    
    // 저자 HStackView
    let authorHStackView = CustomHStackView()
    
    let authorLabel = CustomUILabel(frame: .zero, size: 16, weight: .bold, text: Constants.Title.author, textColor: .black)
    let authorNameLabel = CustomUILabel(frame: .zero, size: 18, weight: .regular, text: nil, textColor: .darkGray)
    
    // 출간일 HStackView
    let releaseHStackView = CustomHStackView()
    
    let releasedLabel = CustomUILabel(frame: .zero, size: 14, weight: .bold, text: Constants.Title.released, textColor: .black)
    let releasedDateLabel = CustomUILabel(frame: .zero, size: 14, weight: .bold, text: nil, textColor: .gray)
    
    // 페이지 HStackView
    let pageHStackView = CustomHStackView()
    
    let pageLabel = CustomUILabel(frame: .zero, size: 14, weight: .bold, text: nil, textColor: .black)
    let pageNumberLabel = CustomUILabel(frame: .zero, size: 14, weight: .regular, text: nil, textColor: .gray)
    
    // 헌정사 VStackView
    let dedicationVStackView = CustomVStackView()
    
    let dedicationLabel = CustomUILabel(frame: .zero, size: 18, weight: .bold, text: Constants.Title.dedication, textColor: .black)
    let dedicationContentLabel = {
        let view = CustomUILabel(frame: .zero, size: 14, weight: .regular, text: nil, textColor: .darkGray)
        view.numberOfLines = 0
        return view
    }()
        
    // 요약 VStackView
    let summaryVStackView = CustomVStackView()
    
    let summaryLabel = CustomUILabel(frame: .zero, size: 18, weight: .bold, text: Constants.Title.summary, textColor: .black)
    let summaryContentLabel = {
        let view = CustomUILabel(frame: .zero, size: 14, weight: .regular, text: nil, textColor: .darkGray)
        view.numberOfLines = 0
        return view
    }()
    
    // 더보기, 접기 버튼
    var moreButton: UIButton?
    
    // 챕터 VStackView
    let chaptersVStackView = CustomVStackView()
    
    let chaptersLabel = CustomUILabel(frame: .zero, size: 18, weight: .bold, text: Constants.Title.chapters, textColor: .black)
    
    let chaptersContentVStackView = CustomVStackView()
    
    let dataService = DataService()
    var harryPoterLibrary: [Book] = []
    var userDefaultsManager = UserDefaultsManager.shared
    
    // 이전 선택된 버튼을 추적할 변수
    private var previousSelectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setConstraints()
        configureUserDefaults()
        fetchBookData()
        setSeriesButton()
    }
    
    private func configureUserDefaults() {
        // 최초 실행 시, currentSeriesButtonIndex가 없다면 1로 설정
        if userDefaultsManager.getCurrentSeriesButtonIndex() == 0 {
            // 최초 실행 시 1로 설정
            userDefaultsManager.setCurrentSeriesButtonIndex(1)
        }
    }
    
    private func fetchData(completionHandler: @escaping ([Book]) -> ()) {
        dataService.loadBooks { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showAlert(error.rawValue)
                }
            }
        }
    }
    
    private func fetchBookData() {
        fetchData { [weak self] data in
            guard let self else { return }
            self.harryPoterLibrary = data
            
            let index = userDefaultsManager.getCurrentSeriesButtonIndex()
            setPageInfo(index)
        }
    }
    
    private func setPageInfo(_ index: Int) {
        let libraryIndex = index - 1
        let currentBook = harryPoterLibrary[libraryIndex]
        
        updateBookInfoView(with: currentBook, index: index)
        updateMoreButton(for: currentBook, index: index)
        updateChapters(libraryIndex)
    }
    
    private func updateBookInfoView(with book: Book, index: Int) {
        titleLabel.text = book.title
        coverImage.image = UIImage(named: "harrypotter\(index)") //Constants.Image.harrypotter1
        bookTitleLabel.text = book.title
        
        authorNameLabel.text = book.author
        releasedDateLabel.text = book.releaseDate.formattedDate
        pageNumberLabel.text = "\(book.pages)"
        
        dedicationContentLabel.text = book.dedication
        
        let string = checkedCharacters(index, book.summary)
        summaryContentLabel.text = string
    }
    
    private func updateMoreButton(for book: Book, index: Int) {
        // moreButton의 제약조건을 잡기 위해 기존의 chaptersVStackView 제약조건 제거
        moreButton?.removeFromSuperview()
        chaptersVStackView.snp.removeConstraints()
        
        if book.summary.count > Constants.Summary.maxLength {
            setMoreButton(index)
        } else {
            setConstraints()
        }
    }
    
    // 시리즈 버튼 설정
    private func setSeriesButton() {
        if let index = UserDefaults.standard.value(forKey: UserDefaultsKey.currentSeriesButtonIndex) as? Int {
            for i in 1...harryPoterLibrary.count {
                let seriesButton = SeriesButton(frame: .zero, title: "\(i)", size: 16)
                
                if i == index {
                    applySelectedStyle(to: seriesButton)
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
            applyUnselectedStyle(to: previousSelectedButton)
        }
        applySelectedStyle(to: sender)
        
        previousSelectedButton = sender
        
        UserDefaults.standard.set(sender.tag, forKey: UserDefaultsKey.currentSeriesButtonIndex)
        
        setPageInfo(sender.tag)
        
        seriesScrollView.setContentOffset(.zero, animated: true)
    }
    
    private func applySelectedStyle(to button: UIButton) {
        button.configuration?.baseForegroundColor = .white
        button.configuration?.baseBackgroundColor = .systemBlue
    }
    
    private func applyUnselectedStyle(to button: UIButton) {
        button.configuration?.baseForegroundColor = .systemBlue
        button.configuration?.baseBackgroundColor = .systemGray5
    }
    
    // 챕터 스택 뷰 내용 업데이트
    private func updateChapters(_ index: Int) {
        clearChapters()
        addChapters(from: harryPoterLibrary[index])
    }
    
    // 기존 스택 뷰 제거
    private func clearChapters() {
        chaptersContentVStackView.arrangedSubviews.forEach {
            chaptersContentVStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    // 새로운 스택 뷰 추가
    private func addChapters(from book: Book) {
        for chapter in book.chapters {
            let chapterLabel = UILabel()
            chapterLabel.text = chapter.title
            chapterLabel.font = .systemFont(ofSize: 14, weight: .regular)
            chapterLabel.textColor = .darkGray
            chapterLabel.numberOfLines = 0
            chaptersContentVStackView.addArrangedSubview(chapterLabel)
        }
    }
    
    // 요약문이 450자 이상, 미만인지 먼저 체크
    private func checkedCharacters(_ index: Int, _ originalText: String) -> String {
        if originalText.count > Constants.Summary.maxLength {
            if userDefaultsManager.getMoreButtonEnable(index) {
                return originalText
            } else {
                return String(originalText.prefix(Constants.Summary.maxLength)) + "..."
            }
        } else {
            return originalText
        }
    }
    
    // 더보기 버튼 설정
    private func setMoreButton(_ index: Int) {
        var config = UIButton.Configuration.plain()
        let status = userDefaultsManager.getMoreButtonEnable(index)
        let title = status ? Constants.ButtonTitle.less : Constants.ButtonTitle.more
        
        config.attributedTitle = setAttributedTitle(title: title)
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        moreButton = UIButton(configuration: config)
        moreButton?.tag = index
        moreButton?.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        
        seriesScrollView.addSubview(moreButton!)
        layoutMoreButton()
    }
    
    // 더 보기, 접기 상황에 맞게 버튼 title과 summaryContentLabel text 수정
    @objc private func moreButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let status = userDefaultsManager.getMoreButtonEnable(index)
        
        userDefaultsManager.setMoreButtonEnable(index, !status)
        
        let title = !status ? Constants.ButtonTitle.less : Constants.ButtonTitle.more
        sender.configuration?.attributedTitle = setAttributedTitle(title: title)
        
        summaryContentLabel.text = checkedCharacters(index, harryPoterLibrary[index - 1].summary)
    }
    
    // 더 보기, 접기 버튼 title 설정
    private func setAttributedTitle(title: String) -> AttributedString {
        return AttributedString(title, attributes: .init([.font: UIFont.systemFont(ofSize: 13, weight: .regular)]))
    }
    
    // 알림 보여주기
    private func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: Constants.Alert.retryMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.Alert.confirm, style: .default)
        let cancelAction = UIAlertAction(title: Constants.Alert.cancel, style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        view.addSubviews(titleLabel, seriesHStackView, seriesScrollView)
        
        seriesScrollView.addSubviews(topHStackView, dedicationVStackView, summaryVStackView, chaptersVStackView)
        
        authorHStackView.addArrangedSubviews(authorLabel, authorNameLabel)
        releaseHStackView.addArrangedSubviews(releasedLabel, releasedDateLabel)
        pageHStackView.addArrangedSubviews(pageLabel, pageNumberLabel)
        bookInfoVStack.addArrangedSubviews(bookTitleLabel, authorHStackView, releaseHStackView, pageHStackView)
        
        topHStackView.addArrangedSubviews(coverImage, bookInfoVStack)
        dedicationVStackView.addArrangedSubviews(dedicationLabel, dedicationContentLabel)
        summaryVStackView.addArrangedSubviews(summaryLabel, summaryContentLabel)
        chaptersVStackView.addArrangedSubviews(chaptersLabel, chaptersContentVStackView)
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
    
    private func layoutMoreButton() {
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
}
