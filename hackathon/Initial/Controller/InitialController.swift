//
//  InitialController.swift
//  hackathon
//
//

import Foundation
import UIKit

final class InitialController: UIViewController {
    
    @IBOutlet private weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 0.5) {
            self.logoImage.alpha = 1
        } completion: { _ in
            self.performSegue(withIdentifier: "AuthController", sender: self)
        }
    }
}

