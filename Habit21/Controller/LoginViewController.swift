//
//  AddNameViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/15/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNameTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        
        continueButton.addCorner(corner: 12.5)
        addNameTextField.addCorner(corner: 15)
        addNameTextField.placeholderColor = UIColor.lightGray
    }

    @IBAction func continueButtonTapped(_ sender: Any) {
        if (addNameTextField.text?.isEmpty == true) {
            self.errorLabel.text = "Come on! You can tell us your name :)"
            return
        }else{
        self.errorLabel.text = ""
        UserDefaults.standard.set(addNameTextField.text! , forKey: "name")
        UserDefaults.standard.set(true, forKey: "isLogin")
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
        self.navigationController?.show(vc!, sender: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            
            if textField == self.addNameTextField {
                if updatedText.isEmpty {
                    self.continueButton.backgroundColor = UIColor.lightGray
                }
                else {
                    self.continueButton.backgroundColor = UIColor.init(red: 115/255, green: 152/255, blue: 71/255, alpha: 1.0)
                }
            }
        }
        return true
    }
}
