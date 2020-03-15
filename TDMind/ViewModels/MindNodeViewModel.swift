//
//  MindNodeViewModel.swift
//  TDMind
//
//  Created by jojo on 2020/3/14.
//  Copyright © 2020 jojo. All rights reserved.
//


import UIKit

enum MindNodeStyle {
    case root
    case `default`
}

extension MindNodeStyle: MindNodeStylePresenting {
    var font: UIFont {
        switch self {
        case .root:
            return UIFont.boldSystemFont(ofSize: 24)
        case .default:
            return UIFont.systemFont(ofSize: 18)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .root:
            return UIColor.white
        case .default:
            return UIColor.label
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .root:
            return UIColor.systemIndigo
        case .default:
            return UIColor.systemGray6
        }
    }
    
    var selectedBorderColor: UIColor {
        return UIColor.systemPink
    }
}


@objc class MindNodeState: NSObject {
    @objc dynamic var isSelected: Bool = false
    
}

class MindNodeViewModel {
    private(set) var style: MindNodeStyle = .default
    private(set) var node: MindNode?
    private(set) var state: MindNodeState = MindNodeState()
    
    weak var operationDelegate: MindNodeViewModelOperationDelegate?
    weak var resizeDelegate: MindNodeViewModelResizingDelegate?
    
    private var _size: CGSize = CGSize(width: 96, height: 40)

    init(_ node: MindNode?) {
        self.node = node
        node?.operationDelegate = self
        
        if node?.parent == nil {
            style = .root
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.globalSelectedNodeDidChanged), name: GlobalMindNotification.SelectedNodeChanged, object: nil)
    }
}

extension MindNodeViewModel: MindNodePresenting {
    var title: String {
        guard let node = self.node else { return "" }
        return node.key
    }
    
    var font: UIFont {
        style.font
    }
    
    var backgroundColor: UIColor {
        style.backgroundColor
    }
    
    var selectedBorderColor: UIColor {
        style.selectedBorderColor
    }
    
    var textColor: UIColor {
        style.textColor
    }
    
    var size: CGSize {
        _size
    }
        
    func resize(_ size: CGSize) {
        _size = size
        notifyResizing()
    }
}

extension MindNodeViewModel {
    func notifyResizing() {
        if let delegate = resizeDelegate {
            delegate.mindNodeViewModelDidResized(self)
        }
    }
}

extension MindNodeViewModel: MindNodeEventHandlable {
    func handleSelectedEvent(_ sender: MindNodeEventSender, _ isSelected: Bool) {
        state.isSelected = isSelected
        MindManager.shared.currentSelectedNode = self.node
    }
}


extension MindNodeViewModel {
    @objc func globalSelectedNodeDidChanged() {
        self.state.isSelected = MindManager.shared.currentSelectedNode === self.node
    }
}

extension MindNodeViewModel: MindNodeOperationDelegate {
    func mindNode(_ mindeNode: MindNode, didAddChildNode childNode: MindNode) {
        if let delegate = self.operationDelegate {
            delegate.mindNodeViewModel(self, didAddChildMindNode: childNode)
        }
    }
    
    func mindNode(_ mindeNode: MindNode, didRemoveChildNode childNode: MindNode) {
        if let delegate = self.operationDelegate {
            delegate.mindNodeViewModel(self, didRemoveChildMindNode: childNode)
        }
    }
}
