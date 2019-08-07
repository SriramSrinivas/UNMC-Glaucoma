//
//  PickerViewController.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/22/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

//how to get rid of the grey for non selectable
// bring up another view for showing which files will be imported

//BUG: when not expanded


import Foundation
import UIKit
import BoxContentSDK
import PopupDialog

protocol PickerViewdelegate: class{
    func getFilestoDownload(files: [FilesToDownload])
}

class PickerView: UITableViewController, PickerViewdelegate {
    
    weak var delegate : PickerViewdelegate?
    let cellID = "FluffyBunny"
    let boxItems : [BOXItem]? = nil
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    internal let refreshControll = UIRefreshControl()
    
    public var twodimArray : [ExpandableNames] = []
    var checkingForFiles : Bool = true
    var alltwodimArray : [ExpandableNames] = []
    var isSelectedCount = 0
    var currentFolderID = "0"
    var titlePathString = "Home"
    var titlePathCount = 0
    var child : SpinnerViewController?
    
    var showindexPaths = false
    
    func someMethodCall(cell: UITableViewCell){
        guard let indexPathclickedon = tableView.indexPath(for: cell) else {return}
        var changeoccured = false
        let boxItem = twodimArray[(indexPathclickedon.section)].items[(indexPathclickedon.row)]
        let selected = boxItem.isSelected
        
        if !checkingForFiles {
            if !boxItem.isSelected && isSelectedCount == 0{
                isSelectedCount = isSelectedCount + 1
                changeoccured = true
        }
            else if boxItem.isSelected && isSelectedCount > 0{
                isSelectedCount = isSelectedCount - 1
                changeoccured = true
            }
            
        } else {
                if !boxItem.isSelected {
                    isSelectedCount = isSelectedCount + 1
                    changeoccured = true
                }
                else if boxItem.isSelected && isSelectedCount > 0{
                    isSelectedCount = isSelectedCount - 1
                    changeoccured = true
                }
        }
        changeRightNav()
        if changeoccured {
            twodimArray[(indexPathclickedon.section)].items[(indexPathclickedon.row)].isSelected = !selected
        }
        tableView.reloadRows(at: [indexPathclickedon], with: .fade)
    }
    
    func getFilestoDownload(files: [FilesToDownload]) {
    }
    
    func prepareFilesFortransfer(completion:@escaping (_ uploaded:Bool, _ error:Error?)-> Void) -> Bool{
        var flag = true
        if (isSelectedCount > 0){
        var files : [FilesToDownload] = []
        for section in twodimArray.indices{
            //if twodimArray[section].isExpanded{
                for index in twodimArray[section].items.indices{
                    if twodimArray[section].items[index].isSelected{
                        let name = twodimArray[section].items[index].name
                        let id = twodimArray[section].items[index].ID
                        let file = FilesToDownload(name: name, id: id)
                        files.append(file)
                    }
                    
                }
           // }
        }
        var title = ""
        if files.count == 1 && checkingForFiles{
            title = "Are you sure you want to import this files"
        }
        else if checkingForFiles {
            title = "Are you sure you want to import thesee file"
        }
        else if !checkingForFiles {
            title = "Are you sure You want to Export to this Folder?"
        }
        var message = ""
        for file in files {
            message.append(file.name + "\n")
        }
        //let image = UIImage(named: "pexels-photo-103290")
        
        let popup = PopupDialog(title: title, message: message, tapGestureDismissal: true, panGestureDismissal: false)
       // flag = true
        let buttonOne = CancelButton(title: "CANCEL", dismissOnTap: true) {
            completion(false,nil)
        }
        let buttonTwo = DefaultButton(title: "YES", dismissOnTap: true) {
            self.delegate!.getFilestoDownload(files: files)
            completion(true,nil)
        }
        popup.addButtons([buttonOne, buttonTwo])
        
        self.present(popup, animated: true, completion: nil)
       // delegate!.getFilestoDownload(files: files)
        return flag
        } else {
            completion(true,nil)
            
        }
        return true
    }
    func changeRightNav() {
        if isSelectedCount == 0 {
            let cancel = (UIImage(named: "cancel"))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: cancel, style: .plain, target: self, action: #selector(handleShowIndexPath))
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        }
        else{
            let downloads = (UIImage(named: "downloads"))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: downloads, style: .plain, target: self, action: #selector(handleShowIndexPath))
            navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        }
    }
    
    //MARK: Button Handlers
    
