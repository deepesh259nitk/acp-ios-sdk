//
//  CheckoutManager.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation

/// Orchestrates checkout flow
public class CheckoutManager {

    private let mcpBaseURL: String
    private let cart: CartManager
    private let pspAdapter: ACPPSPAdapter

    public init(mcpBaseURL: String, cart: CartManager, pspAdapter: ACPPSPAdapter) {
        self.mcpBaseURL = mcpBaseURL
        self.cart = cart
        self.pspAdapter = pspAdapter
    }

    /// Start checkout session
    public func start(cartID: String) async throws -> CheckoutSession {
        // Mock session creation
        return CheckoutSession(id: UUID().uuidString, total: cart.total)
    }

    /// Complete checkout with PSP token
    public func complete(sessionID: String, paymentToken: String) async throws {
        // Mock completion
        print("Checkout \(sessionID) completed with token: \(paymentToken)")
    }
}

