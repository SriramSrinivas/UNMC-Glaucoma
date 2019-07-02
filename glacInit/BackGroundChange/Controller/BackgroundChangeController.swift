//
//  BackgroundChangeController.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/1/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import Foundation
import UIKit

class BackgroundChangeController : UICollectionViewController {
    
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
        collectionView?.backgroundColor = UIColor.black
        collectionView?.backgroundColor?.withAlphaComponent(0.5)
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
        let viewController = ViewController()
        viewController.backImageName = images[indexPath.item].BackgroundimageName!
        //self.dismiss(animated: true, completion: nil)
        self.present(viewController, animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }
    
}

extension BackgroundChangeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: 600)
    }
}

