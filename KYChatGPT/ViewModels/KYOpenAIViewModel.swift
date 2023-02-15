//
//  KYOpenAIViewModel.swift
//  KYChatGPT
//
//  Created by Keyon on 2023/2/15.
//

import Foundation

class KYOpenAIViewModel: ObservableObject {
    let chatGPT = KYOpenAISwift(authToken: "YOUR-TOKEN")
    let maxTokens = 1000
    let davinciMaxTokens = 4000
    
    @Published var isInteractingWithChatGPT = false
    @Published var messages: [KYMessageRow] = []
    @Published var inputMessage: String = ""
    
    @MainActor
    func sendTapped() async {
        let text = inputMessage
        inputMessage = ""
        await submitRequest(text, engine: .davinci)
    }
    
    @MainActor
    func submitRequest(_ request: String, engine: KYEngine) async {
        isInteractingWithChatGPT = true
        var messageRow = KYMessageRow(
            isInteractingWithChatGPT: true,
            sendImage: "profile",
            sendText: request,
            responseImage: "openai",
            responseText: "")
        self.messages.append(messageRow)
        do {
            let result = try await chatGPT.sendCompletion(
                with: request, model: .gpt3(engine.model),
                maxTokens: engine.model == .davinci ? davinciMaxTokens : maxTokens
            )
            messageRow.responseText = result.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        } catch {
            messageRow.responseText = error.localizedDescription
        }
        
        messageRow.isInteractingWithChatGPT = false
        self.messages[self.messages.count - 1] = messageRow
        self.isInteractingWithChatGPT = false
    }
}
