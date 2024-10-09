//
//  SecretsManager.swift
//  AI Chat Demo
//
//  Created by Zigao Wang on 10/9/24.
//

import Foundation

class SecretsManager {
    static let shared = SecretsManager()
    
    private init() {}
    
    var apiKey: String? {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let apiKey = dict["API_KEY"] as? String else {
            return nil
        }
        return apiKey
    }
}
