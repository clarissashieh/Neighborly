import Foundation
import Firebase
import FirebaseDatabase

class FirebaseReader {
    static func firebaseToElderlyObject(userUID: String, data: [String:Any]) -> Elderly{
        let name = data["name"] as! String
        let email = data["email"] as! String
        let phoneNum = data["phoneNum"] as! Int
        let zipCode = data["zipCode"] as! Int
        let city = data["city"] as! String
        let county = data["county"] as! String
        let distance = data["distance"] as! String
        let orderGroc = data["orderGroc"] as! Bool
        let pickUpGroc = data["pickUpGroc"] as! Bool
        let pharmacy = data["pharmacy"] as! Bool
        let appt = data["appt"] as! Bool
        let dryClean = data["dryClean"] as! Bool
        let tech = data["tech"] as! Bool
        let other = data["other"] as! String
        return Elderly(userUID: userUID, name: name, email: email, phoneNum: phoneNum, zipCode: zipCode, city: city, county: county, distance: distance, orderGroc: orderGroc, pickUpGroc: pickUpGroc, pharmacy: pharmacy, appt: appt, dryClean: dryClean, tech: tech, other: other)
    }
    
    static func firebaseToCaregiverObject(userUID: String, data: [String:Any]) -> Caregiver {
        let name = data["name"] as! String
        let email = data["email"] as! String
        let phoneNum = data["phoneNum"] as! Int
        let zipCode = data["zipCode"] as! Int
        let city = data["city"] as! String
        let county = data["county"] as! String
        let distance = data["distance"] as! String
        let orderGroc = data["orderGroc"] as! Bool
        let pickUpGroc = data["pickUpGroc"] as! Bool
        let pharmacy = data["pharmacy"] as! Bool
        let appt = data["appt"] as! Bool
        let dryClean = data["dryClean"] as! Bool
        let tech = data["tech"] as! Bool
        let other = data["other"] as! String
        return Caregiver(userUID: userUID, name: name, email: email, phoneNum: phoneNum, zipCode: zipCode, city: city, county: county, distance: distance, orderGroc: orderGroc, pickUpGroc: pickUpGroc, pharmacy: pharmacy, appt: appt, dryClean: dryClean, tech: tech, other: other)
    }
}
