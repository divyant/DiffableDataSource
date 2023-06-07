//
//  ProductsModel.swift
//  ModernCollectionView
//
//  Created by Divyant on 28/05/23.
//

import Foundation


struct ProductModel: Hashable {
    var id = UUID()
    var title: String?
    var subTitle: String?
    var imageLink: String?
    
    init(title: String? = nil, subTitle: String? = nil , imageLink: String? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.imageLink = imageLink
  }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        lhs.id == rhs.id
    }
}


