//
//  MindManager.swift
//  TDMind
//
//  Created by jojo on 2020/3/13.
//  Copyright © 2020 jojo. All rights reserved.
//

import Foundation

struct GlobalMindNotification {
    static let SelectedNodeChanged: Notification.Name = Notification.Name(rawValue: "com.notification.mind.selectedNodeCHanged")
}

struct GlobalMindUserInfoKey {
    static let SelectedNode: String = "com.userInfo.mind.selectedNode"
}

class MindManager {
    // MARK: Singleton
    static let shared = MindManager()
    private let operatingQueue = DispatchQueue(label: "com.tdmind.operating.queue", attributes: .concurrent)
    private init() {}
    
    // MARK: Selected Node
    private var _currentSelectedNode: MindNode? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: GlobalMindNotification.SelectedNodeChanged, object: nil, userInfo: [GlobalMindUserInfoKey.SelectedNode : self._currentSelectedNode ?? NSNull()])
            }
        }
    }
    var currentSelectedNode: MindNode? {
        get {
            var node: MindNode? = nil
            operatingQueue.sync { node = _currentSelectedNode }
            return node
        }
        set {
            operatingQueue.sync(flags: .barrier) { self._currentSelectedNode = newValue }
        }
    }

}

