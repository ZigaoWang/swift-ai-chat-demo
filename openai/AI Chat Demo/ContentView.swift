//
//  ContentView.swift
//  AI Chat Demo
//
//  Created by Zigao Wang on 10/9/24.
//

import SwiftUI

struct ContentView: View {
    @State private var messages: [Message] = []
    @State private var inputMessage: String = ""
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages) { message in
                    MessageView(message: message)
                }
            }
            
            HStack {
                TextField("Type a message", text: $inputMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: sendMessage) {
                    Text("Send")
                }
                .disabled(viewModel.isLoading)
            }
            .padding()
        }
    }
    
    func sendMessage() {
        guard !inputMessage.isEmpty else { return }
        
        let userMessage = Message(content: inputMessage, isUser: true)
        messages.append(userMessage)
        
        viewModel.sendMessage(inputMessage) { result in
            switch result {
            case .success(let aiResponse):
                let aiMessage = Message(content: aiResponse, isUser: false)
                messages.append(aiMessage)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                let errorMessage = Message(content: "Sorry, there was an error processing your request.", isUser: false)
                messages.append(errorMessage)
            }
        }
        
        inputMessage = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
