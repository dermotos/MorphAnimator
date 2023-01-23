//
//  Helpers.swift
//  SampleApp
//
//  Created by Dermot O'Sullivan on 23/1/2023.
//

import Foundation
import UIKit

extension UITableView {
    func deselectSelectedRow() {
        if let selectedIndexPath = self.indexPathForSelectedRow {
            deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}
