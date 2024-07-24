import UIKit

class CaregiverSignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var thisCaregiver: Caregiver?
    
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countyTextField: UITextField!
    
    @IBOutlet weak var orderGrocSwitch: UISwitch!
    @IBOutlet weak var pickUpSwitch: UISwitch!
    @IBOutlet weak var pharmacySwitch: UISwitch!
    @IBOutlet weak var apptSwitch: UISwitch!
    @IBOutlet weak var dryCleanSwitch: UISwitch!
    @IBOutlet weak var techSwitch: UISwitch!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var pickerData: [String] = [String]()
    var pickerView: UIPickerView = UIPickerView()
    
    @IBAction func submitTapped(_ sender: Any) {
        let result: Bool = verifyEntry()
        if(result == true){
            saveData()
        }
        else {
            var alertMessage: String = ""
            if (!Validator.validatePhoneNumber(text: phoneTextField.text!) || !Validator.validateZipCode(text: zipTextField.text!) || !Validator.validateEmailAddress(text: emailTextField.text!)){
                alertMessage = "Please fill in the text fields with valid information."
            } else {
                alertMessage = "Please fill in all the required fields."
            }
            let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //valid form entry is text fields are not empty, and the phone number, zip code, etc. are valid entries
    func verifyEntry() -> Bool {
        return (nameTextField.text != "" && Validator.validatePhoneNumber(text: phoneTextField.text!) && Validator.validateZipCode(text: zipTextField.text) && Validator.validateEmailAddress(text: emailTextField.text!) && distanceTextField.text != "" && cityTextField.text != "" && countyTextField.text != "")
    }
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        emailTextField.autocorrectionType = .no
        phoneTextField.keyboardType = UIKeyboardType.numberPad
        phoneTextField.autocorrectionType = .no
        zipTextField.keyboardType = UIKeyboardType.numberPad
        
        super.viewDidLoad()
        
        // connect data
        distanceTextField.inputView = pickerView
        pickerData =  ["same zip code", "same city", "same county"]
        pickerView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }

    // number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    // number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
       
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // This method is triggered whenever the user makes a change to the picker selection.
            // The parameter named row and component represents what was selected.
        distanceTextField.text = pickerData[row]
    }
    
    //saves data in text fields to elderly object
    func saveData(){
        thisCaregiver?.setEmail(email: emailTextField.text!)
        thisCaregiver?.setPhoneNum(phoneNum: Int(phoneTextField.text!)!)
        thisCaregiver?.setName(name: nameTextField.text!)
        thisCaregiver?.setZipCode(zipCode: Int(zipTextField.text!)!)
        thisCaregiver?.setDistance(distance: distanceTextField.text!)
        thisCaregiver?.setCity(city: cityTextField.text!)
        thisCaregiver?.setCounty(county: countyTextField.text!)
        thisCaregiver?.setOrderGroc(orderGroc: orderGrocSwitch.isOn)
        thisCaregiver?.setPickUpGroc(pickUpGroc: pickUpSwitch.isOn)
        thisCaregiver?.setPharmacy(pharmacy: pharmacySwitch.isOn)
        thisCaregiver?.setAppt(appt: apptSwitch.isOn)
        thisCaregiver?.setDryClean(dryClean: dryCleanSwitch.isOn)
        thisCaregiver?.setTech(tech: techSwitch.isOn)
        thisCaregiver?.setOther(other: otherTextField.text!)
        thisCaregiver!.commitToFirebase()
    }
}
