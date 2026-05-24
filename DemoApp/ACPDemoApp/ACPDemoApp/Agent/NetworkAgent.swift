//
//  NetworkAgent.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 22/03/2026.
//

import Foundation
import ACPKit
import UIKit

public final class NetworkAgent: Agent {
    private let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public func ask(_ query: String) async throws -> AgentResponse {
        
        var request = URLRequest(url: baseURL.appendingPathComponent("api/chat"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ✅ Locus expected format
        let userId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        let body: [String: Any] = [
            "userId": userId,   // 👈 REQUIRED
            "selectedModel": "claude",
            "messages": [
                [
                    "role": "user",
                    "content": query,
                    "parts": [
                        ["type": "text", "text": query]
                    ]
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // 🔥 DEBUG
        print(String(data: data, encoding: .utf8) ?? "")
        
        // TEMP: extract message manually (since Locus doesn't return AgentResponse)
        let message = extractMessage(from: data)
        
        return AgentResponse(
            message: message,
            suggestedProductIDs: nil,
            actions: nil
        )
    }
    
    private func extractMessage(from data: Data) -> String {
        do {
            let response = try JSONDecoder().decode(AgentResponse.self, from: data)
            return response.message
        } catch {
            print("Decoding error:", error)
            return "Sorry, couldn't decode response."
        }
    }
}
