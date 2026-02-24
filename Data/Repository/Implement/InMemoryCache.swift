//
//  InMemoryCache.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import Foundation

final actor InMemoryCache: CacheProtocol {
    
    private var cachedData: [String: Data] = [:]
    private let lock = NSLock()
    
    func setValue(_ value: Data, forKey key: String) async {
        lock.lock()
        defer { lock.unlock() }
        cachedData[key] = value
    }
    
    func value(forKey key: String) async -> Data? {
        lock.lock()
        defer { lock.unlock() }
        return cachedData[key]
    }
    
}