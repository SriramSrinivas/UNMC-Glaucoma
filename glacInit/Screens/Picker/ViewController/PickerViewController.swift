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
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    internal let refreshControll = UIRefreshControl()
    
    public var twodimArray : [ExpandableNames] = []
    var checkingForFiles : Bool = true
    var alltwodimArray : [ExpandableNames] = []
    var isSelectedCount = 0
    var currentFolderID = "0"
    var titlePathString = "Home"
    var titlePathCount = 0
    
    var showindexPaths = false
    
    func someMethodCall(cell: UITableViewCell){
        guard let indexPathclickedon = tableView.indexPath(for: cell) else {return}
        let boxItem = twodimArray[(indexPathclickedon.section)].items[(indexPathclickedon.row)]
        print(boxItem.name)
        //print(indexPathclickedon)
        let selected = boxItem.isSelected
        if boxItem.isSelected{
            isSelectedCount = isSelectedCount + 1
        }
        else{
            isSelectedCount = isSelectedCount - 1
        }
        changeRightNav()
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
        delegate!.getFilestoDownload(files: files)
    }
    func changeRightNav() {
        if isSelectedCount == 0 {
            let cancel = (UIImage(named: "cancel"))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: cancel, style: .plain, target: self, action: #selector(handleShowIndexPath))
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
        else{
            let downloads = (UIImage(named: "downloads"))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: downloads, style: .plain, target: self, action: #selector(handleShowIndexPath))
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }
    
    @objc func handleShowIndexPath(){
        print("attempting")
        
        prepareFilesFortransfer()
        self.dismiss(animated: true, completion: nil)
    }
    @objc func BackTapped(){
        if (alltwodimArray.count > 1){
            isSelectedCount = 0
            twodimArray.removeAll()
            let last = alltwodimArray.last!
            alltwodimArray.remove(at: (alltwodimArray.count - 1))
            let secondlast = alltwodimArray.last!
            alltwodimArray.remove(at: (alltwodimArray.count - 1))
            twodimArray.append(secondlast)
            twodimArray.append(last)
            removeLastPath()
        }
        if (titlePathCount == 0){
            let home = UIImage(named: "home-page")
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: home, style: .plain, target: self, action: #selector(BackTapped))
            navigationItem.leftBarButtonItem?.tintColor = .black
        }
        isSelectedCount = 0
        changeRightNav()
        print(alltwodimArray.count, twodimArray.count)
        tableView.reloadData()
    }
    
    func removeLastPath(){
        var newPath = titlePathString.components(separatedBy: "/")
        if titlePathString != "Home" {
            newPath.popLast()
    
        var Path = String()
        Path.append(newPath.remove(at: 0))
        while newPath.count >= 1{
            Path.append("/" + newPath.remove(at: 0))
        }
        
        titlePathString = Path
        titlePathCount = titlePathCount - 1
        }
        changeNavTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControll
        } else {
            tableView.addSubview(refreshControll)
        }
        refreshControll.addTarget(self, action: #selector(getCurrentFolder(_:)), for: .valueChanged)
        alltwodimArray = twodimArray
       self.navigationController?.isNavigationBarHidden = false
        
        let cancel = (UIImage(named: "cancel"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: cancel, style: .plain, target: self, action: #selector(handleShowIndexPath))
        navigationItem.rightBarButtonItem?.tintColor = .black
        let home = UIImage(named: "home-page")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: home, style: .plain, target: self, action: #selector(BackTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BackTapped))
        
        navigationItem.title = "Box - Home Directory"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(PickerCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    @objc private func getCurrentFolder(_ sender: Any) {
        let file = importFile.init()
        file.getFolderItems(withID: currentFolderID, completion:  { (uploaded:Bool, error:Error?) in
            if let fileError = error {
                self.showToast(message: "\(fileError.localizedDescription)", theme: .error)
            }
            else {
                //self.twodimArray.removeAll()
                self.isSelectedCount = 0
                self.changeRightNav()
                print("Success")
                self.refreshControl?.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        })
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let stackview = UIStackView()
        let button = UIButton(type: .system)
        let image = UIImage(named: "chevron-down")
        let innerSt = UIStackView()
        
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.backgroundColor = .gray
        
        button.addTarget(self, action: #selector(closeSection), for: .touchUpInside)
        button.tag = section
        
        let headerName = UILabel()
        let headernamestext = (section == 0) ? "Folders" : "Files     "
        headerName.backgroundColor = .gray
        headerName.text = headernamestext
        
        let fileNameImage = (section == 0) ? "folder-invoices" : "file"
        let fileImage = UIImage(named: fileNameImage)
        let fileimageView = UIImageView()
        fileimageView.image = fileImage
        fileimageView.contentMode = .scaleAspectFit
        fileimageView.backgroundColor = .gray
        
        //stackview.spacing = 10
        innerSt.addArrangedSubview(fileimageView)
        innerSt.addArrangedSubview(headerName)
        stackview.addArrangedSubview(innerSt)
        stackview.addArrangedSubview(button)
        stackview.backgroundColor = .gray
        return stackview
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
        let name = isExpanded ? "chevron-up" : "chevron-down"
        let image = UIImage(named: name)
        button.setImage(image, for: .normal)
        
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
      
        let boxitem = twodimArray[indexPath.section].items[indexPath.row]
        let darkBlue = UIColor(red: 66/255, green: 167/255, blue: 198/255, alpha: 1.0)
        let lightBlue = UIColor(red: 107/255, green: 185/255, blue: 210/255, alpha: 1.0)
        
        cell.backgroundColor = boxitem.isSelected ? darkBlue : .white
        cell.accessoryView?.backgroundColor = boxitem.isSelected ? lightBlue : darkBlue
        if checkingForFiles {
            cell.accessoryView?.isHidden = boxitem.isFolder
        }
        else {
            cell.accessoryView?.isHidden = !boxitem.isFolder
        }
        cell.textLabel?.text = boxitem.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if twodimArray[indexPath.section].items[indexPath.row].isFolder{
            let file = importFile.init()
            let id = twodimArray[indexPath.section].items[indexPath.row].ID
            let name = twodimArray[indexPath.section].items[indexPath.row].name
            activityIndicator.startAnimating()
            file.getFolderItems(withID: id, completion:  { (uploaded:Bool, error:Error?) in
                if let fileError = error {
                    self.showToast(message: "\(fileError.localizedDescription)", theme: .error)
                }
                else {
                    self.isSelectedCount = 0
                    self.changeRightNav()
                    self.alltwodimArray.append(self.twodimArray[0])
                    self.alltwodimArray.append(self.twodimArray[1])
                    self.changeLeftNavitem()
                    self.titlePathCount = self.titlePathCount + 1
                    self.titlePathString.append("/" + "\(name)")
                    self.changeNavTitle()
                    self.currentFolderID = id
                    print("Success")
                }
            })
            activityIndicator.stopAnimating()
            file.delegate = self
        }
    }
    
    func changeNavTitle(){
        if (titlePathCount > 0){
            navigationItem.title = titlePathString
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        else if (titlePathCount == 0){
            navigationItem.title = "Box - Home Directory"
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        else{
            titlePathCount = 0
        }
        
    }
    
    func changeLeftNavitem(){
        let back = UIImage(named: "circled-left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: back, style: .plain, target: self, action: #selector(self.BackTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    func getData(boxitems: [ExpandableNames]){
        if alltwodimArray.count == 0 {
            alltwodimArray = twodimArray
        }
        twodimArray.removeAll()
        for items in boxitems{
            twodimArray.append(items)
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
        twoDArray.append(ExpandableNames(isExpanded: true, items: folderItems))
        twoDArray.append(ExpandableNames(isExpanded: true, items: fileItems))
        getData(boxitems: twoDArray)
     
    }
}
