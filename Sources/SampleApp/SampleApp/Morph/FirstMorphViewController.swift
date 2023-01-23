//
//  FirstMorphViewController.swift
//  SampleApp
//
//  Created by Dermot O'Sullivan on 23/1/2023.
//

import UIKit
import MorphAnimator

class FirstMorphViewController: UIViewController {
    
    var tapRecognizer: UITapGestureRecognizer!
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello"
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }()
    
    var square: UIView = {
        let square = UIView()
        square.backgroundColor = .blue
        square.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            square.widthAnchor.constraint(equalToConstant: 100),
            square.heightAnchor.constraint(equalToConstant: 100)
        ])
        return square
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(square)
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            square.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            square.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func didTap() {
        let secondMorphViewController = SecondMorphViewController()
        navigationController?.pushViewController(secondMorphViewController, animated: .morph)
    }
}

extension FirstMorphViewController: MorphAnimatorViewSource {
    
    func viewsOfInterest(forTransition key: Morph.TransitionKey, transit: Morph.Transit) -> [String : UIView]? {
        ["square" : square,
         "textLabel": textLabel]
    }
}
