//
//  UWInitializer.swift
//  Urway
//
//  Copyright © 2020 URWAY. All rights reserved.
//

import Foundation
import UIKit
import PassKit

public enum pickerType: String {
    case add = "Add"
    case update = "Update"
    case delete = "Delete"
    
    func getValue() -> String {
        switch self {
        case .add:
            return "A"
        case .update:
            return "U"
        case .delete:
            return "D"
        }
    }
}

public class UWInitializer {
    var amount: String = ""
    var email: String = ""
    var currency: String = ""
    var country: String = ""
    var actionCode: String = ""
    var trackIdCode: String = ""
    
    var createTokenIsEnabled: Bool?
    var merchantIP: String?
    var address: String?
    var city: String?
    var cardToken: String?
    var cardOperation: String!
    var state: String?
    var zipCode: String?
    var udf1: String?
    var udf2: String?
    var udf3: String?
    var udf4: String?
    var udf5: NSString?
    var transid: String?
    
    var merchantidentifier: String?
    var tokenizationType: String?
    var holderName: String? = ""
    
    
    public init(amount: String ,
         email: String ,
         zipCode: String? = nil ,
         currency: String ,
         country: String ,
         actionCode: String,
         trackIdCode: String,
         udf1: String? = nil ,
         udf2: String? = nil ,
         udf3: String? = nil ,
         udf4: String? = nil ,
         udf5: NSString? = nil ,
         city: String? = nil ,
         address: String? = nil,
         createTokenIsEnabled: Bool? = true,
         merchantIP: String? = nil,
         cardToken: String? = nil,
         cardOper: String,
         state: String? = nil,
         transid: String? = nil,
         merchantidentifier: String? = nil,
         tokenizationType: String){
//         ,
//         holderName: String? = nil) {
        
        
        self.amount = amount
        self.email = email
        self.zipCode = zipCode
        self.currency = currency
        self.country = country
        self.actionCode = actionCode
        
        self.trackIdCode = trackIdCode
        
        self.udf1 = udf1
        self.udf2 = udf2
        self.udf3 = udf3
        self.udf4 = udf4
        self.udf5 = udf5
        
        self.state = state
        self.city = city
        self.address = address
        
        self.createTokenIsEnabled = createTokenIsEnabled
        self.merchantIP = merchantIP
        self.cardToken = cardToken
        self.cardOperation = cardOper
        self.state = state
        
        self.tokenizationType = tokenizationType
        self.transid=transid
        self.merchantidentifier = merchantidentifier
        //self.holderName = holderName
    }
    
    public static func generatePaymentKey(payment: PKPayment) -> NSString {
        
        let data12 = payment.token.paymentData
        let method = payment.token.paymentMethod
        
        if let jsonString = NSString(data: data12, encoding: .zero) {
            
            let prefixString: NSString = "\("{ \"paymentData\"  : ")" as NSString
            let finalSuffixString: NSString = """
                , "paymentMethod": {
                "displayName": "\(method.displayName ?? "")",
                "network": "\(method.network?.rawValue ?? "")",
                "type": "debit"
                },
                "transactionIdentifier": "\(payment.token.transactionIdentifier)" }
                """ as NSString
            
            let combinderString: NSString = "\(prefixString) \(jsonString) \(finalSuffixString)" as NSString
            return combinderString
        }
        
        return ""
    }

}

