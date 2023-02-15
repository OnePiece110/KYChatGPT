//
//  KYOpenAIChatModel.swift
//  KYChatGPT
//
//  Created by Keyon on 2023/2/15.
//

import Foundation

public struct KYOpenAIChatModel: Codable {
    public let object: String
    public let model: String?
    public let choices: [KYChoiceModel]
}

public struct KYChoiceModel: Codable {
    public let text: String
}
