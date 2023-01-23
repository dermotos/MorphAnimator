//
//  FirstPortalViewController.swift
//  SampleApp
//
//  Created by Dermot O'Sullivan on 23/1/2023.
//

import UIKit
import MorphAnimator

class FirstPortalViewController: UIViewController {
    
    var tapRecognizer: UITapGestureRecognizer!
    
    let iconView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80)
        ])
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        iconView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func didTap() {
        let secondPortalViewController = SecondPortalViewController()
        navigationController?.pushViewController(secondPortalViewController, animated: .morph)
    }
}

extension FirstPortalViewController: MorphAnimatorViewSource {
    func portalView() -> UIView? {
        iconView
    }
}
