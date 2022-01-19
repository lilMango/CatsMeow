//
//  ViewController.swift
//  CatsMeow
//
//  Created by Miguel Paysan on 1/17/22.
//

import UIKit

class ViewController: UIViewController {
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Cat>!
    
    var cats = [Cat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Find a cat type"
        navigationItem.searchController = search
        
        self.configureLayoutHierarchy()
        self.configureDataSource()
        
        // Do any additional setup after loading the view.
        DispatchQueue.global().async {
            do {
                print(CatsService.shared.getRandomCat())
                let url = URL(string: CatsService.shared.getCatsUrlString(with: "gif", skipTo: 0, limit: 20))!
                let data = try Data(contentsOf: url)

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                
                let decodedCats = try decoder.decode([Cat].self, from: data)
                
                DispatchQueue.main.async {
                    self.cats = decodedCats
                    self.updateDataSource()
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    private func configureLayoutHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        // resize collectionView to view controller edges. one-line  Alternative to AutoLayout Constraints
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
        // Data Cell
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        
        view.addSubview(collectionView)
        
        // Delegate methods for user actions
        collectionView.delegate = self
        
    }
    
    /**
                createLayout() specifies spacing of the elements with the view
     */
    private func createLayout() -> UICollectionViewLayout {
        // The LayoutGroup(:subitems, :count) will override this itemSize
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                                            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),                                            heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        // create diffable datasource, AND define cell assignment via this closure
        dataSource = UICollectionViewDiffableDataSource<Section, Cat>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Cat) -> UICollectionViewCell? in
            
            // A constructor that passes collection view as input, and returns cell as output
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier, for: indexPath) as? ItemCell
            else {
                fatalError("Can't create new cell")
            }
            cell.configure(with: identifier)
            return cell
        }
    }
    private func updateDataSource() {
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cat>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cats, toSection: .main)
    
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    // Click Data Cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Clicked: ", cats[indexPath.row].urlStr)
        cats[indexPath.row].toggleNegativeFilter()
        updateDataSource()
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard var searchText = searchController.searchBar.text, searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else {
            return
        }
        
        searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        print("CHaging TEXT")
        
        // TODO: Use Combine to throttle calls to server
        // Do any additional setup after loading the view.
        DispatchQueue.global().async {
            do {

                let url = URL(string: CatsService.shared.getCatsUrlString(with: searchText, skipTo: 0, limit: 20))!
                let data = try Data(contentsOf: url)

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                
                let decodedCats = try decoder.decode([Cat].self, from: data)
                
                DispatchQueue.main.async {
                    self.cats = decodedCats
                    self.updateDataSource()
                }
                
            } catch {
                print(error)
            }
        }
    }
    
}




