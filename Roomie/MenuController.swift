//
//  MenuToSegue.swift
//  Roomie
//
//  Created by Pumposh Bhat on 12/6/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import Foundation
import UIKit

class MenuController: UIViewController {
    /*!
     * @discussion Sets navigation bar to black and text to white
     * @param None
     * @return None
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = UIColor.white
    }
}
