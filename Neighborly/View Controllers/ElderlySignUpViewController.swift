//
//  ElderlySignUpViewController.swift
//  Neighborly
//
//  Created by Clarissa Shieh on 4/2/21.
//

import UIKit
import AVFoundation
import Speech

class ElderlySignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, SFSpeechRecognizerDelegate, AVAudioPlayerDelegate{
    
    //switches are wrong
    //text styles of some text fields

    var thisElderly: Elderly?
    var caregiverData: [String:Any] = [:]
    var allCaregivers: [Caregiver] = []
    
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var zipButton: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var countyTextField: UITextField!
    @IBOutlet weak var countyButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var orderGrocSwitch: UISwitch!
    @IBOutlet weak var pickUpSwitch: UISwitch!
    @IBOutlet weak var pharmacySwitch: UISwitch!
    @IBOutlet weak var apptSwitch: UISwitch!
    @IBOutlet weak var dryCleanSwitch: UISwitch!
    @IBOutlet weak var techSwitch: UISwitch!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    //speech recognition objects & vars
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var email : Bool = false
    var phone : Bool = false
    var name : Bool = false
    var zip : Bool = false
    var city : Bool = false
    var county : Bool = false
    
    
    //audio player variables
    var APEmail = AVAudioPlayer()
    var APPhone = AVAudioPlayer()
    var APName = AVAudioPlayer()
    var APZip = AVAudioPlayer()
    var APCity = AVAudioPlayer()
    var APCounty = AVAudioPlayer()
    var APDistance = AVAudioPlayer()
    var APServices1 = AVAudioPlayer()
    var APServices2 = AVAudioPlayer()
    var APServices3 = AVAudioPlayer()
    var APBeep = AVAudioPlayer()
    
    //picker view variables
    var pickerData: [String] = [String]()
    var pickerView: UIPickerView = UIPickerView()
    
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
        
        if let image = UIImage(named: "microphone_button.jpg") {
            emailButton.setImage(image, for: .normal)
        }
        
        emailTextField.text! = thisElderly!.getEmail()
        if (thisElderly!.getPhoneNum() == 0){
            phoneTextField.text! = ""
        } else {
            phoneTextField.text! = String(thisElderly!.getPhoneNum())
        }
        nameTextField.text! = thisElderly!.getName()
        if (thisElderly!.getZipCode() == 0){
            zipTextField.text! = ""
        } else {
            zipTextField.text! = String(thisElderly!.getZipCode())
        }
        cityTextField.text! = String(thisElderly!.getCity())
        countyTextField.text! = String(thisElderly!.getCounty())
        distanceTextField.text! = String(thisElderly!.getDistance())
        orderGrocSwitch.isOn = thisElderly!.getOrderGroc()
        pickUpSwitch.isOn = thisElderly!.getPickUpGroc()
        pharmacySwitch.isOn = thisElderly!.getPharmacy()
        apptSwitch.isOn = thisElderly!.getAppt()
        dryCleanSwitch.isOn = thisElderly!.getDryClean()
        techSwitch.isOn = thisElderly!.getTech()
        otherTextField.text! = thisElderly!.getOther()
        
        // Do any additional setup after loading the view.
        //sound files
        let email = Bundle.main.path(forResource: "email", ofType: "mp3")
        let phone = Bundle.main.path(forResource: "phone", ofType: "mp3")
        let name = Bundle.main.path(forResource: "name", ofType: "mp3")
        let zip = Bundle.main.path(forResource: "zip", ofType: "mp3")
        let city = Bundle.main.path(forResource: "city", ofType: "mp3")
        let county = Bundle.main.path(forResource: "county", ofType: "mp3")
        let distance = Bundle.main.path(forResource: "distance", ofType: "mp3")
        let services1 = Bundle.main.path(forResource: "services_pt1", ofType: "mp3")
        let services2 = Bundle.main.path(forResource: "services_pt2", ofType: "mp3")
        let services3 = Bundle.main.path(forResource: "services_pt3", ofType: "mp3")
        let beep = Bundle.main.path(forResource: "beep", ofType: "mp3")
        
