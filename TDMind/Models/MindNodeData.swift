//
//  MindNodeData.swift
//  TDMind
//
//  Created by jojo on 2020/3/11.
//  Copyright © 2020 jojo. All rights reserved.
//

import Foundation

protocol MindNodeDataConvertible {
    func asKey() -> String
    func asDictionary() -> Dictionary<String, Array<MindNodeDataConvertible>>
}

extension String: MindNodeDataConvertible {
    func asKey() -> String {
        return self
    }
    
    func asDictionary() -> Dictionary<String, Array<MindNodeDataConvertible>> {
        return [self:[]]
    }
}

extension Dictionary: MindNodeDataConvertible where Key == String, Value == Array<MindNodeDataConvertible> {
    func asKey() -> String {
        guard let first = self.first else { return "" }
        return first.key
    }
    
    func asDictionary() -> Dictionary<String, Array<MindNodeDataConvertible>> {
        return self
    }
}
