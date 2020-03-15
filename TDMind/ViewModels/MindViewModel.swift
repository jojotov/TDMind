//
//  MindViewModel.swift
//  TDMind
//
//  Created by jojo on 2020/3/11.
//  Copyright © 2020 jojo. All rights reserved.
//

import UIKit


class MindViewModel {
    private(set) var mind: Mind
    private(set) var nodeViewModel: MindNodeViewModel
    private(set) var childViewModels: [MindViewModel] = [] {
        didSet {
            childViewModels.forEach { $0.parentMind = self }
        }
    }
    weak var parentMind: MindViewModel?
    weak var operationgDelegate: MindViewModelOperationDelegate?
    weak var resizeDelegate: MindViewModelResizingDelegate?

    init(_ mind: Mind) {
        self.mind = mind
        self.nodeViewModel = MindNodeViewModel(mind.root)
        self.nodeViewModel.operationDelegate = self
        self.nodeViewModel.resizeDelegate = self

        if let childMinds = mind.root?.childs {
            self.childViewModels = childMinds.map { MindViewModel(Mind($0)) }
        }
    }
    
    convenience init(_ rootNode: MindNode) {
        self.init(Mind(rootNode))
    }
}

extension MindViewModel: MindPresenting {
    var nodePresenting: MindNodePresenting {
        return self.nodeViewModel
    }
    
    var childMindsPresenting: [MindPresenting] {
        return self.childViewModels
    }
    
    var size: CGSize {
        let childHeight =  childMindsPresenting.map { $0.size.height }.reduce(0,+)
        let childWidth =  childMindsPresenting.map { $0.size.width }.reduce(MindLayout.horizontalMindGap,+)
        let size = CGSize(width: childWidth + nodePresenting.size.width, height: childHeight > 0 ? childHeight : nodePresenting.size.height + MindLayout.verticalMindGap)
        return size
    }
}

extension MindViewModel: MindNodeViewModelOperationDelegate {
    func mindNodeViewModel(_ viewModel: MindNodeViewModel, didAddChildMindNode childMindNode: MindNode) {
        if viewModel !== self.nodeViewModel {
            if let parent = self.parentMind {
                parent.mindNodeViewModel(viewModel, didAddChildMindNode: childMindNode)
            }
        }
        let childViewModel = MindViewModel(childMindNode)
        self.childViewModels.append(childViewModel)
        
        if let operationgDelegate = self.operationgDelegate {
            operationgDelegate.mindViewModel(self, didAddChildMind: childViewModel)
        }
    }
    
    func mindNodeViewModel(_ viewModel: MindNodeViewModel, didRemoveChildMindNode childMindNode: MindNode) {
        if viewModel !== self.nodeViewModel {
            if let parent = self.parentMind {
                parent.mindNodeViewModel(viewModel, didRemoveChildMindNode: childMindNode)
            }
        }
        
        let existed = childViewModels.first {
            $0.nodeViewModel.node === childMindNode
        }
        
        guard let remover = existed else { return }
        childViewModels.removeAll { $0 === remover }

        if let operationgDelegate = self.operationgDelegate {
            operationgDelegate.mindViewModel(self, didRemoveChildMind: remover)
        }
    }
}

extension MindViewModel: MindNodeViewModelResizingDelegate {
    func mindNodeViewModelDidResized(_ viewModel: MindNodeViewModel) {
        if let parent = parentMind {
            parent.mindNodeViewModelDidResized(viewModel)
        } else {
            if let delegate = resizeDelegate {
                delegate.mindViewModelDidResized(self)
            }
        }
    }
}
