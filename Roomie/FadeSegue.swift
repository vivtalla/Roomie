//
//  FadeSegue.swift
//  Roomie
//
//  Created by Pumposh Bhat on 12/6/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import Foundation
import UIKit

class FadeSegue: UIStoryboardSegue {
    /*!
     * @discussion Segues between storyboard to fade between views
     * @param None
     * @return Fade out
     */
    override func perform() {
        let source = self.source as UIViewController
        let destination = self.destination as UIViewController
        let window = UIApplication.shared.keyWindow!
        
        destination.view.alpha = 0.0
        window.insertSubview(destination.view, belowSubview: source.view)
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            source.view.alpha = 0.0
            destination.view.alpha = 1.0
        }) { (finished) -> Void in
            source.view.alpha = 1.0
            source.present(destination, animated: false, completion: nil)
        }
    }
}
