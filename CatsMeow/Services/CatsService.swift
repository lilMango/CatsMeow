//
//  CatsService.swift
//  CatsMeow
//
//  Created by Miguel Paysan on 1/17/22.
//

import Foundation

protocol CatsProtocol {
    
    func getBaseUrl() -> String
    func getRandomCat() -> String
    func getCatTag() -> Void
    func getCats(with tags:String, skipTo cursor:Int, limit: Int) -> String
    
}

class CatsService: CatsProtocol {
    static var shared = CatsService()
    
    func getBaseUrl() -> String {
        return K.CatsAPI.baseUrl
    }
    
    func getRandomCat() -> String {
        return getBaseUrl() + "/cat?json=true"
    }
    
    func getCatTag() -> Void {
        
    }
    
    func getCats(with tags:String, skipTo cursor:Int = 0, limit: Int = 10) -> String {
        return "\(K.CatsAPI.baseUrl)/api/cats?tags=\(tags)&skip=\(cursor)&limit=\(limit)"
    }
}
