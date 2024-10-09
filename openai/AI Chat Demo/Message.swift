//
//  Message.swift
//  AI Chat Demo
//
//  Created by Zigao Wang on 10/9/24.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}
