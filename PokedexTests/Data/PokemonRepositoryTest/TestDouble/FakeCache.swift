//
//  FakeCache.swift
//  Pokedex
//
//  Created by jerry on 2/10/26.
//

import Foundation

final class FakeCache: CacheProtocol {
    
    var cache: [URL: Any] = [:]
    
    private(set) var setValueCalledCount: Int = 0
    
    private(set) var valueCalledCount: Int = 0
    private(set) var cacheHit: Int = 0
    
    func setValue<Value>(_ value: Value, forKey key: URL) async {
        cache[key] = value
        setValueCalledCount += 1
    }
    
    func value<Value>(forKey key: URL) async -> Value? {
        valueCalledCount += 1
        guard let cached = cache[key] as? Value else { return nil }
        cacheHit += 1
        return cached
    }
    
}
