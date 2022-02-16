//
//  AddNameViewController.swift
//  Habit21
//
//  Created by MahyarShakouri on 2/15/22.
//

import UIKit

class AddNameViewController: UIViewController {

    @IBOutlet weak var addNameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNameTextField.delegate = self
    }

    @IBAction func continueButtonTapped(_ sender: Any) {
        if (addNameTextField.text?.isEmpty == true) {
            self.errorLabel.text = "Come on! You can tell us your name :)"
            self.continueButton.backgroundColor = UIColor.lightGray
            return
        }else{
        self.errorLabel.text = ""
        UserDefaults.standard.set(addNameTextField.text! , forKey: "name")
        UserDefaults.standard.set(true, forKey: "isLogin")
        }
        let storyBoard : UIStoryboard = self.storyboard!
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomePage") as! HomeViewController
        self.navigationController?.show(nextViewController, sender: nil)
        self.present(nextViewController, animated: true, completion: nil)
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage")
//        self.navigationController?.show(vc!, sender: nil)
    }
}

extension AddNameViewController: UITextFieldDelegate {
    
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
