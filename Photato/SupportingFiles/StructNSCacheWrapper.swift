//
//  StructNSCacheWrapper.swift
//  Photato
//
//  Created by Alexander Sivko on 27.01.24.
//

import Foundation

final class StructNSCacheWrapper<T>: NSObject {
    let value: T

    init(_ structToCache: T) {
        self.value = structToCache
    }
}
