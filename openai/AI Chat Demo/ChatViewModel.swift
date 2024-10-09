//
//  ChatViewModel.swift
//  AI Chat Demo
//
//  Created by Zigao Wang on 10/9/24.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var isLoading = false
    private let urlString = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(_ message: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        guard let apiKey = SecretsManager.shared.apiKey else {
            completion(.failure(NSError(domain: "APIKeyError", code: 0, userInfo: [NSLocalizedDescriptionKey: "API Key not found"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": message]
            ],
            "max_tokens": 150
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        isLoading = true
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
                    } else {
                        completion(.failure(URLError(.cannotParseResponse)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
