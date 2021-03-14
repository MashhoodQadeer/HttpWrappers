//
//  ViewController.swift
//  HttpWrappers
//
//  Created by Mashhood Qadeer on 14/03/2021.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.sharedInstance.opertationWithRequest(withApi: .users(limit: "10") ) { (res) in
            switch res {
            case .Success( let data):
                 dump(data)
            break
            case .Failure( let message ):
                print(message!.description)
            break
            }
            
        }
    }
}

