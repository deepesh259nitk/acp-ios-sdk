//
//  StripePaymentSheet.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 22/02/2026.
//

import SwiftUI
import Stripe
import StripePaymentSheet
import Combine

@MainActor
final class StripePSPAdapter: ObservableObject {
    
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    
    func preparePayment(amount: Int) async throws {
        
        let url = URL(string: "http://127.0.0.1:4242/create-payment-intent")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(["amount": amount])
        } catch {
            print("❌ Failed to encode request body:", error)
            throw error
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // ✅ Check HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    let body = String(data: data, encoding: .utf8) ?? "<no body>"
                    print("❌ HTTP Error \(httpResponse.statusCode): \(body)")
                    throw URLError(.badServerResponse)
                }
            }
            
            // ✅ Decode JSON safely
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let clientSecret = json?["clientSecret"] as? String else {
                    print("❌ clientSecret not found in response:", String(data: data, encoding: .utf8) ?? "<no body>")
                    throw URLError(.cannotParseResponse)
                }
                
                // ✅ Configure PaymentSheet
                var config = PaymentSheet.Configuration()
                config.merchantDisplayName = "ACP Demo"
                
                self.paymentSheet = PaymentSheet(
                    paymentIntentClientSecret: clientSecret,
                    configuration: config
                )
                
            } catch {
                let body = String(data: data, encoding: .utf8) ?? "<no body>"
                print("❌ Failed to decode JSON:", error, "\nResponse body:\n", body)
                throw error
            }
            
        } catch {
            print("❌ Network request failed:", error)
            throw error
        }
    }
}
