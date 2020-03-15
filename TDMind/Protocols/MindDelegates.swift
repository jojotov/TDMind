//
//  MindDelegates.swift
//  TDMind
//
//  Created by jojo on 2020/3/14.
//  Copyright © 2020 jojo. All rights reserved.
//

import Foundation

protocol MindNodeOperationDelegate: class {
    func mindNode(_ mindeNode: MindNode, didAddChildNode childNode: MindNode)
    func mindNode(_ mindeNode: MindNode, didRemoveChildNode childNode: MindNode)
}

protocol MindNodeViewModelOperationDelegate: class {
    func mindNodeViewModel(_ viewModel: MindNodeViewModel, didAddChildMindNode childMindNode: MindNode)
    func mindNodeViewModel(_ viewModel: MindNodeViewModel, didRemoveChildMindNode childMindNode: MindNode)
}

protocol MindNodeViewModelResizingDelegate: class {
    func mindNodeViewModelDidResized(_ viewModel: MindNodeViewModel)
}

protocol MindViewModelOperationDelegate: class {
    func mindViewModel(_ viewModel: MindViewModel, didAddChildMind childMind: MindViewModel)
    func mindViewModel(_ viewModel: MindViewModel, didRemoveChildMind childMind: MindViewModel)
}

protocol MindViewModelResizingDelegate: class {
    func mindViewModelDidResized(_ viewModel: MindViewModel)
}
