//
//  LogInViewController.swift
//  Neighborly
//
//  Created by Christina Cheng on 4/15/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var elderlyData: [String:Any] = [:]
    var caregiverData: [String:Any] = [:]
    var userUID: String = ""
    var thisPerson: [String:Any] = [:]
    
    
    @IBAction func loginTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailAddressTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
                if error == nil{
                    let userUID = Auth.auth().currentUser!.uid
                    self!.findUserType(userUID: userUID)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
    }
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //given the userUID of the current user, retrieve the entire database, look through the three types of people, and find in which category the userUID is found
    //direct to another view controller depending on which category the userUID was found in
    //if the user created an account, but different pick a category, directed to the choose person type page
    func findUserType(userUID: String) {
        self.userUID = userUID
        let ref = Database.database().reference()
        ref.observeSingleEvent(of: .value) {
            (snapshot) in
            //retrieve all the data from the database
            let wholeDatabase: [String:Any] = (snapshot.value as? [String:Any])!
            print("wholeDatabase")
            print(wholeDatabase)
            
            //separate the data into separate categories for each user type
            let elderlyData: [String:Any] = self.retrieveData(userType: "Elderly", wholeDatabase: wholeDatabase)
            let caregiverData: [String:Any] = self.retrieveData(userType: "Caregiver", wholeDatabase: wholeDatabase)
            
            //assign these dictionaries to a global variable outside the closure
            self.getDatabaseData(data: elderlyData, type: "Elderly")
            self.getDatabaseData(data: caregiverData, type: "Caregiver")
            
            //if the userUID is found inside the foodBankUsers array, perform the segue to the food bank view controllers
            for elderlyPerson in self.elderlyData{
                if(elderlyPerson.key == userUID){
                    self.thisPerson = elderlyPerson.value as! [String : Any]
                    self.performSegue(withIdentifier: "loginToElderly", sender: self)
                }
            }
            for caregiverPerson in self.caregiverData {
                if (caregiverPerson.key == userUID){
                    self.thisPerson = caregiverPerson.value as! [String : Any]
                    self.performSegue(withIdentifier: "loginToCaregiver", sender: self)
                }
            }
        }
    }
    
    //retrieve data again for the search engine
    //after submit is validated and submitted
    func retrieveData(userType: String, wholeDatabase: [String:Any]) -> [String: Any]{
        return wholeDatabase[userType] as! [String : Any]
    }
    
    //save data to global variables
    func getDatabaseData(data: [String:Any], type: String){
        if(type == "Elderly"){
            elderlyData = data
        } else if (type == "Caregiver"){
            caregiverData = data
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginToElderly"){
            if let elderlyFormViewController = segue.destination as? ElderlySignUpViewController {
                print("INFO")
                print(userUID)
                print(thisPerson)
                elderlyFormViewController.thisElderly = FirebaseReader.firebaseToElderlyObject(userUID: self.userUID, data: self.thisPerson)
                elderlyFormViewController.caregiverData = self.caregiverData
            }
        //(segue.identifier == "signupToCaregiver")
        } else {
            if let caregiverFormViewController = segue.destination as? CaregiverSignUpViewController {
                print("INFO")
                print(userUID)
                print(thisPerson)
                caregiverFormViewController.thisCaregiver = FirebaseReader.firebaseToCaregiverObject(userUID: self.userUID, data: self.thisPerson)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
