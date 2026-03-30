//
//  CheckoutView.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 22/02/2026.
//
import SwiftUI
import Stripe
import StripePaymentSheet

struct CheckoutView: View {

    @StateObject private var stripeAdapter = StripePSPAdapter()
    @State private var showPaymentSheet = false

    var body: some View {
        VStack {
            Button("Pay $10") {
                Task {
                    do {
                        try await stripeAdapter.preparePayment(amount: 1000)
                        showPaymentSheet = true
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .paymentSheet(
            isPresented: $showPaymentSheet,
            paymentSheet: stripeAdapter.paymentSheet!,   // ✅ Force unwrap
            onCompletion: { result in
                stripeAdapter.paymentResult = result
            }
        )
    }
}
