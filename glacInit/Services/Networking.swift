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
