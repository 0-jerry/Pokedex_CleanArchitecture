//
//  InMemoryCache.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import Foundation

final actor InMemoryCache: CacheProtocol {
    
    private var cachedData: [String: Data] = [:]
    
    func setValue(_ value: Data, forKey key: String) async {
        cachedData[key] = value
    }
    
    func value(forKey key: String) async -> Data? {
        cachedData[key]
    }
    
}
