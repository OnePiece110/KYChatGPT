//
//  KYMessageRowView.swift
//  KYChatGPT
//
//  Created by Keyon on 2023/2/15.
//

import SwiftUI

struct KYMessageRowView: View {
    @Environment(\.colorScheme) private var colorScheme
    let message: KYMessageRow
    
    
    var imageSize: CGSize {
        return CGSize(width: 25, height: 25)
    }
    
    var body: some View {
        VStack {
            messageRow(text: message.sendText, image: message.sendImage, bgColor: colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
            
            if let text = message.responseText {
                Divider()
                messageRow(text: text, image: message.responseImage, bgColor: colorScheme == .light ? .gray.opacity(0.1) : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 1), responseError: message.responseError, showDotLoading: message.isInteractingWithChatGPT)
                Divider()
            }
        }
    }
    
    func messageRow(text: String, image: String, bgColor: Color, responseError: String? = nil, showDotLoading: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 24) {
            messageRowContent(text: text, image: image, responseError: responseError, showDotLoading: showDotLoading)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .backgroundStyle(bgColor)
    }
    
    @ViewBuilder
    func messageRowContent(text: String, image: String, responseError: String? = nil, showDotLoading: Bool = false) -> some View {
        if image.hasPrefix("http"), let url = URL(string: image) {
            AsyncImage(url: url) { image in
                image.resizable().frame(width: imageSize.width, height: imageSize.height)
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(image)
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
        }
        
        VStack(alignment: .leading) {
            if !text.isEmpty {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .textSelection(.enabled)
            }
            
            if let error = responseError {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.leading)
            }
            
            if showDotLoading {
                KYDotLoadingView()
                    .frame(width: 60, height: 30)
                
            }
        }
    }
    
}

struct MessageRowView_Previews: PreviewProvider {
    
    static let message = KYMessageRow(
        isInteractingWithChatGPT: true, sendImage: "profile",
        sendText: "What is SwiftUI?",
        responseImage: "openai",
        responseText: "SwiftUI is a user interface framework that allows developers to design and develop user interfaces for iOS, macOS, watchOS, and tvOS applications using Swift, a programming language developed by Apple Inc.")
    
    static let message2 = KYMessageRow(
        isInteractingWithChatGPT: false, sendImage: "profile",
        sendText: "What is SwiftUI?",
        responseImage: "openai",
        responseText: "",
        responseError: "ChatGPT is currently not available")
        
    static var previews: some View {
        NavigationStack {
            ScrollView {
                KYMessageRowView(message: message)
                    
                KYMessageRowView(message: message2)
                  
            }
            .frame(width: 400)
            .previewLayout(.sizeThatFits)
        }
    }
}
