//
//  KYInstruction.swift
//  KYChatGPT
//
//  Created by Keyon on 2023/2/15.
//

import Foundation

class KYInstruction: Encodable {
    let instruction: String
    let model: String
    let input: String
    
    init(instruction: String, model: String, input: String) {
        self.instruction = instruction
        self.model = model
        self.input = input
    }
    
    enum CodingKeys: String, CodingKey {
        case instruction
        case model
        case input
    }
}
