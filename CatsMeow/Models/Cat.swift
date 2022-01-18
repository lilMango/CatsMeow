//
//  Cat.swift
//  CatsMeow
//
//  Created by Miguel Paysan on 1/17/22.
//

import Foundation


struct Cat: Codable, Hashable {
    let id: String
    let createdAt: Date
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, tags
        case createdAt = "created_at"
        
    }
    var urlStr: String {
        return "\(K.CatsAPI.baseUrl)/cat/\(id)"
    }

    var fullUrl: URL {
        return URL(string: urlStr )!
    }
    
    var isGif: Bool {
        return !tags.filter { $0.contains("gif")}.isEmpty
    }
    
    public static func getDummyCat() -> Cat {
        return Cat(id: "hiii", createdAt:Date.now, tags:[])
    }

    // Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }    
}
