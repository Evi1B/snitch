//
//  GameViewController.swift
//  test
//
//  Created by evilb on 02.10.2021.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Helpers.shared.isFirstRun == true {
        performSegue(withIdentifier: "tutorial", sender: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://2llctw8ia5.execute-api.us-west-1.amazonaws.com/prod"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let winner = try JSONDecoder().decode(WinnerView.self, from: data)
                print(winner)
            } catch let error {
                print(error)
            }

        }.resume()
        
        let scene = GameScene(size: CGSize(width: 1125, height: 2436))
        let skView = self.view as! SKView

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.showWebView), name: kWinNotification , object: nil)
        
    }
    
    @objc func showWebView() {
        performSegue(withIdentifier: "webView", sender: nil)
    }

}
