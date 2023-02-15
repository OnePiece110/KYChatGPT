//
//  KYOpenAIEndpoint.swift
//  KYChatGPT
//
//  Created by Keyon on 2023/2/15.
//

import Foundation

enum KYEndpoint {
    case completions
    case edits
}

extension KYEndpoint {
    var path: String {
        switch self {
        case .completions:
            return "/v1/completions"
        case .edits:
            return "/v1/edits"
        }
    }
    
    var method: String {
        switch self {
        case .completions, .edits:
            return "POST"
        }
    }
    
    func baseURL() -> String {
        switch self {
        case .completions, .edits:
            return "https://api.openai.com"
        }
    }
}
