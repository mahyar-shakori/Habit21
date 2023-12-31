//
//  AddNameViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/15/22.
//

import UIKit

class SetNameViewController: UIViewController {
    
    @IBOutlet weak var welcomeImage: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var welcomeLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleView()
    }
    
    func handleView() {
        
        addNameTextField.delegate = self
        addNameTextField.placeholderColor = UIColor.lightGray
        nameView.layer.borderWidth = 1
        nameView.layer.borderColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 1.0).cgColor
        nameView.addCornerView(corner: 25)
        continueButton.addCornerView(corner: 12.5)
        continueButton.backgroundColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 0.5)
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        if (addNameTextField.text?.isEmpty == true) {
            errorLabel.text = "Come on! You can tell us your name :)"
            nameView.layer.borderWidth = 2
            nameView.layer.borderColor = UIColor.red.cgColor
            return
        }else{
            
            UserDefaults.standard.set(addNameTextField.text! , forKey: "name")
            UserDefaults.standard.set(true, forKey: "isLogin")
        }
        let storyBoard : UIStoryboard = self.storyboard!
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Welcome") as! WelcomeViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.show(nextViewController, sender: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SetNameViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        welcomeImage.isHidden = true
        welcomeLabelConstraint.constant = 50
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        welcomeImage.isHidden = false
        welcomeLabelConstraint.constant = 428
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if textField == addNameTextField {
                if updatedText.isEmpty {
                    continueButton.backgroundColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 0.5)
                }
                else {
                    continueButton.backgroundColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 1.0)
                    errorLabel.text = ""
                    nameView.layer.borderWidth = 1
                    nameView.layer.borderColor = UIColor.init(red: 232/255, green: 50/255, blue: 95/255, alpha: 1.0).cgColor
                }
            }
        }
        return true
    }
}
