//
//  TutorialVC.swift
//  test
//
//  Created by evilb on 02.10.2021.
//

import UIKit
import QuartzCore

class TutorialVC: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helpers.shared.isFirstRun = false
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
