import UIKit
import CommonCrypto

//https://medium.com/better-programming/10-useful-swift-string-extensions-e4280e55a554

//MD5 Hash Calculator

extension String {
    var md5: String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        
        return (0..<length).map { String(format: "%02x", hash[$0]) }.joined()
    }
}


//Integer Subscripts

/**
 
 let str = "Hello, world"
 print(str[...4]) // "Hello"
 print(str[..<5]) // "Hello"
 print(str[7...]) // "world"
 
 */

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
}

//Checking What’s Inside

/**
 
 let a1 = "12345".containsOnlyDigits // true
 let a2 = "a12345".containsOnlyDigits // false
 let b1 = "abcde".containsOnlyLetters // true
 let b2 = "abcde1".containsOnlyLetters // false
 let c1 = "abcde12345".isAlphanumeric // true
 let c2 = "abcde.12345".isAlphanumeric // false
 
 */

extension String {
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    var containsOnlyLetters: Bool {
        let notLetters = NSCharacterSet.letters.inverted
        return rangeOfCharacter(from: notLetters, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    var isAlphanumeric: Bool {
        let notAlphanumeric = NSCharacterSet.decimalDigits.union(NSCharacterSet.letters).inverted
        return rangeOfCharacter(from: notAlphanumeric, options: String.CompareOptions.literal, range: nil) == nil
    }
}

//Checking If a String Is a Valid Email Address

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension String {
    func matches(_ expression: String) -> Bool {
        if let range = range(of: expression, options: .regularExpression, range: nil, locale: nil) {
            return range.lowerBound == startIndex && range.upperBound == endIndex
        } else {
            return false
        }
    }
    
    var isValidEmail_v2: Bool {
        matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
}

//Separate Characters Into Groups

/**
 
 var cardNumber = "1234567890123456"
 cardNumber.insert(separator: " ", every: 4)
 print(cardNumber)
 // 1234 5678 9012 3456
 let pin = "7690"
 let pinWithDashes = pin.inserting(separator: "-", every: 1)
 print(pinWithDashes)
 // 7-6-9-0
 
 */

extension String {
    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: count, by: n).forEach {
            result += String(characters[$0..<min($0+n, count)])
            if $0+n < count {
                result += separator
            }
        }
        return result
    }
}
