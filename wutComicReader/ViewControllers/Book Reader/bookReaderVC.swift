//
//  bookReaderVC.swift
//  wutComicReader
//
//  Created by Shayan on 6/25/19.
//  Copyright © 2019 wutup. All rights reserved.
//

import UIKit


class BookReaderVC: UIViewController {
    
    //MARK:- Variables
    
    var comicPagesCount: Int = 0
    
    var comic : Comic? {
        didSet{
            guard let _ = comic else { return }
            comicPagesCount = (comic!.imageNames?.count ?? 0)
            comicPageNumberLabel.text = String(comicPagesCount)
            pageSlider.maximumValue = Float(comicPagesCount)
            titleLabel.text = comic?.name
        }
    }
    var lastViewedPage : Int?
    
    var menusAreAppeard: Bool = false
    
    var bookPageViewController : UIPageViewController!
    var bookSingleImages : [UIImage] = []
    var bookDoubleImages : [(UIImage? , UIImage?)] = []
    var bookPages: [BookPage] = [] 
    
    var deviceIsLandscaped: Bool = UIDevice.current.orientation.isLandscape {
        didSet{
            
            if deviceIsLandscaped {
                let totalImages = comic!.imageNames?.count ?? 0
                comicPagesCount = (totalImages ) / 2 + (totalImages % 2)
            }else {
                comicPagesCount = comic!.imageNames?.count ?? 0
            }
            
            setPageViewControllers()
            
            guard let currentPage = bookPageViewController.viewControllers?[0] as? BookPage else { return }
            guard let currentIndex = bookPages.firstIndex(of: currentPage) else { return }
            
            thumbnailCollectionView.reloadData()
            let scrollToIndex = deviceIsLandscaped ? currentIndex / 2 : currentIndex * 2
            thumbnailCollectionView.selectItem(at: IndexPath(row: scrollToIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            bookPageViewController.setViewControllers([bookPages[scrollToIndex]], direction: .forward, animated: false, completion: nil)
            
            pageSlider.maximumValue = Float(comicPagesCount)
            pageSlider.setValue(Float(scrollToIndex + 1), animated: false)
            
            
        }
    }
    
    
    
    //MARK:- UI Variables
    
    lazy var thumbnailCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(thumbnailCell.self, forCellWithReuseIdentifier: "thumbnailCell")
        collectionView.restorationIdentifier = "thumbnail"
        collectionView.backgroundColor = .appSystemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.clipsToBounds = true
        return collectionView
    }()
    
    lazy var pageSlider : UISlider = {
        let slider = UISlider(frame: .zero)
        slider.tintColor = .appBlue
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 1
        slider.setValue(1, animated: false)
        slider.setValue(1.00, animated: false)
        slider.addTarget(self, action: #selector(sliderDidChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderDidFinishedChanging), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderDidFinishedChanging), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderDidFinishedChanging), for: .touchCancel)
        return slider
    }()
    
    lazy var currentPageNumberLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: appFontRegular, size: 14)
        label.textColor = .appSeconedlabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        return label
    }()
    
