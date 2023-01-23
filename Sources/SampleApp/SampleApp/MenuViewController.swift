//
//  MenuViewController.swift
//  SampleApp
//
//  Created by Dermot O'Sullivan on 22/1/2023.
//

import UIKit
import MorphAnimator

final class MenuViewController: UIViewController {
    
    private enum MenuItem: Int, CustomStringConvertible, CaseIterable {
        case morphExample
        case portalExample
        
        var description: String {
            switch self {
            case .morphExample: return "Morph Example"
            case .portalExample: return "Portal Example"
            }
        }
        
    }
    
    let cellReuseIdentifier = "cell"
    lazy var tableview: UITableView = {
        let tableview = UITableView(frame: .zero, style: .insetGrouped)
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuItem.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = MenuItem(rawValue: indexPath.item) else { fatalError() }
        let cell = tableview.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = "\(item.description)"
        return cell
    }
    
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = MenuItem(rawValue: indexPath.item) else { fatalError() }
        switch item {
        case .portalExample:
            print("")
        case .morphExample:
            print("")
        }
    }
}
