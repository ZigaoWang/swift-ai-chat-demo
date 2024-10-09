//
//  MessageView.swift
//  AI Chat Demo
//
//  Created by Zigao Wang on 10/9/24.
//

import SwiftUI

struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            Text(message.content)
                .padding()
                .background(message.isUser ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            
            if !message.isUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: Message(content: "Hello, World!", isUser: true))
    }
}
