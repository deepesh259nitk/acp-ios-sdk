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
