//
//  CustomUIAlertController.swift
//  BookStore
//
//  Created by Kaio Dantas on 09/10/20.
//

import Foundation
import UIKit

class CustomUIAlertController : UIAlertController {
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait,UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
}
