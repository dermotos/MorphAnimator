//
//  SecondPortalViewController.swift
//  SampleApp
//
//  Created by Dermot O'Sullivan on 23/1/2023.
//

import UIKit
import MorphAnimator

class SecondPortalViewController: UIViewController {

    var tapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapRecognizer)
    }
}

extension SecondPortalViewController: MorphAnimatorViewSource {
    @objc
    private func didTap() {
        let secondPortalViewController = SecondPortalViewController()
        navigationController?.popViewController(animated: .morph)
    }
}
