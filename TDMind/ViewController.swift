//
//  ViewController.swift
//  TDMind
//
//  Created by jojo on 2020/3/10.
//  Copyright © 2020 jojo. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var mindView: MindView?
    
    var containerMinX: CGFloat { -(self.view.bounds.size.width * ScaleHelper.scaledValue(2)) }
    var containerMaxX: CGFloat {  (self.view.bounds.size.width * ScaleHelper.scaledValue(3)) }
    var containerMinY: CGFloat { -(self.view.bounds.size.height * ScaleHelper.scaledValue(2)) }
    var containerMaxY: CGFloat { (self.view.bounds.size.height * ScaleHelper.scaledValue(3)) }
    var containerHeight: CGFloat { containerMaxY - containerMinY }
    var containerWidth: CGFloat { containerMaxX - containerMinX }

    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        self.scrollView.addSubview(view)
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect.zero)
        view.showsVerticalScrollIndicator = true
        view.showsHorizontalScrollIndicator = true
        view.bounces = false
        view.minimumZoomScale = ScaleValue.min
        view.maximumZoomScale = ScaleValue.max
        
        view.delegate = self
        view.contentSize = CGSize(width: containerWidth, height: containerHeight)
        self.view.addSubview(view)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mindView = testMindView
        containerView.addSubview(mindView!)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layout()
    }

    @IBAction func removeAction(_ sender: Any) {
        MindManager.shared.currentSelectedNode?.removeFromParent()
    }
    
    @IBAction func addAction(_ sender: Any) {
        MindManager.shared.currentSelectedNode?.addChildNode(MindNode("added"))
        
    }
    
    @IBAction func resetAction(_ sender: Any) {
        reloadMindView()
    }
    
    var testMindView: MindView {
        let testData: [String:Array<MindNodeDataConvertible>] = [
            "firstNode" : ["secondNode", "thirdNode" ]
        ]
        let mindNode = MindNode(testData)
        let mind = Mind(mindNode)
        let mindViewModel = MindViewModel(mind)
        let mindView: MindView = MindView(frame:.zero)
        mindView.viewModel = mindViewModel
        return mindView
    }
    
    func layout() {
        let contentSize = CGSize(width: containerWidth, height: containerHeight)
        containerView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        
        let centerOffsetX = (contentSize.width/2) - (scrollView.bounds.size.width/2);
        let centerOffsetY = (contentSize.height/2) - (scrollView.bounds.size.height/2);

        scrollView.setContentOffset(CGPoint(x: centerOffsetX, y: centerOffsetY), animated: false)
        
        if let mindView = mindView {
            mindView.resize()
            let top: CGFloat =  (view.bounds.size.height/2) - (mindView.bounds.size.height/2)
            let left: CGFloat =  (view.bounds.size.width/2) - (mindView.bounds.size.width/2)
            mindView.frame = CGRect(x: centerOffsetX + left, y: centerOffsetY + top, width: mindView.bounds.size.width, height: mindView.bounds.size.height)
        }
    }
    
    func reloadMindView() {
        if mindView?.superview != nil {
            mindView?.removeFromSuperview()
        }
        mindView = testMindView
        containerView.addSubview(mindView!)
        
        scrollView.setZoomScale(1, animated: false)
        layout()
    }
}


extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print("Zoom: \(scrollView.zoomScale)")
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return containerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       _ = mindView?.endEditing(true)
    }
}
