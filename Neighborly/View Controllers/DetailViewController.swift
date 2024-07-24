import UIKit

class DetailViewController: UIViewController {
  
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countyLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var orderGrocLabel: UILabel!
    @IBOutlet weak var pickUpGrocLabel: UILabel!
    @IBOutlet weak var pharmacyLabel: UILabel!
    @IBOutlet weak var apptLabel: UILabel!
    @IBOutlet weak var dryCleaningLabel: UILabel!
    @IBOutlet weak var techLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    
  
  var caregiver: Caregiver?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    emailLabel.text = caregiver!.getEmail()
    phoneNumberLabel.text = String(caregiver!.getPhoneNum())
    nameLabel.text = caregiver!.getName()
    zipCodeLabel.text = String(caregiver!.getZipCode())
    cityLabel.text = caregiver!.getCity()
    countyLabel.text = caregiver!.getCounty()
    distanceLabel.text = caregiver!.getDistance()
    if (caregiver!.getOrderGroc() == false){
        orderGrocLabel.isHidden = true
    }
    if (caregiver!.getPickUpGroc() == false){
        pickUpGrocLabel.isHidden = true
    }
    if (caregiver!.getPharmacy() == false){
        pharmacyLabel.isHidden = true
    }
    if (caregiver!.getAppt() == false){
        apptLabel.isHidden = true
    }
    if (caregiver!.getDryClean() == false){
        dryCleaningLabel.isHidden = true
    }
    if (caregiver!.getTech() == false){
        techLabel.isHidden = true
    }
    if (caregiver!.getOther() == ""){
        otherLabel.isHidden = true
    } else {
        otherLabel.text = caregiver!.getOther()
    }
    
  }
  

}
