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
    
    let firstDot: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        return view
    }()
    
    let secondDot: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(iconView)
        iconView.addSubview(firstDot)
        iconView.addSubview(secondDot)
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80),
            
            firstDot.centerXAnchor.constraint(equalTo: iconView.centerXAnchor, constant: -12),
            firstDot.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            
            secondDot.centerXAnchor.constraint(equalTo: iconView.centerXAnchor, constant: 12),
            secondDot.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
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
    func viewsOfInterest(forTransition key: Morph.TransitionKey, transit: Morph.Transit) -> [String : UIView]? {
        ["firstDot": firstDot,
         "secondDot": secondDot]
    }
    
    func portalView() -> UIView? {
        iconView
    }
}
