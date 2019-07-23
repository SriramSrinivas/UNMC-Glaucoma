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

protocol PickerViewdelegate: class{
    func getFilestoDownload(files: [FilesToDownload])
}

class PickerView: UITableViewController, PickerViewdelegate {
    
    weak var delegate : PickerViewdelegate?
    let cellID = "FluffyBunny"
    let boxItems : [BOXItem]? = nil
    
    public var twodimArray : [ExpandableNames] = []
    var alltwodimArray : [ExpandableNames] = []
    
    var showindexPaths = false
    
    func someMethodCall(cell: UITableViewCell){
        guard let indexPathclickedon = tableView.indexPath(for: cell) else {return}
        let boxItem = twodimArray[(indexPathclickedon.section)].items[(indexPathclickedon.row)]
        print(boxItem.name)
        //print(indexPathclickedon)
        let selected = boxItem.isSelected
        twodimArray[(indexPathclickedon.section)].items[(indexPathclickedon.row)].isSelected = !selected
        tableView.reloadRows(at: [indexPathclickedon], with: .fade)
    }
    
    
    func getFilestoDownload(files: [FilesToDownload]) {
    }
    func prepareFilesFortransfer(){
        var files : [FilesToDownload] = []
        for section in twodimArray.indices{
            if twodimArray[section].isExpanded{
                for index in twodimArray[section].items.indices{
                    if twodimArray[section].items[index].isSelected{
                        let name = twodimArray[section].items[index].name
                        let id = twodimArray[section].items[index].ID
                        let file = FilesToDownload(name: name, id: id)
                        files.append(file)
                    }
                    
                }
            }
        }
        
//        for FileType in twodimArray{
//            //let FileType.items.count
//            for i in 0...FileType.items.count{
//                if FileType.items[i].isSelected {
//                    let name = FileType.items[i].name
//                    let Id = FileType.items[i].ID
//                    let file = FilesToDownload(name: name, id: Id)
//                    files.append(file)
//                }
//            }
//        }
        delegate!.getFilestoDownload(files: files)
    }
    @objc func handleShowIndexPath(){
        print("attempting")
        
        prepareFilesFortransfer()
        self.dismiss(animated: true, completion: nil)
//        var indexPathsToReload = [IndexPath]()
        
//        for section in twodimArray.indices{
//            if twodimArray[section].isExpanded{
//                for index in twodimArray[section].items.indices{
//                    let indexPath = IndexPath(row: index, section: section)
//                    indexPathsToReload.append(indexPath)
//                }
//            }
//        }
//
//        showindexPaths = !showindexPaths
//
//        let animationStyle = showindexPaths ? UITableView.RowAnimation.right : .left
//
//        //let indexPath = IndexPath(row: 0, section: 0)
//        tableView.reloadRows(at: indexPathsToReload, with: animationStyle)
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
        let height = view.frame.height
        let width = view.frame.width
        //tableView.frame = CGRect(x: height/4, y: width/4, width: width/2, height: height/2)
        alltwodimArray = twodimArray
       self.navigationController?.isNavigationBarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Import", style: .plain, target: self, action: #selector(handleShowIndexPath))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BackTapped))
        
        navigationItem.title = "Box Files and Folders"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(PickerCell.self, forCellReuseIdentifier: cellID)
        //tableView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width/2, height: view.frame.size.height/2)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PickerCell
        
        cell.link = self
       // let name = names[indexPath.row]
        
        let boxitem = twodimArray[indexPath.section].items[indexPath.row]
        
        cell.backgroundColor = boxitem.isSelected ? UIColor.blue : .white
        cell.accessoryView?.backgroundColor = boxitem.isSelected ? UIColor.white : .blue
        
        if showindexPaths{
            cell.textLabel?.text = "\(boxitem.name) Section: \(indexPath.section) Row:\(indexPath.row)"
        }
        else{
            cell.textLabel?.text = boxitem.name
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if twodimArray[indexPath.section].items[indexPath.row].isFolder{
            var file = importFile.init()
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
    func FileInfoReceived() {
        
    }
    
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