    @objc func handleShowIndexPath(){
        prepareFilesFortransfer(completion: { (importReady:Bool, error:Error?) in
            if importReady {
                self.dismiss(animated: true, completion: nil)
            }
            else{
                for section in self.twodimArray.indices{
                        for index in self.twodimArray[section].items.indices{
                            if self.twodimArray[section].items[index].isSelected{
                                self.twodimArray[section].items[index].isSelected = false
                                let indexPath = IndexPath(item: index, section: section)
                                if self.twodimArray[section].isExpanded{
                                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                                }
                            }
                    }
                }
                self.isSelectedCount = 0
                self.changeRightNav()
            }
            
        })
        
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
            removeLastPath()

        }
        if (titlePathCount == 0){
            let home = UIImage(named: "home-page")
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: home, style: .plain, target: self, action: #selector(BackTapped))
            navigationItem.leftBarButtonItem?.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        }
        isSelectedCount = checkForIsSelectedCount()
        changeRightNav()
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
    
    //MARK: View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControll
        } else {
            tableView.addSubview(refreshControll)
        }
        refreshControll.addTarget(self, action: #selector(getCurrentFolder(_:)), for: .valueChanged)
        refreshControll.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: .init())
        alltwodimArray = twodimArray
       self.navigationController?.isNavigationBarHidden = false
        
        let cancel = (UIImage(named: "cancel"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: cancel, style: .plain, target: self, action: #selector(handleShowIndexPath))
       
        let home = UIImage(named: "home-page")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: home, style: .plain, target: self, action: #selector(BackTapped))
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BackTapped))
        
        navigationItem.title = "Box - Home Directory"
        navigationItem.titleView?.backgroundColor = UIColor(red:0.12, green:0.16, blue:0.20, alpha:1.0)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(PickerCell.self, forCellReuseIdentifier: cellID)
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.12, green:0.16, blue:0.20, alpha:1.0)
        tableView.backgroundColor = UIColor(red:0.12, green:0.16, blue:0.20, alpha:1.0)
        
            //UIColor(red:0.04, green:0.05, blue:0.06, alpha:1.0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    @objc private func getCurrentFolder(_ sender: Any) {
        //self.refreshControl?.beginRefreshing()
        let file = importFile.init()
        file.getFolderItems(withID: currentFolderID, completion:  { (uploaded:Bool, error:Error?) in
            if let fileError = error {
                self.showToast(message: "\(fileError.localizedDescription)", theme: .error)
            }
            else {
                self.isSelectedCount = 0
                self.changeRightNav()
                self.refreshControl?.endRefreshing()

            }
        })
    }
    
    //MARK: TABLE VIEW HANDLERS
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let stackview = UIStackView()
        let button = UIButton(type: .system)
        let image = UIImage(named: "chevron-down")
        let innerSt = UIStackView()
        let rightStack = UIStackView()
        //UIColor(red:0.04, green:0.05, blue:0.06, alpha:1.0)
        let OH: CGFloat = 768.0
        let height = (35 / OH) * view.frame.height
        let addFolderButton = UIButton(type: .system)
        
        addFolderButton.titleLabel?.text = "Add Folder"
        addFolderButton.translatesAutoresizingMaskIntoConstraints = false
        addFolderButton.widthAnchor.constraint(equalToConstant: height).isActive = true
        addFolderButton.addTarget(self, action: #selector(addFolderBox), for: .touchUpInside)
        addFolderButton.backgroundColor = .red
        
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        button.setTitleColor(UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: (14 / OH) * view.frame.height)
        button.frame = CGRect(x: 0, y: 0, width: height, height: height)
        button.backgroundColor = UIColor(red:0.12, green:0.16, blue:0.20, alpha:1.0)
        
        button.addTarget(self, action: #selector(closeSection), for: .touchUpInside)
        button.tag = section
        
        let headerName = UILabel()
        let headernamestext = (section == 0) ? "  Folders" : "  Files     "
        headerName.backgroundColor = UIColor(red:0.12, green:0.16, blue:0.20, alpha:1.0)
        headerName.text = headernamestext
        headerName.textColor = UIColor(red:0.77, green:0.78, blue:0.78, alpha:1.0)
        //headerName.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        
        let fileNameImage = (section == 0) ? "folder-invoices" : "file"
        let fileImage = UIImage(named: fileNameImage)
        let fileimageView = UIImageView()
        fileimageView.image = fileImage
        fileimageView.contentMode = .scaleAspectFit
        fileimageView.layer.cornerRadius = 12
        fileimageView.layer.borderColor = UIColor(red:0.04, green:0.05, blue:0.06, alpha:1.0).cgColor
        fileimageView.layer.borderWidth = 3
        fileimageView.backgroundColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        fileimageView.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        
        //stackview.spacing = 10
        innerSt.addArrangedSubview(fileimageView)
        innerSt.addArrangedSubview(headerName)
        innerSt.backgroundColor = UIColor(red:0.04, green:0.05, blue:0.06, alpha:1.0)
        stackview.addArrangedSubview(innerSt)
        //stackview.spacing = 5
        stackview.addArrangedSubview(button)
        //rightStack.addSubview(addFolderButton)
        stackview.addArrangedSubview(addFolderButton)
        stackview.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        stackview.backgroundColor = UIColor(red:0.04, green:0.05, blue:0.06, alpha:1.0)
        //stackview.distribution = .fill
        stackview.distribution = .equalSpacing
        return stackview
    }
    
    @objc func addFolderBox(){
        let file = importFile.init()
        //file.createBoxFoler(withName: "hello", parentFolderID: "0")
        print("file")
    }
    
    @objc func closeSection(button: UIButton){
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in twodimArray[section].items.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        let isExpanded = twodimArray[section].isExpanded
        twodimArray[section].isExpanded = !isExpanded
        let name = isExpanded ? "chevron-up" : "chevron-down"
        let image = UIImage(named: name)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
        
        if !isExpanded{
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        else{
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let OH: CGFloat = 768.0
        let height = view.frame.height
        
        return ((50 / OH) * height)
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
        
        cell.backgroundColor = boxitem.isSelected ? UIColor(red:0.27, green:0.64, blue:0.62, alpha:1.0) : UIColor(red:0.04, green:0.05, blue:0.06, alpha:1.0)
        cell.textLabel?.textColor = boxitem.isSelected ? .black : UIColor(red:0.77, green:0.78, blue:0.78, alpha:1.0)
        cell.accessoryView?.backgroundColor = boxitem.isSelected ?  UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0) : UIColor(red:0.27, green:0.64, blue:0.62, alpha:1.0)
        if checkingForFiles {
            cell.accessoryView?.isHidden = boxitem.isFolder
            cell.selectionStyle = .none
        }
        else {
            cell.accessoryView?.isHidden = !boxitem.isFolder
            cell.selectionStyle = .none
        }
        cell.textLabel?.text = boxitem.name
        //cell.backgroundColor = UIColor(red:0.04, green:0.05, blue:0.06, alpha:1.0)
        //ell.textLabel?.textColor = UIColor(red:0.77, green:0.78, blue:0.78, alpha:1.0)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if twodimArray[indexPath.section].items[indexPath.row].isFolder{
            
            let file = importFile.init()
            let id = twodimArray[indexPath.section].items[indexPath.row].ID
            let name = twodimArray[indexPath.section].items[indexPath.row].name
            createSpinnerView()
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
                    self.removeSpinner()
                }
            })
            //activityIndicator.stopAnimating()
            file.delegate = self
        }
    }
    func checkForIsSelectedCount() -> Int {
        var count = 0
        for section in twodimArray.indices{
            //if twodimArray[section].isExpanded{
            for index in twodimArray[section].items.indices{
                if twodimArray[section].items[index].isSelected{
                    count = count + 1
                
                }
                
            }
            // }
        }
        return count
    }
    
    func createSpinnerView() {
        child = SpinnerViewController()
        // add the spinner view controller
        addChild(child!)
        child?.view.frame = view.frame
        view.addSubview(child!.view)
        child?.didMove(toParent: self)
        
        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 5 ) {
            // then remove the spinner view controller
            self.child?.willMove(toParent: nil)
            self.child?.view.removeFromSuperview()
            self.child?.removeFromParent()
        }
    }
    func removeSpinner() {
        DispatchQueue.main.async {
            self.child?.removeFromParent()
            self.child?.hideSpinner()
            self.child = nil
            
        }
    }

    func changeNavTitle(){
        if (titlePathCount > 0){
            navigationItem.title = titlePathString
            navigationController?.navigationBar.prefersLargeTitles = true
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
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
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
class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
   
    public func hideSpinner() {
        spinner.stopAnimating()
       // self.removeFromParent()
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

class ImportConfirm: UIViewController {
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }
}
