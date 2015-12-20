//
//  ValidatorEmail.swift
//  validate
//
//  Created by Danilo Topalovic on 20.12.15.
//  Copyright © 2015 Danilo Topalovic. All rights reserved.
//

import Foundation

public class ValidatorEmail: BaseValidator, ValidatorProtocol {
    
    /// length of the local part
    private static let maxLengthLocalPart: Int = 64
    /// length of the hostname part
    private static let maxLengthHostnamePart: Int = 255
    
    /// Validates the local part of the mail addr (before @)
    var validateLocalPart: Bool = true
    
    /// Validates the hostname part of the mail addr (after @)
    var validateHostnamePart: Bool = true
    
    /// strict check
    var strict: Bool = false
    
    /// generic invalid error message
    var errorMessageInvalidAddress: String = NSLocalizedString("the entered address is invalid", comment: "ValidatorEmail - Invalid address")
    
    /// error message when local part is invalid
    var errorMessageInvalidLocalPart: String = NSLocalizedString("the local part of the mail contains invalid characters", comment: "ValidatorEmail - invalid local part")

    /// error message when hostname part is invalid
    var errorMessageInvalidHostnamePart: String = NSLocalizedString("the hostname part of the mail contains invalid characters", comment: "ValidatorEmail - invalid remote part")
    
    /// error message if the length was exceeded
    var errorMessagePartLengthExceeded: String = NSLocalizedString("the %@ part is too long %i of max %i given", comment: "ValidatorEmail - Length exceeded")
    
    /**
     Easy init
     
     - returns: the instance
     */
    required public init(@noescape _ initializer: ValidatorEmail -> () = { _ in }) {
        
        super.init()
        initializer(self)
    }
    
    /**
     Validares the email address
     
     - parameter value:   the email address
     - parameter context: the context (unused)
     
     - throws: validation errors
     
     - returns: true if ok
     */
    public override func validate<T: Any>(value: T?, context: [String: Any?]?) throws -> Bool {
       
        if let strVal = value as? String {
            
            if !self.validateMailFormat(strVal) {
                return false
            }
            
            let partial = self.splitEmailAddress(strVal)
            let valid   = ((self.doValidateLocalPart(partial.local) || !self.validateLocalPart) && (self.doValidateHostnamePart(partial.hostname) || !self.validateHostnamePart))
            
            return valid
        }
        
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "no valid string value given"])
    }
    
    //MARK: - private functions -
    
    /**
    Validates the local part of the mail
    
    - parameter part: the local part (before @)
    
    - returns: true if ok
    */
    private func doValidateLocalPart(part: String) -> Bool {
        
        if !self.checkLength(part, maxLen: ValidatorEmail.maxLengthLocalPart, what: "local") {
            return false
        }
        
        let charset: NSMutableCharacterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        charset.addCharactersInString("!#$%&'*+-/=?^_`{|}~")
        
        if let _ = part.rangeOfCharacterFromSet(charset.invertedSet) {
            
            return self.returnError(self.errorMessageInvalidLocalPart)
        }
        
        return true
    }
    
    /**
     Validates the hostname part of the mail
     
     - parameter part: the hostname part (after @)
     
     - returns: true of ok
     */
    private func doValidateHostnamePart(part: String) -> Bool {
        
        if !self.checkLength(part, maxLen: ValidatorEmail.maxLengthHostnamePart, what: "hostname") {
            return false
        }
        
        let charset = NSCharacterSet.URLHostAllowedCharacterSet()
        
        if let _ = part.rangeOfCharacterFromSet(charset.invertedSet) {
            
            return self.returnError(self.errorMessageInvalidHostnamePart)
        }
        
        return true
    }
    
    /**
    Validates obvious email issues
    
    - parameter address: the mail addr
    
    - returns: true if ok
    */
    private func validateMailFormat(address: String) -> Bool {
        
        if address.containsString("..") {
            
            return self.returnError(self.errorMessageInvalidAddress)
        }
        
        if !address.containsString("@") {
            
            return self.returnError(self.errorMessageInvalidAddress)
        }
        
        if address.componentsSeparatedByString("@").count > 2 {
            
            return self.returnError(self.errorMessageInvalidAddress)
        }
        
        return true
    }
    
    /**
     Splits the mail addr into local and hostname part
     
     - parameter address: the address
     
     - returns: the tupel
     */
    private func splitEmailAddress(address: String) -> (local: String, hostname: String) {
        
        let parts = address.characters.split{ $0 == "@" }.map(String.init)
        return (parts[0], parts[1])
    }
    
    /**
     Checks the length of a string
     
     - parameter value:  the part
     - parameter maxLen: the maximum length
     - parameter what:   what part (for error msg only)
     
     - returns: true if ok or nonstrict
     */
    private func checkLength(value: String, maxLen: Int, what: String) -> Bool {
        
        if self.strict && value.characters.count > maxLen {
            
            return self.returnError(String(format: self.errorMessagePartLengthExceeded, what, value.characters.count, maxLen))
        }
        
        return true
    }
}
