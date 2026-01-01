//
//  ACPPSPAdapter.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation

/// Protocol defining a Payment Service Provider adapter
public protocol ACPPSPAdapter {
    /// Tokenizes a payment for a given checkout session
    /// - Parameters:
    ///   - checkoutID: ACP checkout session ID
    ///   - amount: total amount
    /// - Returns: Delegated payment token
    /// - Throws: ACPError if tokenization fails
    func tokenizePayment(checkoutID: String, amount: Decimal) async throws -> String

    /// Handles PSP-specific payment results (optional)
    func handlePaymentResult(_ result: PSPResult)
}

/// Mock PSP Adapter for testing without real PSP
public class MockPSPAdapter: ACPPSPAdapter {
    public init() {}

    public func tokenizePayment(checkoutID: String, amount: Decimal) async throws -> String {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        return "mock_token_\(UUID().uuidString)"
    }

    public func handlePaymentResult(_ result: PSPResult) {
        switch result {
        case .success(let token): print("Mock PSP success: \(token)")
        case .failure(let error): print("Mock PSP failure: \(error)")
        case .cancelled: print("Mock PSP cancelled")
        }
    }
}
