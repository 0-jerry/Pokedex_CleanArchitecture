//
//  InMemoryCache.swift
//  Pokedex
//
//  Created by jerry on 2/9/26.
//

import Foundation

final actor InMemoryCache: CacheProtocol {
    
    private typealias Key = NSString
    
    private var cache: NSCache<Key, WrappedValue> = .init()
    
    func setValue<Value>(_ value: Value, forKey key: URL) async {
        let wrapped = WrappedValue(value)
        let key = convert(key)
        cache.setObject(wrapped, forKey: key)
    }
    
    func value<Value>(forKey key: URL) async -> Value? {
        let key = convert(key)
        let wrapped = cache.object(forKey: key)
        return wrapped?.value as? Value
    }
    
    private func convert(_ url: URL) -> Key {
        url.absoluteString as Key
    }
}

private class WrappedValue {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
}
