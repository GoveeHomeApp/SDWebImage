//
//  Data+Ext.swift
//  GHCryptoKit
//
//  Created by sy on 2024/8/8.
//

import Foundation

extension Data {
    var bytesArray: [UInt8] {
        return [UInt8](self)
    }
}

typealias SmallEndBytes = (high: UInt8, low: UInt8)

extension UInt16 {
    /// (high: 高位, low: 低位)
    init(high: UInt8, low: UInt8) {
        self.init(SmallEndBytes(high, low))
    }
    
    /// 通过两个字节高低位
    init(_ bytes: SmallEndBytes) {
        var num: UInt16 = 0
        num |= UInt16(bytes.high) << 8
        num |= UInt16(bytes.low)
        self = num
    }
    
    /// 两个字节（高位，低位）
    var highLowBytes: SmallEndBytes {
        let high = self >> 8
        let low = (self << 8) >> 8
        return (UInt8(high), UInt8(low))
    }
}
