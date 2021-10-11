//
//  LoadingVC.swift
//  Snitch
//
//  Created by evilb on 08.10.2021.
//

import UIKit

class LoadingVC: UIViewController {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var currentProgress = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // stop any current animation
        self.progressBar.layer.sublayers?.forEach { $0.removeAllAnimations() }

        // reset progressView to 0%
        self.progressBar.setProgress(0.0, animated: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            // set progressView to 100%, with animated set to false
            self.progressBar.setProgress(1.0, animated: false)
            print(self.progressBar.progress)
                
            
            // 10-second animation changing from 100% to 0%
            UIView.animate(withDuration: 5, delay: 0, options: [], animations: { [unowned self] in
                print(self.progressBar.progress)
                self.progressBar.layoutIfNeeded()
                
            })
            
        }
        
        setLabelProgress(initialValue: 0, targetValue: 100)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.performSegue(withIdentifier: "GameViewController", sender: nil)
        }
        
    }
    
    func setLabelProgress(initialValue: Int, targetValue: Int) {

        guard currentProgress != targetValue else { return }

        let range = targetValue - initialValue
        let increment = range/abs(range)
        let duration: TimeInterval = 4.55
        let delay = duration/TimeInterval(range)
        currentProgress += increment
        progressLabel.text = String(describing: currentProgress)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.setLabelProgress(initialValue: initialValue, targetValue: targetValue)
        }
    }

}
