//
//  ProductsViewModel.swift
//  ModernCollectionView
//
//  Created by Divyant on 28/05/23.
//

import Foundation


class ProductViewModel {
    
    var apiHandler: ProductApiHandler = ProductApiHandler()
    
    func fetchProductsData(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        apiHandler.getProductData { result in
            switch result {
            case .success(let productData):
                var dataArray: [ProductModel] = []
                for item in productData.products {
                    var product = ProductModel()
                    product.title = item.title
                    product.subTitle = "\(item.price)"
                    if item.images.count > 0 {
                        product.imageLink = item.images[0]
                    }
                    print("Product:\(product)")
                    dataArray.append(product)
                }
                completion(.success(dataArray))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
}
