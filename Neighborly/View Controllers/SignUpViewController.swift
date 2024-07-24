//
//  SignUpViewController.swift
//  Neighborly
//
//  Created by Christina Cheng on 4/15/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var elderlyButton: UIButton!
    @IBOutlet weak var caregiverButton: UIButton!
    
    var currentlyTapped: UIButton?
    var elderlyObject: Elderly?
    var caregiverObject: Caregiver?
    
    
    @IBAction func elderlyTapped(_ sender: Any) {
        if(currentlyTapped == nil){
            elderlyButton.layer.borderWidth = 4
            currentlyTapped = elderlyButton
        } else {
            if(currentlyTapped == elderlyButton){
                elderlyButton.layer.borderWidth = 2
                currentlyTapped = nil
            } else {
                elderlyButton.layer.borderWidth = 4
                caregiverButton.layer.borderWidth = 2
                currentlyTapped = elderlyButton
            }
        }
    }
    
    
    @IBAction func caregiverTapped(_ sender: Any) {
        if(currentlyTapped == nil){
            caregiverButton.layer.borderWidth = 4
            currentlyTapped = caregiverButton
        } else {
            if(currentlyTapped == caregiverButton){
                caregiverButton.layer.borderWidth = 2
                currentlyTapped = nil
            } else {
                caregiverButton.layer.borderWidth = 4
                elderlyButton.layer.borderWidth = 2
                currentlyTapped = caregiverButton
            }
        }
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        //if the re-enter password text does not equal password text
        if passwordTextField!.text != confirmPasswordTextField!.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else if (currentlyTapped == nil){
            let alertController = UIAlertController(title: "Select Type", message: "Please select one one of the buttons: 'I want to help' or 'I need help'", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: emailAddressTextField.text!, password: passwordTextField.text!){ authResult, error in
                if error == nil {
                    if (self.currentlyTapped == self.elderlyButton){
                        let elderlyAccount = Elderly(userUID: authResult!.user.uid)
                        self.elderlyObject = elderlyAccount
                        elderlyAccount.commitToFirebase()
                        //self.performSegue(withIdentifier: "signupToElderly", sender: self)
                    //currentlyTapped == caregiverButton
                    } else {
                        let caregiverAccount = Caregiver(userUID: authResult!.user.uid)
                        self.caregiverObject = caregiverAccount
                        caregiverAccount.commitToFirebase()
                        //self.performSegue(withIdentifier: "signupToCaregiver", sender: self)
                    }
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                }
                //other errors that google handles
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        
        }
    }
    
    override func viewDidLoad() {
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        currentlyTapped = nil
        elderlyButton.layer.borderColor = UIColor.black.cgColor
        elderlyButton.layer.borderWidth = 2
        caregiverButton.layer.borderColor = UIColor.black.cgColor
        caregiverButton.layer.borderWidth = 2
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.layer.borderWidth = 6
        
        super.viewDidLoad()
        
        emailAddressTextField.keyboardType = UIKeyboardType.emailAddress
        emailAddressTextField.autocorrectionType = .no
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.autocorrectionType = .no
        confirmPasswordTextField.keyboardType = UIKeyboardType.default
        confirmPasswordTextField.autocorrectionType = .no
    }
    
    //if return is hit, hide the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "signupToElderly"){
            if let elderlyFormViewController = segue.destination as? ElderlySignUpViewController {
                elderlyFormViewController.thisElderly = elderlyObject!
            }
        //(segue.identifier == "signupToCaregiver")
        } else {
            if let caregiverFormViewController = segue.destination as? CaregiverSignUpViewController {
                caregiverFormViewController.thisCaregiver = caregiverObject!
            }
        }
    }
 */

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
