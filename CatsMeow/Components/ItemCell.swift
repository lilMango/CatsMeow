//
//  SquareCell.swift
//  CatsMeow
//
//  Created by Miguel Paysan on 1/17/22.
//

import UIKit
import SDWebImage

class ItemCell: UICollectionViewCell, SelfConfiguringCell {
    static let reuseIdentifier: String = "ItemCell"

    let name = UILabel()
    let subtitle = UILabel()
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 0
        imageView.clipsToBounds = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        
        contentView.addSubview(imageView)
        let inset = CGFloat(1)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }

    func configure(with cat: Cat) {
        name.text = cat.id
        subtitle.text = cat.urlStr
        print(cat.urlStr)
        let placeholderImg = UIImage(systemName: "icloud.and.arrow.down")

        imageView.sd_setImage(with: cat.fullUrl, placeholderImage: placeholderImg)
    }

    required init?(coder: NSCoder) {
        fatalError("Just… no")
    }
}
