//
//  SecondMorphViewController.swift
//  SampleApp
//
//  Created by Dermot O'Sullivan on 23/1/2023.
//

import UIKit
import MorphAnimator

class SecondMorphViewController: UIViewController {
    
    var tapRecognizer: UITapGestureRecognizer!

    var circle: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 50),
            view.widthAnchor.constraint(equalToConstant: 50)
        ])
        view.layer.cornerRadius = 25
        return view
    }()
    
    var square: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 150),
            view.widthAnchor.constraint(equalToConstant: 150)
        ])
        return view
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        [square, circle, textLabel].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            square.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 25),
            square.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25),
            
            circle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            circle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 300),
            
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])

        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func didTap() {
        navigationController?.popViewController(animated: .morph)
    }
}

extension SecondMorphViewController: MorphAnimatorViewSource {
    
    func viewsOfInterest(forTransition key: Morph.TransitionKey, transit: Morph.Transit) -> [String : UIView]? {
        ["square" : square,
         "circle" : circle,
         "label": textLabel]
    }
}