    lazy var comicPageNumberLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: appFontRegular, size: 14)
        label.textColor = .appSeconedlabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "50"
        return label
    }()
    
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: appFontRegular, size: 15)
        label.text = "BLAH!"
        label.textAlignment = .center
        label.textColor = .appMainLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .appSystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.makeDropShadow(shadowOffset: .zero, opacity: 0.3, radius: 15)
        return view
    }()
    
    lazy var dismissButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage( UIImage(named: "down") , for: .normal)
        button.addTarget(self, action: #selector(closeTheVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var bottomView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.backgroundColor = .appSystemBackground
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    
    //MARK:- Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupDesign()
        setupPageController()
        disappearMenus(animated: false)
        
        addGestures()
        
        setupTopBar()
        setupBottomViewDesign()
        
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
        
        deviceIsLandscaped = UIDevice.current.orientation.isLandscape
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        deviceIsLandscaped = UIDevice.current.orientation.isLandscape
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let LastpageNumber = (comic?.lastVisitedPage) ?? 0
        updatePageSlider(with: Int(truncating: NSNumber(value: LastpageNumber)))
        
        
    }
    
    
    
    func setupBottomViewDesign(){
        
        view.addSubview(bottomView)
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: 20).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: calculateBottomViewHeight()).isActive = true
        
        bottomView.layer.cornerRadius = 20
        bottomView.makeDropShadow(shadowOffset: CGSize(width: 0, height: 0), opacity: 0.5, radius: 25)
        
        bottomView.addSubview(pageSlider)
        pageSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.62).isActive = true
        pageSlider.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor).isActive = true
        pageSlider.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor, constant: -35).isActive = true
        
        bottomView.addSubview(currentPageNumberLabel)
        currentPageNumberLabel.centerYAnchor.constraint(equalTo: pageSlider.centerYAnchor, constant: 0).isActive = true
        currentPageNumberLabel.rightAnchor.constraint(equalTo: pageSlider.leftAnchor, constant: -17).isActive = true
        
        bottomView.addSubview(comicPageNumberLabel)
        comicPageNumberLabel.centerYAnchor.constraint(equalTo: pageSlider.centerYAnchor, constant: 0).isActive = true
        comicPageNumberLabel.leftAnchor.constraint(equalTo: pageSlider.rightAnchor, constant: 17).isActive = true
        
        bottomView.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20).isActive = true
        thumbnailCollectionView.bottomAnchor.constraint(equalTo: pageSlider.topAnchor, constant: -5).isActive = true
        thumbnailCollectionView.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 10).isActive = true
        thumbnailCollectionView.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -10).isActive = true
        
    }
    
    func calculateBottomViewHeight() -> CGFloat{
        var height :CGFloat?
        switch deviceType {
        case .iPad:
            height = (deviceIsLandscaped ? view.bounds.width : view.bounds.height) / 3.5
        case .smalliPhone:
            height = (deviceIsLandscaped ? view.bounds.width : view.bounds.height) / 3.2
        case .iPhone:
            height = (deviceIsLandscaped ? view.bounds.width : view.bounds.height) / 3
        case .iPhoneX:
            height = (deviceIsLandscaped ? view.bounds.width : view.bounds.height) / 3
        }
        print("bounds height is : \(view.bounds.height)")
        return height!
    }
    
    func setupTopBar(){
        
        view.addSubview(topBar)
        topBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50).isActive = true
        
        topBar.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: topBar.leftAnchor, constant: 60).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: topBar.rightAnchor, constant: -30).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        
        topBar.addSubview(dismissButton)
        dismissButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        dismissButton.leftAnchor.constraint(equalTo: topBar.leftAnchor, constant: 20).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 27).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        dismissButton.clipsToBounds = true
        
        
        
    }
    
    func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleMenusGestureTapped))
        tapGesture.numberOfTapsRequired = 1
        bookPageViewController.view.addGestureRecognizer(tapGesture)
        
        let doubletapGesture = UITapGestureRecognizer(target: self, action: #selector(zoomBookCurrentPage))
        doubletapGesture.numberOfTapsRequired = 2
        bookPageViewController.view.addGestureRecognizer(doubletapGesture)
        
        tapGesture.require(toFail: doubletapGesture)
        
    }
    
    func updatePageSlider(with value: Int){
        pageSlider.setValue(Float(value), animated: true)
        currentPageNumberLabel.text = String(value)
    }
    
    @objc func sliderDidChanged(){
        let value = Int(pageSlider.value)
        
        thumbnailCollectionView.scrollToItem(at: IndexPath(row: value - 1, section: 0), at: .centeredHorizontally, animated: false)
        if deviceIsLandscaped{
            currentPageNumberLabel.text = String(value * 2 - 1) + "-" + String(value * 2)
        }else{
            currentPageNumberLabel.text = String(value)
        }
    }
    
    @objc func sliderDidFinishedChanging(){
        let value = Int(pageSlider.value)
        thumbnailCollectionView.selectItem(at: IndexPath(row: value - 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        let pendingPage = bookPages[value - 1]
        pendingPage.scrollView.setZoomScale(pendingPage.scrollView.minimumZoomScale, animated: false)
        bookPageViewController.setViewControllers([pendingPage], direction: .forward, animated: true, completion: nil)
        
    }
    
    @objc func zoomBookCurrentPage() {
        let currentPage = bookPageViewController.viewControllers?.first as? BookPage
        currentPage?.zoomWithDoubleTap()
        
    }
    
    @objc func toggleMenusGestureTapped() {
        if menusAreAppeard {
            disappearMenus(animated: true)
        }else{
            appearMenus(animated: true)
        }
    }
    

    
    func disappearMenus(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.titleLabel.alpha = 0.0
                self.dismissButton.alpha = 0.0
                self.topBar.alpha = 0.0
                
                
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: self.bottomView.frame.height)
                self.bottomView.alpha = 0.1
            }) { (_) in
                self.titleLabel.alpha = 0.0
                self.dismissButton.alpha = 0.0
                self.topBar.alpha = 0.0
                
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: self.bottomView.frame.height)
                self.bottomView.alpha = 0.1
                self.menusAreAppeard = false
            }
        }else{
            self.titleLabel.alpha = 0.0
            self.dismissButton.alpha = 0.0
            self.topBar.alpha = 0.0
            
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: 500)
            self.bottomView.alpha = 0.0
            menusAreAppeard = false
        }
        
    }
    
    func appearMenus(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.titleLabel.alpha = 1
                self.dismissButton.alpha = 1
                self.topBar.alpha = 1
                
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomView.alpha = 1
            }) { (_) in
                self.titleLabel.alpha = 1
                self.dismissButton.alpha = 1
                self.topBar.alpha = 1
                
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomView.alpha = 1
                self.menusAreAppeard = true
            }
        }else{
            self.titleLabel.alpha = 1
            self.dismissButton.alpha = 1
            self.topBar.alpha = 1
            
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.bottomView.alpha = 1
            menusAreAppeard = true
        }
        
    }
    
    
    @objc func closeTheVC(){

        dismiss(animated: false, completion: {
//            self.saveTheCurrentPageToCoreData()
        })
    }
    
    func saveTheCurrentPageToCoreData() {
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    
}



