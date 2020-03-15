//
//  MindActionHandler.swift
//  TDMind
//
//  Created by jojo on 2020/3/13.
//  Copyright © 2020 jojo. All rights reserved.
//

import Foundation

protocol MindActionHandlable {
    func handleAddMindNodeAction(_ node: MindNode)
    func handleRemoveMindNodeAction(_ node: MindNode)
}

protocol MindNodeEventHandlable {
    func handleSelectedEvent(_ sender: MindNodeEventSender, _ isSelected: Bool)
}

protocol MindNodeEventSender {
    var handler: MindNodeEventHandlable? { get }
}
