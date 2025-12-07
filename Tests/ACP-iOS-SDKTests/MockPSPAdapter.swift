//
//  MockPSPAdapter.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation
@testable import ACP_iOS_SDK

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
