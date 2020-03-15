//
//  NoTappingTextFiled.swift
//  TDMind
//
//  Created by jojo on 2020/3/15.
//  Copyright © 2020 jojo. All rights reserved.
//

import UIKit

/// Block the tapping event of text field and forward the event to target responder if existed.
class NoTappingTextFiled: UITextField {
    weak var forwardingTarget: UIView? // try forwarding all events to the target
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let target = forwardingTarget else { return super.hitTest(point, with: event) }
        if let targetView = target.hitTest(point, with: event) { return targetView }
        return super.hitTest(point, with: event)
    }
}
