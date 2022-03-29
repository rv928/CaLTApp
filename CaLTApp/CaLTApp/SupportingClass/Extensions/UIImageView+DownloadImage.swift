//
//  UIImageView+DownloadImage.swift
//  CaLTApp
//
//  Created by Vora, Ravi | Rv | RP on 2022/03/26.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func downloadImage(from url: String) {
        
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]) { result in
            switch result {
            case .success(_): break
            case .failure(_): break
            }
        }
    }
}
