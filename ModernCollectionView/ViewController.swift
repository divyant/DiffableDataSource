//
//  ViewController.swift
//  ModernCollectionView
//
//  Created by Divyant on 28/05/23.
//

import UIKit

enum Section {
    case main
}

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var dataSource = makeDataSource()
    var maindataArray: [ProductModel] = []
    var filteredDataArray: [ProductModel] = []

    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ProductModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ProductModel>
    
    var viewModel = ProductViewModel()
    fileprivate func configureCollectionView() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, environment in
            let layoutSize = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(0.5), heightDimension: NSCollectionLayoutDimension.absolute(250))
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let layoutGroupSize = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, repeatingSubitem: item, count: 2)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10
            return section
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureCollectionView()
        getDataForView()
        applySnapshot(products: maindataArray)
    }
    
    func configureSearchController() {
      searchController.searchResultsUpdater = self
      searchController.obscuresBackgroundDuringPresentation = false
      searchController.searchBar.placeholder = "Search Products"
      navigationItem.searchController = searchController
      definesPresentationContext = true
    }
    
    fileprivate func getDataForView() {
        viewModel.fetchProductsData{ result in
            switch result {
            case .success(let productData):
                self.maindataArray = productData
                self.filteredDataArray = self.maindataArray
                self.applySnapshot(products: self.maindataArray)
            case .failure(let error):
                break
            }
        }
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCollectionViewCell else  {
                return UICollectionViewCell()
            }
            cell.product = self.filteredDataArray[indexPath.row]
            return cell
        }
        return dataSource
    }
    
    func applySnapshot(products: [ProductModel],animatingDiffreces: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(products)
//            sections.forEach { section in
//              snapshot.appendItems(section.videos, toSection: section)
//            }
            self?.dataSource.apply(snapshot, animatingDifferences: animatingDiffreces)
        }
    }

}


extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredDataArray = filterProducts(searchString: searchController.searchBar.text)
            self.applySnapshot(products: self.filteredDataArray)
    }
    
    func filterProducts(searchString: String?) -> [ProductModel] {
        guard let searchString = searchString, searchString.count > 0  else {
            return self.maindataArray
        }
        
        let filteredArray = self.maindataArray.filter { item in
            if let title = item.title?.lowercased(), title.contains(searchString.lowercased()) {
                return true
            }
            return false

        }
        
        return filteredArray
         
    }
}
