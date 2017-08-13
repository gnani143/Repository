//
//  singleBtnalert.swift
//  TheLocumApp
//
//  Created by Gnani Naidu on 7/26/17.
//  Copyright © 2017 webmobi. All rights reserved.
//

import Foundation
import UIKit
class alert {
    
    func alertview(title : String, subtitle : String,buttontitle : String, parent : UIViewController)
    {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttontitle, style: UIAlertActionStyle.default, handler: nil))
        parent.present(alert, animated: true, completion: nil)
    }
}
