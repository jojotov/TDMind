//
//  Mind.swift
//  TDMind
//
//  Created by jojo on 2020/3/11.
//  Copyright © 2020 jojo. All rights reserved.
//

import Foundation

protocol MindNodeOperatable {
    func addChildNode(_ node: MindNode?)
    func removeChildNode(_ node: MindNode?)
    func removeFromParent()
}

class MindNode {
    var key: String
    var childs: [MindNode] = []
    var parent: MindNode?
    weak var operationDelegate: MindNodeOperationDelegate?
    
    init(_ data: MindNodeDataConvertible) {
        self.key = data.asKey()
        if let first = data.asDictionary().first {
            self.childs = first.value.map {
                let node = MindNode($0)
                node.parent = self
                return node
            }
        }
    }
    
    func isEmpty() -> Bool {
        return self.childs.isEmpty && self.key.count == 0
    }

    func isRoot() -> Bool {
        return self.parent == nil
    }
}

extension MindNode: MindNodeOperatable {
    func addChildNode(_ node: MindNode?) {
        guard let node = node else { return }

        node.parent = self
        self.childs.append(node)
        
        if let delegate = self.operationDelegate {
            delegate.mindNode(self, didAddChildNode: node)
        }
    }
    
    func removeChildNode(_ node: MindNode?) {
        guard let node = node else { return }
        childs.removeAll(where: {$0 === node })
    }
    
    func removeFromParent() {
        guard let parent = self.parent else { return }
        parent.removeChildNode(self)
        
        if let delegate = parent.operationDelegate {
            delegate.mindNode(parent, didRemoveChildNode: self)
        }
    }
}

class Mind {
    var root: MindNode?
    
    init(_ root: MindNode) {
        self.root = root
    }
    
    func isEmpty() -> Bool {
        guard let root = root else { return true }
        return root.isEmpty()
    }
}

extension Mind: MindNodeOperatable {
    func addChildNode(_ node: MindNode?) {
        root?.addChildNode(node)
    }
    
    func removeChildNode(_ node: MindNode?) {
        root?.removeChildNode(node)
    }
    
    func removeFromParent() {
        root?.removeFromParent()
    }
}
