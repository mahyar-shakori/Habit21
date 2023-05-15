//
//  dsaViewController.swift
//  Habit21
//
//  Created by Mahyar on 4/25/23.
//

import UIKit
import Alamofire

protocol QuoteDelegate{
    func setQuoteText() -> String
}

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var quoteResponse : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleView()
    }
    
    func handleView() {
        
        nameLabel.text = "Welcome, \(UserDefaults.standard.string(forKey: "name") ?? "")"
        self.indicator.startAnimating()
        
        AppDelegate.asd = true
        if AppDelegate.asd == true {
            fetchData()
        } else {
            
            self.delayWithSeconds(1) {
                let storyBoard : UIStoryboard = self.storyboard!
                               let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                               nextViewController.delegate = self
                               nextViewController.modalPresentationStyle = .fullScreen
                               self.navigationController?.show(nextViewController, sender: nil)
                               self.indicator.stopAnimating()
            }
        }
    }
    
    func fetchData() {
                
        let url = "https://api.api-ninjas.com/v1/quotes?category=success&limit=1"
        
        let headers: HTTPHeaders = [
            "X-Api-Key": "lap3sU0ASOTqp+yNhwqAIA==1vMwgAQ5Rv1r0rkJ"
        ]

        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).response { response in
            
            switch response.result {
                
            case .success(let data) :
                guard data != nil else {
                    return
                }
                
                print(String(data: data!, encoding: .utf8)!)
                
                let json = try? JSONDecoder.init().decode([QuotesResponse].self, from: data!)
                
                self.quoteResponse = json?[0].quote ?? ""
                
                let storyBoard : UIStoryboard = self.storyboard!
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                nextViewController.delegate = self
                nextViewController.modalPresentationStyle = .fullScreen
                self.navigationController?.show(nextViewController, sender: nil)
                self.indicator.stopAnimating()
                
            case .failure(_) :
                self.quoteResponse = "Due to your internet problem, we couldn't display today's quote."
                let storyBoard : UIStoryboard = self.storyboard!
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                nextViewController.delegate = self
                nextViewController.modalPresentationStyle = .fullScreen
                self.navigationController?.show(nextViewController, sender: nil)
                self.indicator.stopAnimating()
                print("Json Error")
                
                break
            }
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}

extension WelcomeViewController: QuoteDelegate {
    
    func setQuoteText() -> String {
        return quoteResponse
    }
}
