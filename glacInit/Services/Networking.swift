//
//  Networking.swift
//  glacInit
//
//  Created by Lyle Reinholz on 7/16/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

import UIKit


class Networking: NSObject {
    
    let url = URL(string: "https://unomaha.app.box.com")
    
    
   // https://account.box.com/api/oauth2/authorize?response_type=code&client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URI&state=security_token%3DKnhMJatFipTAnM0nHlZA
    func displayImage() {
        
        let task = URLSession.shared.downloadTask(with: url!) {
            
            (location, response, error) in
            //guard let location = location,
               // let imageData =
                //let image = UIImage(data: imageData) else { return }
    
        }
        task.resume()
        
    }

}
