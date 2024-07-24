import Foundation
import Firebase

class Caregiver{
    //variables
    private var userUID: String
    private var name: String
    private var email: String
    private var phoneNum: Int
    private var zipCode: Int
    private var city: String
    private var county: String
    private var distance: String
    private var orderGroc: Bool
    private var pickUpGroc: Bool
    private var pharmacy: Bool
    private var appt: Bool
    private var dryClean: Bool
    private var tech: Bool
    private var other: String
    
    //constructors/initializers
    init(userUID: String){
        self.userUID = userUID
        self.name = ""
        self.email = ""
        self.phoneNum = 0
        self.zipCode = 0
        self.city = ""
        self.county = ""
        self.distance = ""
        self.orderGroc = false
        self.pickUpGroc = false
        self.pharmacy = false
        self.appt = false
        self.dryClean = false
        self.tech = false
        self.other = ""
    }
    
    
    init(userUID: String, name: String, email: String, phoneNum: Int, zipCode: Int, city: String, county: String, distance: String, orderGroc: Bool, pickUpGroc: Bool, pharmacy: Bool, appt: Bool, dryClean: Bool, tech: Bool, other: String){
        self.userUID = userUID
        self.name = name
        self.email = email
        self.phoneNum = phoneNum
        self.zipCode = zipCode
        self.city = city
        self.county = county
        self.distance = distance
        self.orderGroc = orderGroc
        self.pickUpGroc = pickUpGroc
        self.pharmacy = pharmacy
        self.appt = appt
        self.dryClean = dryClean
        self.tech = tech
        self.other = other
    }
    
    //getters/setters
    func setUserUID(userUID: String){
        self.userUID = userUID
    }
    
    func setName(name: String){
        self.name = name
    }
    
    func setEmail(email: String){
        self.email = email
    }
    
    func setPhoneNum(phoneNum: Int){
        self.phoneNum = phoneNum
    }
    
    func setZipCode(zipCode: Int){
        self.zipCode = zipCode
    }
    
    func setCity(city: String){
        self.city = city
    }
    
    func setCounty(county: String){
        self.county = county
    }
    
    func setDistance(distance: String){
        self.distance = distance
    }
    
    func setOrderGroc(orderGroc: Bool){
        self.orderGroc = orderGroc
    }
    
    func setPickUpGroc(pickUpGroc: Bool){
        self.pickUpGroc = pickUpGroc
    }
    
    func setPharmacy(pharmacy: Bool){
        self.pharmacy = pharmacy
    }
    
    func setAppt(appt: Bool){
        self.appt = appt
    }
    
    func setDryClean(dryClean: Bool){
        self.dryClean = dryClean
    }
    
    func setTech(tech: Bool){
        self.tech = tech
    }
    
    func setOther(other: String){
        self.other = other
    }
    
    func getUserUID() -> String {
        return self.userUID
    }
    
    func getName() -> String{
        return self.name
    }
    
    func getEmail() -> String{
        return self.email
    }
    
    func getPhoneNum() -> Int{
        return self.phoneNum
    }
    
    func getZipCode() -> Int{
        return self.zipCode
    }
    
    func getCity() -> String {
        return self.city
    }
    
    func getCounty() -> String {
        return self.county
    }
    
    func getDistance() -> String {
        return self.distance
    }
    
    func getOrderGroc() -> Bool{
        return self.orderGroc
    }
    
    func getPickUpGroc() -> Bool{
        return self.pickUpGroc
    }
    
    func getPharmacy() -> Bool{
        return self.pharmacy
    }
    
    func getAppt() -> Bool{
        return self.appt
    }
    
    func getDryClean() -> Bool{
        return self.dryClean
    }
    
    func getTech() -> Bool{
        return self.tech
    }
    
    func getOther() -> String{
        return self.other
    }
    
    func commitToFirebase() {
        let ref = Database.database().reference()
        
        var updates: [String:Any] = [:]
        updates["name"] = name
        updates["email"] = email
        updates["phoneNum"] = phoneNum
        updates["zipCode"] = zipCode
        updates["city"] = city
        updates["county"] = county
        updates["distance"] = distance
        updates["orderGroc"] = orderGroc
        updates["pickUpGroc"] = pickUpGroc
        updates["pharmacy"] = pharmacy
        updates["appt"] = appt
        updates["dryClean"] = dryClean
        updates["tech"] = tech
        updates["other"] = other
        
        ref.child("Caregiver/\(userUID)").setValue(updates)
    }
    
}
