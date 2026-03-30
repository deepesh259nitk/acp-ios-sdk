//
//  AgentResponse.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 22/02/2026.
//
import Foundation

struct AgentLLMResponse: Decodable {
    let structured_intent: String
}

//func processUserMessage(_ message: String) async throws -> String {
//    let url = URL(string: "http://localhost:4242/agent/process")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    
//    do {
//        request.httpBody = try JSONEncoder().encode(["message": message])
//    } catch {
//        print("❌ Failed to encode JSON body:", error)
//        throw error
//    }
//    
//    do {
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        // Check for HTTP response status
//        if let httpResponse = response as? HTTPURLResponse {
//            guard (200...299).contains(httpResponse.statusCode) else {
//                let body = String(data: data, encoding: .utf8) ?? "<no body>"
//                print("❌ HTTP error \(httpResponse.statusCode): \(body)")
//                throw URLError(.badServerResponse)
//            }
//        }
//        
//        // Decode JSON response
//        do {
//            let decoded = try JSONDecoder().decode(AgentLLMResponse.self, from: data)
//            return decoded.structured_intent
//        } catch {
//            let body = String(data: data, encoding: .utf8) ?? "<no body>"
//            print("❌ Failed to decode JSON. Response body:\n\(body)")
//            throw error
//        }
//        
//    } catch {
//        print("❌ URLSession request failed:", error)
//        throw error
//    }
//}


func processUserMessage(_ message: String) async throws -> StructuredIntent {
    print("Received user message:", message)
    
    // Hardcoded structured intent
    let intent = StructuredIntent(
        action: "buy",
        product: "running shoes",
        maxPriceCents: 20000 // $200 in cents
    )
    
    return intent
}
