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
    
    let firstDot: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    let secondDot: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        view.addSubview(firstDot)
        view.addSubview(secondDot)
        
        NSLayoutConstraint.activate([
            firstDot.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            firstDot.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            
            secondDot.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            secondDot.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
        ])
       
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapRecognizer)
    }
}

extension SecondPortalViewController: MorphAnimatorViewSource {
    @objc
    private func didTap() {
        navigationController?.popViewController(animated: .morph)
    }
    
    func viewsOfInterest(forTransition key: Morph.TransitionKey, transit: Morph.Transit) -> [String : UIView]? {
        ["firstDot": firstDot,
         "secondDot": secondDot]
    }
}
