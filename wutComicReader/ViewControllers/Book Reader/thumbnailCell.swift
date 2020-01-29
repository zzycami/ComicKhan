//
//  thumbnailCell.swift
//  wutComicReader
//
//  Created by Shayan on 7/6/19.
//  Copyright © 2019 wutup. All rights reserved.
//

import UIKit

class thumbnailCell: UICollectionViewCell {
    
    var comicPage1: UIImage? {
        didSet{
            pageImageView1.image = comicPage1
        }
    }
    
    var comicPage2: UIImage? {
        didSet{
            pageImageView2.image = comicPage2
        }
    }
    
    var pageNumber: Int? {
        didSet{
            pageNumberLabel.text = "\(pageNumber!)"
        }
    }
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                choosePageAsActive()
            }else{
                choosePageAsDiactive()
            }
        }
    }
    
    var isDoupleSplashPage = false {
        didSet {
            if isDoupleSplashPage {
                
            }
        }
    }
    
    var haveDoublePage : Bool = false {
        didSet{
            
            if haveDoublePage && !isDoupleSplashPage {
                
                let widthConst = bounds.width / 2
                
                imageHolderView.addSubview(pageImageView2)
                pageImageView2.topAnchor.constraint(equalTo: imageHolderView.topAnchor).isActive = true
                pageImageView2.bottomAnchor.constraint(equalTo: imageHolderView.bottomAnchor , constant: 0).isActive = true
                pageImageView2.leftAnchor.constraint(equalTo: imageHolderView.leftAnchor , constant: widthConst).isActive = true
                pageImageView2.rightAnchor.constraint(equalTo: imageHolderView.rightAnchor).isActive = true
                
                pageImageView1rightConstraitInSinglePageMode?.isActive = false
                pageImageView1rightConstraitInDoublePageMode?.isActive = true
                
            }else{
                pageImageView2.removeFromSuperview()
                pageImageView1rightConstraitInDoublePageMode?.isActive = false
                pageImageView1rightConstraitInSinglePageMode?.isActive = true
            }
            
        }
    }
    
    var pageImageView1 : UIImageView = {
        let imageview = UIImageView(frame: .zero)
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    var pageImageView1rightConstraitInDoublePageMode : NSLayoutConstraint?
    var pageImageView1rightConstraitInSinglePageMode : NSLayoutConstraint?
    
    var pageImageView2 : UIImageView = {
        let imageview = UIImageView(frame: .zero)
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var pageNumberLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 10, weight: .thin)
        label.textAlignment = .center
        return label
    }()
    
    var imageHolderView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.6
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDesign()
    }
    
    func setupDesign() {
        
        addSubview(imageHolderView)
        imageHolderView.topAnchor.constraint(equalTo: topAnchor , constant: 5).isActive = true
        imageHolderView.bottomAnchor.constraint(equalTo: bottomAnchor , constant: -5).isActive = true
        imageHolderView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        imageHolderView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        imageHolderView.layer.cornerRadius = 2
        imageHolderView.clipsToBounds = true
        
        imageHolderView.makeDropShadow(shadowOffset: CGSize(width: 0, height: 0), opacity: 0.3, radius: 5)
        
        imageHolderView.addSubview(pageImageView1)
        pageImageView1.topAnchor.constraint(equalTo: imageHolderView.topAnchor).isActive = true
        pageImageView1.bottomAnchor.constraint(equalTo: imageHolderView.bottomAnchor , constant: 0).isActive = true
        pageImageView1.leftAnchor.constraint(equalTo: imageHolderView.leftAnchor).isActive = true
        pageImageView1rightConstraitInSinglePageMode = pageImageView1.rightAnchor.constraint(equalTo: imageHolderView.rightAnchor)
        pageImageView1rightConstraitInSinglePageMode?.isActive = true
        
         pageImageView1rightConstraitInDoublePageMode = pageImageView1.rightAnchor.constraint(equalTo: pageImageView2.leftAnchor, constant: 0)

        
    }
    
    private func addthumnailImages(){
        
    }
    
    private func choosePageAsActive() {
        UIView.animate(withDuration: 0.1, animations: {
            self.imageHolderView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.imageHolderView.makeDropShadow(shadowOffset: CGSize(width: 0, height: 0), opacity: 0.6, radius: 5)
            self.imageHolderView.alpha = 1
        }) { (_) in
        }
    }
    
    private func choosePageAsDiactive() {
        UIView.animate(withDuration: 0.1, animations: {
            self.imageHolderView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.imageHolderView.makeDropShadow(shadowOffset: CGSize(width: 0, height: 0), opacity: 0.3, radius: 5)
            self.imageHolderView.alpha = 0.6
        }) { (_) in
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}