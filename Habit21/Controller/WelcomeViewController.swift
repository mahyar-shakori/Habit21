//
//  dsaViewController.swift
//  Habit21
//
//  Created by Mahyar on 4/25/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleView()
    }
    
    func handleView() {
        
        nameLabel.text = "Welcome, \(UserDefaults.standard.string(forKey: "name") ?? "")"
        indicator.startAnimating()
        
        delayWithSeconds(1.5) {
            let storyBoard : UIStoryboard = self.storyboard!
            let vc = storyBoard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.show(vc, sender: nil)
            self.indicator.stopAnimating()
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}
