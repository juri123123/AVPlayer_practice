//
//  ViewController.swift
//  AVPlayer_practice
//
//  Created by 최주리 on 7/9/24.
//

import UIKit

public class BaseViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setAttribute()
        addView()
        setLayout()
    }

    func setAttribute() { }
    
    func addView() { }
    
    func setLayout() { }
}

