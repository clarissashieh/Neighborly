import Foundation

//validates phone number, email, and zip code
class Validator{
    static func validatePhoneNumber(text: String) -> Bool {
        let phoneNum = text
        let PHONE_REGEX = "([+]?1+[-]?)?+([(]?+([0-9]{3})?+[)]?)?+[-]?+[0-9]{3}+[-]?+[0-9]{4}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: text)
        return result
    }
    
    static func validateEmailAddress(text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
    
    static func validateZipCode(text: String?) -> Bool {
        guard let input = text else {
            return false
        }
        return NSPredicate(format: "SELF MATCHES %@", "^\\d{5}(?:[-\\s]?\\d{4})?$").evaluate(with: input.uppercased())
    }
}
