//
//  MindPresenting.swift
//  TDMind
//
//  Created by jojo on 2020/3/13.
//  Copyright © 2020 jojo. All rights reserved.
//

import UIKit

protocol Sizing {
    var size: CGSize { get }
}

protocol Resizing {
    func resize(_ size: CGSize)
}

// MARK: Mind Node Presenting
protocol MindNodeSizing: Sizing, Resizing { }
protocol MindNodeStylePresenting {
    var backgroundColor: UIColor { get }
}

protocol MindNodeTextPresenting {
    var title: String { get }
    var font: UIFont { get }
    var textColor: UIColor { get }
}

protocol MindNodePresenting: MindNodeStylePresenting, MindNodeTextPresenting, MindNodeSizing {}


// MARK: Mind Presenting
protocol MindSizing: Sizing { }

protocol MindPresenting: MindSizing {
    var nodePresenting: MindNodePresenting { get }
    var childMindsPresenting: [MindPresenting] { get }
}

