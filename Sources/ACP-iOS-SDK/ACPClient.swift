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
    ///   - mcpClient: Merchant MCP Client with base url
    ///   - agent:AgentManager object
    ///   - pspAdapter: PSP adapter implementation
    public init(mcpClient: MCPNetworkClient, agent: Agent, pspAdapter: ACPPSPAdapter) {
        self.psp = pspAdapter
        self.product = ProductManager(client: mcpClient)
        self.cart = CartManager()
        self.checkout = CheckoutManager(client: mcpClient, pspAdapter: pspAdapter)
        self.agent = AgentManager(agent: agent)
    }
}
