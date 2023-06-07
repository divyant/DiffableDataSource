//
//  ProductApiHandler.swift
//  ModernCollectionView
//
//  Created by Divyant on 28/05/23.
//

import Foundation

struct ProductData: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
}


struct ProductApiHandler {
    
    func getProductData(completion: @escaping (Result<ProductData, Error>) -> Void) {
        let url = URL(string: "https://dummyjson.com/products")!
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "Invalid response", code: 0)
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let productsData = try JSONDecoder().decode(ProductData.self, from: data)
                    completion(.success(productsData))
                } catch (let error) {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
