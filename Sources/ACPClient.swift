//
//  ACPClient.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation

/// Main entry point for ACP iOS SDK
public class ACPClient {

    public let product: ProductManager
    public let cart: CartManager
    public let checkout: CheckoutManager
    public let agent: AgentManager
    public let psp: ACPPSPAdapter

    /// Initialize ACP SDK
    /// - Parameters:
    ///   - mcpBaseURL: Merchant MCP server URL
    ///   - pspAdapter: PSP adapter implementation
    public init(mcpBaseURL: String, pspAdapter: ACPPSPAdapter) {
        self.psp = pspAdapter
        self.product = ProductManager(mcpBaseURL: mcpBaseURL)
        self.cart = CartManager()
        self.checkout = CheckoutManager(mcpBaseURL: mcpBaseURL, cart: cart, pspAdapter: pspAdapter)
        self.agent = AgentManager(mcpBaseURL: mcpBaseURL)
    }
}
