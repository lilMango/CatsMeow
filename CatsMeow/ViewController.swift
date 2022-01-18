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
        
        // Do any additional setup after loading the view.
        DispatchQueue.global().async {
            do {
                print(CatsService.shared.getRandomCat())
                let url = URL(string: CatsService.shared.getCats(with: "gif", skipTo: 0, limit: 20))!
                let data = try Data(contentsOf: url)
                //2016-06-07T17:20:00Z
                //2021-11-11T10:05:13.645Z
//                let jsonString = """
//                {
//                    "id": "618cead9536db3001894b4f2",
//                    "created_at": "2021-11-11T10:05:13.645Z",
//                    "tags": [
//                        "nelut",
//                        "happy",
//                        "gixf"
//                    ],
//                    "url": "/cat/618cead9536db3001894b4f2"
//                }
//                """
//                let data = Data(jsonString.utf8)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
                
//                let decodedCat = try decoder.decode(Cat.self, from: data)
                let decodedCat = try decoder.decode([Cat].self, from: data)
                
                DispatchQueue.main.async {
//                    self.cats = [decodedCat]
                    self.cats = decodedCat
//                    print(self.cats[0].createdAt, "isGif: \(decodedCat.isGif)")
                    self.configureLayoutHierarchy()
                    self.configureDataSource()
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
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
//        collectionView.register(MyCell.self, forCellWithReuseIdentifier: MyCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
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
//            cell.textLabel.text = "\(identifier)"
            return cell
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Cat>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cats, toSection: .main)
    
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}



