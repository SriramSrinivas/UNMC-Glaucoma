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

import Foundation
import UIKit

protocol BackgroundChangeDelegate : class {
    func backgorundDidChange()
}

class BackgroundChangeController : UICollectionViewController, BackgroundChangeDelegate {
    
    weak var delegate : BackgroundChangeDelegate?
    
    func backgorundDidChange() {
        
    }
    
    
    var images: [BackgroundImage] = {
        var temp = BackgroundImage()
        temp.BackgroundimageName = "tes"
        temp.ID = 21
        temp.title = "Rocket League"
        
        var temp1 = BackgroundImage()
        temp1.BackgroundimageName = "tes-1"
        temp1.ID = 3
        temp1.title = "Forest"

        var temp2 = BackgroundImage()
        temp2.BackgroundimageName = "mainTes"
        temp2.ID = 2
        temp2.title = "city"
        return [temp, temp1, temp2]
   //     return [temp]
    }()
    
    //let images = ["tes", "mainTes", "tes-1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        //view.alpha = 0.5
        collectionView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        //collectionView?.backgroundColor.
        collectionView.register(ChangeCell.self, forCellWithReuseIdentifier: "cellID")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! ChangeCell
        cell.imageAt = images[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageName = images[indexPath.item].BackgroundimageName!
        let image = UIImage(named: imageName)
        Globals.shared.setCurrentBackGround(newBack: imageName)
        delegate?.backgorundDidChange()
//        let viewController = MainMenuViewController()
//        self.present(viewController, animated: true, completion: nil)
        self.dismiss(animated: false,
                     completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
}

extension BackgroundChangeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: view.frame.height / 2)
    }
}

