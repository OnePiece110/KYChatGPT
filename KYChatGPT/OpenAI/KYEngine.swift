//
//  KYEngine.swift
//  KYChatGPT
//
//  Created by Keyon on 2023/2/15.
//

import SwiftUI
import Foundation

enum KYEngine: Codable {
    case davinci
    case curie
    case babbage
    case ada
    case DALLE
    
    
    var model: KYOpenAIModelType.GPT3 {
        switch self {
        case .davinci: return .davinci
        case .curie: return .curie
        case .babbage: return .babbage
        case .ada: return .ada
        default: return .davinci
        }
    }
    
    var name: String {
        switch self {
        case .davinci: return "davinci"
        case .curie: return "curie"
        case .babbage: return "babbage"
        case .ada: return "ada"
        case .DALLE: return "dallE"
        }
    }
    
    var description: String {
        switch self {
        case .davinci: return "Most capable"
        case .curie: return "Powerful, yet fast"
        case .babbage: return "Straightforward tasks"
        case .ada: return "Fast and simple"
        case .DALLE: return "Magic in moments"

        }
    }
    
    var color: Color {
        switch self {
        case .davinci: return .mint
        case .curie: return .purple
        case .babbage: return .green
        case .ada: return Color(red: 1, green: 0.2, blue: 0.6)
        case .DALLE: return .blue
        }
    }
}
