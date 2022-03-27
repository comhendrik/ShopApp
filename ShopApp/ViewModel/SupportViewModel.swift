//
//  SupportViewModel.swift
//  ShopApp
//
//  Created by Hendrik Steen on 27.03.22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

protocol SupportCasesProtocol {
    var stringDescription: String { get }
    var caseStringDescription: String { get }
}
enum SupportCases: CaseIterable, SupportCasesProtocol {
    case wrongSize
    case wrongArticle
    case notLikeExpected
    case qualityProblems
    case alreadyWorn
    case newPrice
    case noSpecificReason
    
    var stringDescription: String {
        return self.getDescription()
    }
    
    var caseStringDescription: String {
        return self.getCaseDescription()
    }
    
    func getDescription() -> String {
        switch self {
        case .wrongSize:
            return "wrong Size"
        case .wrongArticle:
            return "wrong Article"
        case .notLikeExpected:
            return "not like expected"
        case .qualityProblems:
            return "problems with Quality"
        case .alreadyWorn:
            return "article is already worn"
        case .newPrice:
            return "there is a new price for the article"
        case .noSpecificReason:
            return "no specific reason for return"
        }
    }
    
    func getCaseDescription() -> String {
        switch self {
        case .wrongSize:
            return "wrongSize"
        case .wrongArticle:
            return "wrongArticle"
        case .notLikeExpected:
            return "notLikeExpected"
        case .qualityProblems:
            return "qualityProblems"
        case .alreadyWorn:
            return "alreadyWorn"
        case .newPrice:
            return "newPrice"
        case .noSpecificReason:
            return "noSpecificReason"
        }
    }
}

class SupportViewModel: ObservableObject {
    @Published var supportCase: SupportCases = .noSpecificReason
    @Published var supportMessage: String = ""
    @Published var itemID: String = ""
    @Published var alert: Bool = false
    @Published var alertMsg: String = ""
    
    
    func createSupportRequest(idOfOrder: String) {
        if itemID == "" {
            alertMsg = "Please select an item."
            alert.toggle()
            return
        }
        let requestID = Firestore.firestore().collection("Support").addDocument(data: ["supportCase" : supportCase.caseStringDescription,
                                                                       "userID": userID,
                                                                       "supportMessage": supportMessage,
                                                                       "dateOfRequest": Date.now,
                                                                       "orderID": idOfOrder,
                                                                       "itemID": itemID]).documentID
        alertMsg = "Your support request about the item \(itemID) of the your order \(idOfOrder) with the support Case \(supportCase.caseStringDescription) has been sent succesfully! \n requestID:\(requestID)"
        alert.toggle()
    }
}
