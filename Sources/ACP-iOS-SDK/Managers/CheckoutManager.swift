//
//  File.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation

/// DTOs for checkout endpoints (adjust to match MCP server contract)
public struct CreateCheckoutRequest: Codable {
    public let cartID: String
    public init(cartID: String) { self.cartID = cartID }
}

public struct CreateCheckoutResponse: Codable {
    public let checkoutID: String
    public let amount: Decimal
}

/// CheckoutManager that uses MCPNetworkClient and PSP adapter
public final class CheckoutManager {
    private let client: MCPNetworkClient
    private let pspAdapter: ACPPSPAdapter

    public init(client: MCPNetworkClient, pspAdapter: ACPPSPAdapter) {
        self.client = client
        self.pspAdapter = pspAdapter
    }

    /// Start a checkout session on the MCP server for the given cart ID.
    /// - Returns: CheckoutSession (contains id, amount)
    public func start(cartID: String) async throws -> CheckoutSession {
        let req = CreateCheckoutRequest(cartID: cartID)
        let resp = try await client.post("/acp/checkout", body: req, as: CreateCheckoutResponse.self)
        return CheckoutSession(id: resp.checkoutID, total: resp.amount)
    }

    /// Orchestrate full checkout: ask PSP to tokenize and then finalize on MCP
    /// - Parameter session: CheckoutSession returned from `start`
    public func complete(session: CheckoutSession) async throws {
        // 1) Ask PSP to tokenize payment for this checkout
        let token = try await pspAdapter.tokenizePayment(checkoutID: session.id, amount: session.total)

        // 2) Send token to MCP to finalize payment
        let payload = ["payment_token": token]
        // Adjust expected response shape per your MCP; here we just POST and ignore response body
        _ = try await client.post("/acp/checkout/\(session.id)/complete", body: payload, as: [String: String].self)
    }
}

