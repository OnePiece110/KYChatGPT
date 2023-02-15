//
//  KYMessageRow.swift
//  KYChatGPT
//
//  Created by Keyon on 2023/2/15.
//

import Foundation

struct KYMessageRow: Identifiable {
    let id = UUID()
    
    var isInteractingWithChatGPT: Bool
    
    let sendImage: String
    let sendText: String
    
    let responseImage: String
    var responseText: String
    
    var responseError: String?
    
}
