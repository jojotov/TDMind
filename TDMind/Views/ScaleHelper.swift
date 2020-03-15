//
//  ScaleHelper.swift
//  TDMind
//
//  Created by jojo on 2020/3/15.
//  Copyright © 2020 jojo. All rights reserved.
//

import UIKit

struct ScaleValue {
    static let min: CGFloat = 0.2
    static let max: CGFloat = 2
    static let initial: CGFloat = 1
}

struct ScaleHelper<T> {
    static func scaledValue(_ origin: T) -> T {
        return origin
    }
}

extension ScaleHelper where T == CGFloat {
    static func scaledValue(_ origin: CGFloat) -> CGFloat {
        return origin / ScaleValue.min
    }
}
