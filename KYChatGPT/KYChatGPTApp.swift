//
//  KYChatGPTApp.swift
//  KYChatGPT
//
//  Created by Keyon on 2023/2/15.
//

import SwiftUI

@main
struct KYChatGPTApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                KYChatContentView(vm: KYOpenAIViewModel())
            }
        }
    }
}
