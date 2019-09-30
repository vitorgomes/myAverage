//
//  ViewController+CoreData.swift
//  MyAverage
//
//  Created by Vitor Gomes on 02/09/19.
//  Copyright © 2019 Vitor Gomes. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}