        do{
            APEmail = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: email!))
            APPhone = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: phone!))
            APName = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: name!))
            APZip = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: zip!))
            APCity = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: city!))
            APCounty = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: county!))
            APDistance = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: distance!))
            APServices1 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: services1!))
            APServices2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: services2!))
            APServices3 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: services3!))
            APBeep = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: beep!))
        }
        catch{
            print(error)
        }
        
        //speech recognition
        disableButtons()
        
        //asks user for permission for speech recognition
        speechRecognizer!.delegate = self
        
        SFSpeechRecognizer.requestAuthorization{
            (authStatus) in
            var isButtonEnabled = true
            switch authStatus {
            case .authorized:
                isButtonEnabled = true

            case .denied:
                isButtonEnabled = false
                self.presentAlert()
                print("User denied access to speech recognition")

            case .restricted:
                isButtonEnabled = false
                self.presentAlert()
                print("Speech recognition restricted on this device")

            case .notDetermined:
                isButtonEnabled = false
                self.presentAlert()
                print("Speech recognition not yet authorized")
                
            }

            OperationQueue.main.addOperation() {
                self.emailButton.isEnabled = isButtonEnabled
                self.phoneButton.isEnabled = isButtonEnabled
                self.nameButton.isEnabled = isButtonEnabled
                self.zipButton.isEnabled = isButtonEnabled
                self.cityButton.isEnabled = isButtonEnabled
                self.countyButton.isEnabled = isButtonEnabled
                self.distanceButton.isEnabled = isButtonEnabled
                self.helpButton.isEnabled = isButtonEnabled
            }
        }
        
        
        // connect data
        distanceTextField.inputView = pickerView
        pickerData =  ["same zip code", "same city", "same county"]
        pickerView.delegate = self
        
        for (userUID, data) in caregiverData {
            allCaregivers.append(FirebaseReader.firebaseToCaregiverObject(userUID: userUID, data: data as! [String : Any]))
        }
        
        
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        let result: Bool = verifyEntry()
        if(result == true){
            saveData()
            self.performSegue(withIdentifier: "elderlyToSearchEngine", sender: self)
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
        return (nameTextField.text != "" && Validator.validatePhoneNumber(text: phoneTextField.text!) && Validator.validateZipCode(text: zipTextField.text) && Validator.validateEmailAddress(text: emailTextField.text!) && cityTextField.text != "" && countyTextField.text != "" && distanceTextField.text != "")
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        APEmail.play()
        disableButtons()
        print("email test")
        print(APEmail.isPlaying)
        DispatchQueue.main.asyncAfter(deadline: .now() + APEmail.duration) {
            self.APBeep.play()
            self.email = true
            self.startRecording()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
            self.APBeep.play()
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionRequest?.endAudio()
            self.email = false
            self.enableButtons()
        }
       
    }
    
    @IBAction func phoneButtonTapped(_ sender: Any) {
        APPhone.play()
        disableButtons()
        print("phone test")
        print(APPhone.isPlaying)
        DispatchQueue.main.asyncAfter(deadline: .now() + APPhone.duration) {
            self.APBeep.play()
            self.phone = true
            self.startRecording()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.APBeep.play()
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionRequest?.endAudio()
            self.phone = false
            self.enableButtons()
        }
    }
    
    @IBAction func nameButtonTapped(_ sender: Any) {
        APName.play()
        disableButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + APName.duration) {
            self.APBeep.play()
            self.name = true
            self.startRecording()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.APBeep.play()
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionRequest?.endAudio()
            self.name = false
            self.enableButtons()
        }
    }
    
    @IBAction func zipButtonTapped(_ sender: Any) {
        APZip.play()
        disableButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + APZip.duration) {
            self.APBeep.play()
            self.zip = true
            self.startRecording()
            self.zip = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.APBeep.play()
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionRequest?.endAudio()
            self.zip = false
            self.enableButtons()
        }
    }
    
    
    @IBAction func cityButtonTapped(_ sender: Any) {
        APCity.play()
        disableButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + APCity.duration) {
            self.APBeep.play()
            self.city = true
            self.startRecording()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.APBeep.play()
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionRequest?.endAudio()
            self.city = false
            self.enableButtons()
        }
    }
    
    
    @IBAction func countyButtonTapped(_ sender: Any) {
        APCounty.play()
        disableButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + APCounty.duration) {
            self.APBeep.play()
            self.county = true
            self.startRecording()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.APBeep.play()
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
            self.recognitionRequest?.endAudio()
            self.county = false
            self.enableButtons()
        }
    }
    
    
    @IBAction func distanceButtonTapped(_ sender: Any) {
        APDistance.play()
        disableButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + APZip.duration) {
            self.enableButtons()
        }
    }
    
    @IBAction func helpButtonTapped(_ sender: Any) {
        APServices1.play()
        disableButtons()
        DispatchQueue.main.asyncAfter(deadline: .now() + APServices1.duration) {
            self.APServices2.play()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + APServices1.duration + APServices2.duration) {
            self.APServices3.play()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + APServices1.duration + APServices2.duration + APServices3.duration) {
            self.enableButtons()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest, resultHandler: { [self] (result, error) in
            
            var isFinal = false
            
            print("speech")
            
            print(email)
            print(phone)
            
            if (result?.bestTranscription.formattedString != nil){
                if(self.email == true){
                    self.emailTextField.text = result!.bestTranscription.formattedString
                    isFinal = (result?.isFinal)!
                } else if(self.phone == true){
                    self.phoneTextField.text = result?.bestTranscription.formattedString
                    isFinal = (result?.isFinal)!
                } else if(self.name == true){
                    self.nameTextField.text = result?.bestTranscription.formattedString
                    isFinal = (result?.isFinal)!
                } else if(self.zip == true){
                    self.zipTextField.text = result?.bestTranscription.formattedString
                    isFinal = (result?.isFinal)!
                } else if(self.city == true){
                    self.cityTextField.text = result?.bestTranscription.formattedString
                    isFinal = (result?.isFinal)!
                } else if(self.county == true){
                    self.countyTextField.text = result?.bestTranscription.formattedString
                    isFinal = (result?.isFinal)!
                }
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.enableButtons()
        } else {
            self.disableButtons()
        }
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
        thisElderly?.setEmail(email: emailTextField.text!)
        if(phoneTextField.text!.contains("-")){
            thisElderly?.setPhoneNum(phoneNum: Int(phoneTextField.text!.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil))!)
        } else {
            thisElderly?.setPhoneNum(phoneNum: Int(phoneTextField.text!)!)
        }
        thisElderly?.setName(name: nameTextField.text!)
        thisElderly?.setZipCode(zipCode: Int(zipTextField.text!)!)
        thisElderly?.setCity(city: cityTextField.text!)
        thisElderly?.setCounty(county: countyTextField.text!)
        thisElderly?.setDistance(distance: distanceTextField.text!)
        thisElderly?.setOrderGroc(orderGroc: orderGrocSwitch.isOn)
        thisElderly?.setPickUpGroc(pickUpGroc: pickUpSwitch.isOn)
        thisElderly?.setPharmacy(pharmacy: pharmacySwitch.isOn)
        thisElderly?.setAppt(appt: apptSwitch.isOn)
        thisElderly?.setDryClean(dryClean: dryCleanSwitch.isOn)
        thisElderly?.setTech(tech: techSwitch.isOn)
        thisElderly?.setOther(other: otherTextField.text!)
        thisElderly!.commitToFirebase()
    }
    
    func presentAlert(){
        let alert = UIAlertController(title: "Alert", message: "Please note that you have disabled the speech recognition feature. Clicking on the microphone will not enable the speech recognition.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "I understand", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "elderlyToSearchEngine"){
            if let searchEngineViewController = segue.destination as? MasterViewController {
                print("here")
                searchEngineViewController.allCaregivers = allCaregivers
                searchEngineViewController.thisElderly = thisElderly!
            }
        }
    }
    
    func disableButtons(){
        emailButton.isEnabled = false
        phoneButton.isEnabled = false
        nameButton.isEnabled = false
        zipButton.isEnabled = false
        cityButton.isEnabled = false
        countyButton.isEnabled = false
        distanceButton.isEnabled = false
        helpButton.isEnabled = false
    }
    
    func enableButtons(){
        emailButton.isEnabled = true
        phoneButton.isEnabled = true
        nameButton.isEnabled = true
        zipButton.isEnabled = true
        cityButton.isEnabled = true
        countyButton.isEnabled = true
        distanceButton.isEnabled = true
        helpButton.isEnabled = true
    }
}
