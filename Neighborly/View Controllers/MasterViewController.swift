import UIKit

class MasterViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var caregiversToDisplay: [Caregiver] = []
    var caregiversToDisplayServices: [[String]] = []
    var allCaregivers: [Caregiver] = []
    //var caregiverData: [String:Any] = [:]
    var thisElderly: Elderly?
    let SERVICES_TITLES = ["Groceries (order)", "Groceries (pick up)", "Pharmacy", "Schedule Appointments", "Dry Cleaning", "Tech Support", "Other"]
 
  
  let searchController = UISearchController(searchResultsController: nil)
  //var filteredCandies: [Candy] = []
  
  override func viewDidLoad() {
    filterData()
    super.viewDidLoad()
    
  }
    
    
    func filterData() {
        let distanceOptions = ["same zip code", "same city", "same county"]
        let elderlyDistanceReq = distanceOptions.firstIndex(of: thisElderly!.getDistance())
        let elderlyServices = processElderlyServices(elderly: thisElderly!)

        caregiverLoop:
        for caregiver in allCaregivers {
            if (isDefaultSetting(caregiver: caregiver) == true){
                break caregiverLoop
            }
            let caregiverDistanceReq = distanceOptions.firstIndex(of: thisElderly!.getDistance())
            if (caregiverDistanceReq == elderlyDistanceReq){
                if (caregiverDistanceReq == 0 && caregiver.getZipCode() != thisElderly!.getZipCode()){
                    break caregiverLoop
                } else if (caregiverDistanceReq == 1 && caregiver.getCity() != thisElderly!.getCity()){
                    break caregiverLoop
                } else if (caregiverDistanceReq == 2 && caregiver.getCounty() != thisElderly!.getCounty()){
                    break caregiverLoop
                }
            } else if (caregiverDistanceReq! > elderlyDistanceReq!){
                if (caregiverDistanceReq == 1 && caregiver.getZipCode() != thisElderly!.getZipCode()){
                    break caregiverLoop
                } else if (caregiverDistanceReq == 2){
                    if (elderlyDistanceReq! == 0 && caregiver.getZipCode() != thisElderly!.getZipCode()){
                        break caregiverLoop
                    } else if (elderlyDistanceReq! == 1 && caregiver.getCity() != thisElderly!.getCity()){
                        break caregiverLoop
                    }
                }
            } else if (elderlyDistanceReq! > caregiverDistanceReq!){
                if (elderlyDistanceReq == 1 && caregiver.getZipCode() != thisElderly!.getZipCode()){
                    break caregiverLoop
                } else if (elderlyDistanceReq == 2){
                    if (caregiverDistanceReq! == 0 && caregiver.getZipCode() != thisElderly!.getZipCode()){
                        break caregiverLoop
                    } else if (caregiverDistanceReq! == 1 && caregiver.getCity() != thisElderly!.getCity()){
                        break caregiverLoop
                    }
                }
            }
            let caregiverServices = processCaregiverServices(caregiver: caregiver)
            var matchingServices: [String] = []
            for index in 0 ..< elderlyServices.count {
                if (elderlyServices[index] == true && elderlyServices[index] == caregiverServices[index]){
                    matchingServices.append(SERVICES_TITLES[index])
                }
            }
            if (thisElderly!.getOther() == caregiver.getOther()){
                matchingServices.append(caregiver.getOther())
            }
            
            if (matchingServices != []){
                
                caregiversToDisplay.append(caregiver)
                caregiversToDisplayServices.append(matchingServices)
            }
        }
        
    }
    
    func isDefaultSetting(caregiver: Caregiver) -> Bool {
        return caregiver.getEmail() == "" && caregiver.getPhoneNum() == 0 && caregiver.getName() == "" && caregiver.getZipCode() == 0 && caregiver.getCity() == "" && caregiver.getCounty() == "" && caregiver.getDistance() == "" && caregiver.getOrderGroc() == false && caregiver.getPickUpGroc() == false && caregiver.getPharmacy() == false && caregiver.getAppt() == false && caregiver.getDryClean() == false && caregiver.getTech() == false && caregiver.getOther() == ""
    }
    
    func processCaregiverServices(caregiver: Caregiver) -> [Bool]{
        return [caregiver.getOrderGroc(), caregiver.getPickUpGroc(), caregiver.getPharmacy(), caregiver.getAppt(), caregiver.getDryClean(), caregiver.getTech()]
    }
    
    func processElderlyServices(elderly: Elderly) -> [Bool] {
        return [elderly.getOrderGroc(), elderly.getPickUpGroc(), elderly.getPharmacy(), elderly.getAppt(), elderly.getDryClean(), elderly.getTech()]
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if (segue.identifier == "ShowDetailSegue") {
        if let detailViewController = segue.destination as? DetailViewController{
          let indexPath = tableView.indexPathForSelectedRow
          detailViewController.caregiver = caregiversToDisplay[indexPath!.row]
        }
    }
    
  }
  
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  var isFiltering: Bool {
    let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
  }
  
}

extension MasterViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return caregiversToDisplay.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let caregiver = caregiversToDisplay[indexPath.row]
    let caregiverServices = caregiversToDisplayServices[indexPath.row]
    var servicesString = ""
    for index in 0..<caregiverServices.count{
        if (index == caregiverServices.count - 1){
            servicesString.append(caregiverServices[index])
        } else {
            servicesString.append(caregiverServices[index] + ", ")
        }
    }
    cell.textLabel?.text = caregiver.getName() + " (" + caregiver.getCity() + ", " + String(caregiver.getZipCode()) + ")"
    cell.detailTextLabel?.text = servicesString
    return cell
  }
}
