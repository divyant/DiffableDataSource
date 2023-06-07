//
//  ProductCollectionViewCell.swift
//  ModernCollectionView
//
//  Created by Divyant on 28/05/23.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    var product: ProductModel? {
      didSet {
          titleLabel.text = product?.title
          subtitleLabel.text = product?.subTitle
          if let url = product?.imageLink {
              thumbnailView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(systemName: "star.fill"))
          }
      }
    }
  }

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {


    func loadImageUsingCacheWithURLString(_ URLString: String, placeHolder: UIImage?) {

        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }

        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async { [weak self] in
                        self?.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self?.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}

