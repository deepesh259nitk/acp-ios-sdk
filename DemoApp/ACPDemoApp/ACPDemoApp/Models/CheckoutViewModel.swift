//
//  CheckoutViewModel.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 08/12/2025.
//

import Foundation
import ACPKit
import Combine

@MainActor
final class CheckoutViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var successMessage: String?
    @Published var errorMessage: String?

    private let client: ACPClient
    private let psp: ACPPSPAdapter

    init(client: ACPClient, psp: ACPPSPAdapter) {
        self.client = client
        self.psp = psp
    }

    func checkout(items: [CartItem]) async {
        isLoading = true
        defer { isLoading = false }

        do {
            // 1) Tell backend we want to create a checkout
            let cartID = "demo-cart-id"
            let checkoutSession = try await client.checkout.start(cartID: cartID)

            // 2) Tokenize payment using PSP adapter (Mock)
            let token = try await psp.tokenizePayment(checkoutID: cartID, amount: checkoutSession.total)
            
            // 3) Finalize payment with backend
            
            let confirm = try await client.checkout.complete(session: checkoutSession)
            successMessage = "Payment successful! ID: \(checkoutSession.id)"
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

