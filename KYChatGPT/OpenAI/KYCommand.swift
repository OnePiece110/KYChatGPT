//
//  KYCommand.swift
//  KYChatGPT
//
//  Created by Keyon on 2023/2/15.
//

import Foundation

class KYCommand: Encodable {
    let prompt: String
    let model: String
    let maxTokens: Int
    
    init(prompt: String, model: String, maxTokens: Int) {
        self.prompt = prompt
        self.model = model
        self.maxTokens = maxTokens
    }
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case model
        case maxTokens = "max_tokens"
    }
}
