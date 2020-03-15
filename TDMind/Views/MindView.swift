//
//  MindView.swift
//  TDMind
//
//  Created by jojo on 2020/3/11.
//  Copyright © 2020 jojo. All rights reserved.
//

import UIKit

class MindView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    // MARK: Properties
    lazy var headButton: MindNodeView = {
        let button = MindNodeView()
        return button
    }()
    
    var childMindView: [MindView] = [] {
        didSet {
            childMindView.forEach { $0.parentMindView = self }
        }
    }
    
    weak var parentMindView: MindView?
    
    var viewModel: MindViewModel? {
        didSet {
            self.headButton.viewModel = viewModel?.nodeViewModel
            viewModel?.operationgDelegate = self
            viewModel?.resizeDelegate = self
            reloadUI()
        }
    }
    
    var presenting: MindPresenting? {
        guard let viewModel = self.viewModel else { return nil }
        return viewModel
    }
}

extension MindView {
    private func setup() {
        self.addSubview(self.headButton)
    }
    
    private func reloadUI() {
        #warning("TODO: add line")
        guard let viewModel = self.viewModel else { return }
        resetChildMindView()
        self.childMindView = viewModel.childViewModels.map {
            let mindView = MindView(frame: CGRect.zero)
            mindView.viewModel = $0
            addSubview(mindView)
            return mindView
        }
        
        let rect = self.frame
        self.frame = CGRect(origin: rect.origin, size: viewModel.size)
    }
    
    private func resetChildMindView() {
        self.childMindView.forEach {
            if $0.superview != nil {
                $0.removeFromSuperview()
            }
        }
    }
    
    private func addChildMindViews(_ mindViews: [MindView]) {
        let existedChildMindViewModels = childMindView.compactMap { $0.viewModel }
        let childMindViewNeedsAdded: [MindView] = mindViews.compactMap { mindView in
            if existedChildMindViewModels.contains(where: { existed in
                mindView.viewModel === existed
            }) {
                return nil
            }
            return mindView
        }

        if childMindViewNeedsAdded.isEmpty { return }
    
        self.childMindView.append(contentsOf: childMindViewNeedsAdded.map {
            addSubview($0)
            return $0
        })
        
       resize()
        
        if let parent = self.parentMindView {
            parent.resize()
        }
    }

    private func addChildMindView(_ mindView: MindView) {
        addChildMindViews([mindView])
    }
    
    private func removeChildMindView(_ mindViews: [MindView]) {
        let existedChildMindViewModels = childMindView.compactMap { $0.viewModel }
        let childMindViewNeedsRemoved: [MindView] = mindViews.compactMap { mindView in
            if existedChildMindViewModels.contains(where: { existed in
                mindView.viewModel === existed
            }) {
                return mindView
            }
            return nil
        }
        
        if childMindViewNeedsRemoved.isEmpty { return }
        childMindViewNeedsRemoved.forEach { view in
            childMindView.removeAll { $0 === view }
            if view.superview != nil { view.removeFromSuperview() }
        }
        
        resize()
        
        if let parent = self.parentMindView {
                parent.resize()
        }
    }
    
    private func removeChildMindView(_ mindView: MindView) {
        removeChildMindView([mindView])
    }
    
    private func removeChildMindView(_ viewModel: MindViewModel) {
        let existed = childMindView.compactMap { return $0.viewModel === viewModel ? $0 : nil }
        if existed.count > 0 {
            removeChildMindView(existed)
        }
    }
    
    func resize() {
        if let presenting = self.presenting {
            let rect = self.frame
            self.frame = CGRect(origin: rect.origin, size: presenting.size)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let presenting = self.presenting else { return }
        self.headButton.frame = CGRect(x: 0,
                                       y: (self.bounds.size.height - presenting.nodePresenting.size.height) / 2,
                                       width: presenting.nodePresenting.size.width,
                                       height: presenting.nodePresenting.size.height)

        var childMindViewMaxY: CGFloat = 0
        for mindView in self.childMindView {
            guard let childPresenting = mindView.presenting else {
                continue
            }
            mindView.frame = CGRect(x: self.headButton.frame.maxX + MindLayout.horizontalMindGap,
                              y: childMindViewMaxY,
                              width: childPresenting.size.width,
                              height: childPresenting.size.height)
            childMindViewMaxY += mindView.bounds.height
        }
    }
}

extension MindView: MindViewModelOperationDelegate {
    func mindViewModel(_ viewModel: MindViewModel, didAddChildMind childMind: MindViewModel) {
        let mindView = MindView(frame: CGRect.zero)
        mindView.viewModel = childMind
        addChildMindView(mindView)
    }
    
    func mindViewModel(_ viewModel: MindViewModel, didRemoveChildMind childMind: MindViewModel) {
        if viewModel === self.viewModel {
            removeChildMindView(childMind)
            return
        }
        
        if let parent = self.parentMindView {
            parent.mindViewModel(viewModel, didRemoveChildMind: childMind)
        }
    }
}

extension MindView {
    override func endEditing(_ force: Bool) -> Bool {
        _ = headButton.endEditing(force)
        childMindView.forEach { _ = $0.endEditing(force) }
        return true
    }
}

extension MindView: MindViewModelResizingDelegate {
    func mindViewModelDidResized(_ viewModel: MindViewModel) {
        guard viewModel === self.viewModel else {
            if let parent = parentMindView {
                parent.mindViewModelDidResized(viewModel)
            }
            return
        }
        
        resize()
    }
}
