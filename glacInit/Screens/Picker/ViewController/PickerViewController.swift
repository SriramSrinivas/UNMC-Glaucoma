/*************************************************************************
 *
 * UNIVERSITY OF NEBRASKA AT OMAHA CONFIDENTIAL
 * __________________
 *
 *  [2018] - [2019] University of Nebraska at Omaha
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of University of Nebraska at Omaha and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to University of Nebraska at Omaha
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from University of Nebraska at Omaha.
 *
 * Code written by Lyle Reinholz.
 */

//how to get rid of the grey for non selectable
// bring up another view for showing which files will be imported

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
    var Source = Globals.shared.importAndExportLoaction
    lazy var localStorage = LoaclStorage.init()
    
   // UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
    let brightLightBlue = UIColor(red:0.40, green:0.99, blue:0.95, alpha:1.0)
    let deepLightBlue = UIColor(red:0.27, green:0.64, blue:0.62, alpha:1.0)
    let darkDeepBlue = UIColor(red:0.30, green:0.30, blue:0.30, alpha:1.0)
    let textColor = UIColor(red:0.77, green:0.78, blue:0.78, alpha:1.0)
    let headerBackgroundColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.0)
    
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
                        let isfolder = twodimArray[section].items[index].isFolder
                        let file = FilesToDownload(name: name, id: id, isFolder: isfolder)
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
            let trash = (UIImage(named: "trash"))
            
            navigationItem.rightBarButtonItems = [UIBarButtonItem(image: cancel, style: .plain, target: self, action: #selector(self.handleShowIndexPath))]
            navigationItem.rightBarButtonItems?.first?.tintColor = brightLightBlue
            navigationItem.rightBarButtonItems?.last?.tintColor = brightLightBlue
            
        }
        else{
            let trash = (UIImage(named: "trash"))
            
            let downloads = checkingForFiles ? (UIImage(named: "downloads")) : (UIImage(named: "upload"))
            if Source == .local {
                navigationItem.rightBarButtonItems = [UIBarButtonItem(image: downloads, style: .plain, target: self, action: #selector(handleShowIndexPath)), UIBarButtonItem(image: trash, style: .plain, target: self, action: #selector(rightHeaderClicked))]
            } else {
                navigationItem.rightBarButtonItems = [UIBarButtonItem(image: downloads, style: .plain, target: self, action: #selector(handleShowIndexPath))]
            }
            navigationItem.rightBarButtonItems?.first?.tintColor = brightLightBlue
            navigationItem.rightBarButtonItems?.last?.tintColor = brightLightBlue
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
            navigationItem.leftBarButtonItem?.tintColor = brightLightBlue
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
        
        if (Globals.shared.importAndExportLoaction == .box) {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControll
        } else {
            tableView.addSubview(refreshControll)
        }
        refreshControll.addTarget(self, action: #selector(getCurrentFolder(_:)), for: .valueChanged)
        refreshControll.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: .init())
        }
        alltwodimArray = twodimArray
       self.navigationController?.isNavigationBarHidden = false
        
        let cancel = (UIImage(named: "cancel"))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: cancel, style: .plain, target: self, action: #selector(handleShowIndexPath))]
       
        let home = UIImage(named: "home-page")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: home, style: .plain, target: self, action: #selector(BackTapped))
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BackTapped))
        
        navigationItem.title = "Box - Home Directory"
        navigationItem.titleView?.backgroundColor = darkDeepBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(PickerCell.self, forCellReuseIdentifier: cellID)
        navigationItem.leftBarButtonItem?.tintColor = brightLightBlue
        navigationItem.rightBarButtonItems?.first?.tintColor = brightLightBlue
        navigationItem.rightBarButtonItems?.last?.tintColor = brightLightBlue
        navigationController?.navigationBar.barTintColor = darkDeepBlue
        tableView.backgroundColor = darkDeepBlue
        
            //cellBackgroundColor
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        if (Globals.shared.importAndExportLoaction == .box) {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControll
        } else {
            tableView.addSubview(refreshControll)
        }
        refreshControll.addTarget(self, action: #selector(getCurrentFolder(_:)), for: .valueChanged)
        refreshControll.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: .init())
        }
        alltwodimArray = twodimArray
        self.navigationController?.isNavigationBarHidden = false
        
        let cancel = (UIImage(named: "cancel"))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: cancel, style: .plain, target: self, action: #selector(handleShowIndexPath))]
        
        let home = UIImage(named: "home-page")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: home, style: .plain, target: self, action: #selector(BackTapped))
        
        //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(BackTapped))
        
        navigationItem.title = "Box - Home Directory"
        navigationItem.titleView?.backgroundColor = darkDeepBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(PickerCell.self, forCellReuseIdentifier: cellID)
        navigationItem.leftBarButtonItem?.tintColor = brightLightBlue
        navigationItem.rightBarButtonItems?.first?.tintColor = brightLightBlue
        navigationItem.rightBarButtonItems?.last?.tintColor = brightLightBlue
        navigationController?.navigationBar.barTintColor = darkDeepBlue
        tableView.backgroundColor = darkDeepBlue
        
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
//        if Source == dataSource.local{
//            addFolderButton.setImage(UIImage(named: "trash"), for: .normal)
//            addFolderButton.contentMode = .scaleAspectFit
//        }
        addFolderButton.frame = CGRect(x: view.frame.width - height, y: 0, width: height, height: height)
        addFolderButton.translatesAutoresizingMaskIntoConstraints = false
        addFolderButton.widthAnchor.constraint(equalToConstant: height).isActive = true
        
//        addFolderButton.addTarget(self, action: #selector(rightHeaderClicked), for: .touchUpInside)
        addFolderButton.backgroundColor = darkDeepBlue
        
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = brightLightBlue
        button.setTitleColor(brightLightBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: (14 / OH) * view.frame.height)
        button.frame = CGRect(x: 0, y: 0, width: height, height: height)
        button.backgroundColor = darkDeepBlue
        
        button.addTarget(self, action: #selector(closeSection), for: .touchUpInside)
        button.tag = section
        var headernamestext : String
        let headerName = UILabel()
        if (Source == dataSource.local) {
            headernamestext = "Subject Files"
        } else {
            headernamestext = (section == 0) ? "  Folders" : "  Files     "
        }
        headerName.backgroundColor = darkDeepBlue
        headerName.text = headernamestext
        headerName.textColor = textColor
        //headerName.tintColor = brightLightBlue
        var fileNameImage : String
        if (Source == dataSource.local){
            fileNameImage = "user"
        } else {
            fileNameImage = (section == 0) ? "folder-invoices" : "file"
        }
        let fileImage = UIImage(named: fileNameImage)
        let fileimageView = UIImageView()
        fileimageView.image = fileImage
        fileimageView.contentMode = .scaleAspectFit
        fileimageView.layer.cornerRadius = 12
        fileimageView.layer.borderColor = headerBackgroundColor.cgColor
        fileimageView.layer.borderWidth = 3
        fileimageView.backgroundColor = brightLightBlue
        fileimageView.tintColor = brightLightBlue
        
        innerSt.addArrangedSubview(fileimageView)
        innerSt.addArrangedSubview(headerName)
        innerSt.backgroundColor = headerBackgroundColor
        stackview.addArrangedSubview(innerSt)
        stackview.addArrangedSubview(button)
        //rightStack.addSubview(addFolderButton)
        stackview.addArrangedSubview(addFolderButton)
        stackview.tintColor = brightLightBlue
        stackview.backgroundColor = headerBackgroundColor
        //stackview.distribution = .fill
        //stackview.distribution = .equalSpacing
        //stackview.tintColor = headerBackgroundColor
        return stackview
    }
    
    @objc func rightHeaderClicked(){
        if Source == .box {
        let file = importFile.init()
        //file.createBoxFoler(withName: "hello", parentFolderID: "0")
        print("file")
        } else {
            let session = Session(currentSubjectId: "")
            var files : [FilesToDownload] = []
            for section in twodimArray.indices{
                //if twodimArray[section].isExpanded{
                for index in twodimArray[section].items.indices{
                    if twodimArray[section].items[index].isSelected{
                        let name = twodimArray[section].items[index].name
                        let id = twodimArray[section].items[index].ID
                        let isfolder = twodimArray[section].items[index].isFolder
                        let file = FilesToDownload(name: name, id: id, isFolder: isfolder)
                        files.append(file)
                    }
                    
                }
                // }
            }
            localStorage.deleteData(data: files)
            dismiss(animated: true, completion: nil)
        }
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
        button.tintColor = brightLightBlue
        
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
        if (Source == dataSource.local) {
            return 1
        } else {
            return twodimArray.count
        }
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
        
        
        cell.backgroundColor = boxitem.isSelected ? deepLightBlue : headerBackgroundColor
        cell.textLabel?.textColor = boxitem.isSelected ? .black : textColor
        cell.accessoryView?.backgroundColor = boxitem.isSelected ?  brightLightBlue : deepLightBlue
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
        //ell.textLabel?.textColor = textColor
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (Source == dataSource.box) {
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
        navigationItem.leftBarButtonItem?.tintColor = brightLightBlue
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
