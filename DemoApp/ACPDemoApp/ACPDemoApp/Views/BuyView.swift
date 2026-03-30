//
//  BuyView.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 22/02/2026.
//

import SwiftUI
import StripePaymentSheet
import Stripe
import ACPKit

struct BuyView: View {
    
    @StateObject private var stripeAdapter = StripePSPAdapter()
    @State private var showPaymentSheet = false
    @State private var intent: StructuredIntent?

    var body: some View {
        VStack(spacing: 20) {

            Text("LLM Intent: \(intent?.action)")
                .padding()

            Button("Locus Button") {
                Task {
                    await locusButtonTapped()
                }
            }
        }
        // ✅ Attach PaymentSheet only when paymentSheet exists
        .overlay {
            if let paymentSheet = stripeAdapter.paymentSheet {
                // Stripe SwiftUI modifier
                Color.clear
                    .paymentSheet(
                        isPresented: $showPaymentSheet,
                        paymentSheet: paymentSheet,
                        onCompletion: handlePaymentResult
                    )
            } else {
                Text("paymentSheet is empty")
            }
        }
    }

    
    
    
    // MARK: - Button Action
    func locusButtonTapped() async {
        
        let url = URL(string: "http://localhost:3000/")!
        let agent = NetworkAgent(baseURL: url)
        do {
            let response = try await agent.ask("Show me shoes under $200")
            print(response.message)
        } catch (let error){
            print(error)
        }
        
    }
    
    func buyButtonTapped() async {
        do {
            // 1️⃣ Call your LLM / Intent processor
            let userIntent = try await processUserMessage(
                "Buy running shoes under 200 dollars"
            )
            intent = userIntent
            print("LLM Intent:", userIntent)

            // 2️⃣ Call MCP search (your existing client)
            // let products = try await mcpClient.search(...)

            STPAPIClient.shared.publishableKey = "pk_test_51T3h29LmdLCNHDm7ABXbaM6dCNtrPyyS6ZYY7SCA5YRWicdPIsQF6m6pkaNxIM9mrusNV3UKAMoh8zB3k6e5Zpgs00doXwuzzr"
            
            // 3️⃣ Prepare Stripe payment
            Task {
                do {
                    try await stripeAdapter.preparePayment(amount: 15000)

                    // Wait for the PaymentSheet to exist
                    guard stripeAdapter.paymentSheet != nil else {
                        print("PaymentSheet still nil")
                        return
                    }

                    // Show PaymentSheet on main thread
                    DispatchQueue.main.async {
                        showPaymentSheet = true
                    }
                } catch {
                    print("Error preparing payment:", error)
                }
            }
        } catch {
            print("Error:", error)
        }
    }

    // MARK: - Payment Result
    func handlePaymentResult(_ result: PaymentSheetResult) {
        switch result {
        case .completed:
            print("✅ Payment success")
            // Call MCP checkout.complete() here
        case .failed(let error):
            print("❌ Payment failed:", error)
        case .canceled:
            print("⚠️ Payment canceled")
        }
    }
}
