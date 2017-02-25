//
//  ViewController.swift
//  SnowFalling-Sample
//
//  Created by pixyzehn on 2/13/15.
//  Copyright (c) 2015 pixyzehn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sfv: SnowFallingView?
    
    enum State {
        case snowing
        case stoping
    }
    
    var currentState: State = .snowing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sfv = SnowFallingView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width * 2, height: view.frame.size.height * 2))
        view.addSubview(sfv!)
        sfv?.startSnow()
        
        // Triple tap action
        let tripleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTripleTap))
        tripleTap.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTap)
    }
    
    func handleTripleTap() {
        if currentState == .snowing {
            sfv?.stopSnow()
            currentState = .stoping
        } else {
            sfv?.startSnow()
            currentState = .snowing
        }
    }
    
}
