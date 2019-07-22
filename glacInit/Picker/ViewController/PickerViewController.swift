//
//  PickerViewController.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/22/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit

class PickerView: UITableViewController {
    
    let cellID = "FluffyBunny"
    
    let names = [
        "Tom", "tony", "Colt", "Cody", "Alex", "Matt"
    ]
    
    let anotherListOfNames = [
        "Carl", "Carlos", "Brad", "Peter", "Mark"
    ]
    
    let twodimArray = [
    ["Tom", "tony", "Colt", "Cody", "Alex", "Matt"],
    ["Carl", "Carlos", "Brad", "Peter", "Mark"],
    ["David", "Dan"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Box Files and Folders"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Header"
        label.backgroundColor = .gray
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twodimArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return twodimArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        
       // let name = names[indexPath.row]
        
        let name = twodimArray[indexPath.section][indexPath.row]
        cell.textLabel?.text = "\(name) Section: \(indexPath.section) Row:\(indexPath.row)"
        
        return cell
    }
    
}
