//
//  Helper.swift
//  wutComicReader
//
//  Created by Shayan on 7/10/19.
//  Copyright © 2019 wutup. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation



extension UIView {
    
    func makeDropShadow(scale: Bool = true , shadowOffset: CGSize , opacity: Float, radius: Int) {
        layer.shadowColor = UIColor.appShadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = 5
        layer.shadowOpacity = opacity
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}

extension UIImage{
    convenience init?(_ comic: Comic? ,withImageName imageName: String?) {
        let comicname : String = comic?.name ?? ""
        let imagename: String = imageName ?? ""
        let appfileManager = AppFileManager()
        
        let path = appfileManager.comicDirectory.path + "/" + comicname  + "/" + imagename
        self.init(contentsOfFile: path)
    }
    
    func resize(forSize size: CGSize) -> UIImage {
        let image = self
        let render = UIGraphicsImageRenderer(size: size)
        return render.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIViewController {
    func appLaunchedForFirstTime() -> Bool {
        let didLaunchedBefore = UserDefaults.standard.bool(forKey: "appDidLunchedBefore")
        if !didLaunchedBefore {
            UserDefaults.standard.set(true, forKey: "appDidLunchedBefore")
            return true
        }else{
            return false
        }
    }
}


