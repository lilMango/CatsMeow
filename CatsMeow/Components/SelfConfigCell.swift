//
//  SelfConfigCell.swift
//  CatsMeow
//
//  Created by Miguel Paysan on 1/18/22.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with cat: Cat)
}
