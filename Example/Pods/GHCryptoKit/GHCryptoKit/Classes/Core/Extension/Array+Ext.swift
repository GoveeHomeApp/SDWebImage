//
//  Array+Ext.swift
//  GHCryptoKit
//
//  Created by sy on 2024/8/8.
//

extension Array {
    subscript(check index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}

extension Array where Element == UInt8 {
    func safe(_ range: Range<Int>) -> [UInt8]? {
        guard range.upperBound <= self.count else { return nil }
        return Array(self[range])
    }
}
