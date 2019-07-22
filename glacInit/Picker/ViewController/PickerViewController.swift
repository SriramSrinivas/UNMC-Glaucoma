//
//  PickerViewController.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/22/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit
import BoxContentSDK

class PickerView: UITableViewController {
    
    let cellID = "FluffyBunny"
    let boxItems : [BOXItem]? = nil
    
    public var twodimArray : [ExpandableNames] = []
    var alltwodimArray : [ExpandableNames] = []
    
    var showindexPaths = false
    
    @objc func handleShowIndexPath(){
        print("attempting")
        
        var indexPathsToReload = [IndexPath]()
        
        for section in twodimArray.indices{
            if twodimArray[section].isExpanded{
                for index in twodimArray[section].items.indices{
                    let indexPath = IndexPath(row: index, section: section)
                    indexPathsToReload.append(indexPath)
                }
            }
        }
        
        showindexPaths = !showindexPaths
        
        let animationStyle = showindexPaths ? UITableView.RowAnimation.right : .left
        
        //let indexPath = IndexPath(row: 0, section: 0)
        tableView.reloadRows(at: indexPathsToReload, with: animationStyle)
    }
    @objc func BackTapped(){
        if (alltwodimArray.count > 1){
            twodimArray.removeAll()
            let last = alltwodimArray.last!
            alltwodimArray.remove(at: (alltwodimArray.count - 1))
            let secondlast = alltwodimArray.last!
            alltwodimArray.remove(at: (alltwodimArray.count - 1))
            twodimArray.append(secondlast)
            twodimArray.append(last)
        }
        
        print(alltwodimArray.count, twodimArray.count)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alltwodimArray = twodimArray
       self.navigationController?.isNavigationBarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ShowIndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BackTapped))
        
        navigationItem.title = "Box Files and Folders"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ShowIndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        navigationItem.title = "Box Files and Folders"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitle("close", for: .normal)
        button.backgroundColor = .gray
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(closeSection), for: .touchUpInside)
        button.tag = section
        return button
//        let label = UILabel()
//        label.text = "Header"
//        label.backgroundColor = .gray
//        return label
    }
    
    @objc func closeSection(button: UIButton){
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in twodimArray[section].items.indices {
            print(section, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        let isExpanded = twodimArray[section].isExpanded
        twodimArray[section].isExpanded = !isExpanded
        button.setTitle(isExpanded ? "open" : "close", for: .normal)
        
        if !isExpanded{
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        else{
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twodimArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !twodimArray[section].isExpanded {
            return 0
        }
        else {
            return twodimArray[section].items.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        
       // let name = names[indexPath.row]
        
        let name = twodimArray[indexPath.section].items[indexPath.row].name
        
        if showindexPaths{
            cell.textLabel?.text = "\(name) Section: \(indexPath.section) Row:\(indexPath.row)"
        }
        else{
            cell.textLabel?.text = name
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if twodimArray[indexPath.section].items[indexPath.row].isFolder{
            var file = importFile.init(subjectId: "", backGroundId: "", file: FileType.CSV)
            let id = twodimArray[indexPath.section].items[indexPath.row].ID
            file.getFolderItems(withID: id)
            file.delegate = self
            
        }
        else{
            //prepare for downloading
        }
    }
    func getData(boxitems: [ExpandableNames]){
        if alltwodimArray.count == 0 {
            alltwodimArray = twodimArray
        }
        //twodimArray.removeAll()
        twodimArray.removeAll()
        for items in boxitems{
            //twodimArray.removeAll()
            twodimArray.append(items)
            alltwodimArray.append(items)
        }
        tableView.reloadData()
    }
    
}
extension PickerView: ImportDelegate{
    func didReceiveData(boxItems: [BOXItem]) {
        var twoDArray : [ExpandableNames] = []
        var fileItems: [BoxItemsData] = []
        var folderItems: [BoxItemsData] = []
        for items in boxItems {
            let changedata = BoxItemsData(boxItem: items)
            if changedata.isFolder {
                folderItems.append(changedata)
            } else {
                fileItems.append(changedata)
            }
        }
        //let newArray = ExpandableNames(isExpanded: true, items: folderItems!)
        twoDArray.append(ExpandableNames(isExpanded: true, items: folderItems))
        twoDArray.append(ExpandableNames(isExpanded: true, items: fileItems))
        getData(boxitems: twoDArray)
        
    }
}
