//
//  MindNodeView.swift
//  TDMind
//
//  Created by jojo on 2020/3/11.
//  Copyright © 2020 jojo. All rights reserved.
//

import UIKit

class MindNodeObserver: NSObject {
    private(set) var stateObservation: NSKeyValueObservation?

    @objc var state: MindNodeState

    init(_ node: MindNodeViewModel) {
        self.state = node.state
        super.init()
    }

    func selectedStateChanged(_ block: @escaping (Bool, Bool) -> Void) -> Self {
        stateObservation = state.observe(\.isSelected, options: [.old, .new]) {
            (object, change) in
            block(change.oldValue!,change.newValue!)
        }
        
        return self
    }
    
    func end() { }
}

class MindNodeView: UIButton {
    
    init(frame: CGRect, viewModel: MindNodeViewModel?) {
        super.init(frame: frame)
        self.viewModel = viewModel
        setup()
    }
    
    convenience init(_ viewModel: MindNodeViewModel?) {
        self.init(frame:.zero, viewModel:viewModel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: Properties
    lazy var textField: UITextField = {
        let textField = NoTappingTextFiled(frame: .zero)
        textField.forwardingTarget = self
        textField.backgroundColor = UIColor.clear
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        addSubview(textField)
        return textField
    }()
    
    
    var viewModel: MindNodeViewModel? {
        didSet {
            setupObserver()
            refresh()
        }
    }
    
    var presenting: MindNodePresenting? {
        guard let viewModel = self.viewModel else { return nil }
        return viewModel
    }
    
    private var nodeObserver: MindNodeObserver?

    func refresh() {
        guard let presentable = self.presenting else {
            return
        }
        updateUI(presentable)
    }
    
    // MARK: Setup
    func setup() {
        addTarget(self, action: #selector(nodeButtonClicked), for: .touchUpInside)
        addTarget(self, action: #selector(nodeButtonDoubleClicked(_:event:)), for: .touchDownRepeat)
        setupObserver()
    }
    
    func setupObserver() {
        guard let nodeViewModel = self.viewModel else { return }
        nodeObserver = MindNodeObserver(nodeViewModel)
        nodeObserver?.selectedStateChanged { [weak self] from, to in
            self?.isSelected = to
        }.end()
    }
}

// MARK: UI updating
extension MindNodeView {
    private struct MindNodeLayout {
        static let textFieldLeading: CGFloat = 10
        static let textFieldTop: CGFloat = 10
    }
    
    func updateUI(_ presentable: MindNodePresenting) {
        backgroundColor = presentable.backgroundColor
        layer.cornerRadius = 4
        
        textField.font = presentable.font
        textField.text = presentable.title
        textField.textColor = presentable.textColor
        
        resize()
    }
    
    func resize() {
        guard let size = textField.attributedText?.size() else { return }
        self.viewModel?.resize(CGSize(width: size.width + 2 * MindNodeLayout.textFieldLeading, height: size.height + 2 * MindNodeLayout.textFieldTop))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = CGRect(x: MindNodeLayout.textFieldLeading,
                                 y: MindNodeLayout.textFieldTop,
                                 width: bounds.size.width - 2 * MindNodeLayout.textFieldLeading,
                                 height: bounds.size.height - 2 * MindNodeLayout.textFieldTop)
    }
}

// MARK: Event Handle
extension MindNodeView: MindNodeEventSender {
    var handler: MindNodeEventHandlable? {
        get {
            guard let viewModel = self.viewModel else { return nil }
            return viewModel
        }
    }
    
    @objc func nodeButtonClicked() {
        handler?.handleSelectedEvent(self, !self.isSelected)
    }
    
    @objc func nodeButtonDoubleClicked(_ sender: UIButton, event: UIEvent) {
        let touch: UITouch = event.allTouches!.first!
        if (touch.tapCount != 2) {
            return
        }
        textField.becomeFirstResponder()
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.layer.borderColor = UIColor.black.cgColor
                self.layer.borderWidth = 2
            } else {
                self.layer.borderColor = nil
                self.layer.borderWidth = 0
            }
        }
    }
}

// MARK: Text Field
extension MindNodeView: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        resize()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return endEditing(true)
    }
}

extension MindNodeView {
    override func endEditing(_ force: Bool) -> Bool {
        return textField.endEditing(force)
    }
}
