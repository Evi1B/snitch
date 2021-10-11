//
//  WebViewVC.swift
//  test
//
//  Created by evilb on 03.10.2021.
//

import UIKit
import WebKit

class WebViewVC: UIViewController, WKUIDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConf = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConf)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.font:
                                                UIFont.boldSystemFont(ofSize: 20.0),
                                              .foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        let urlString = "https://2llctw8ia5.execute-api.us-west-1.amazonaws.com/prod"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { return }
            
            do {
                let winner = try JSONDecoder().decode(WinnerView.self, from: data)
                DispatchQueue.main.async {
                    self.webView.backgroundColor = .black
                    var winUrl = URL(string: "")
                    if self.appDelegate.isWin {
                        winUrl = URL(string: winner.winner)
                    } else {
                        winUrl = URL(string: winner.loser)
                    }
                    
                    let requestUrl = URLRequest(url: winUrl!)
                    self.webView.load(requestUrl)
                }
                
                print(winner)
            } catch let error {
                print(error)
            }
            
        }.resume()
        
        
    }
    
    @IBAction func backToGame(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}
