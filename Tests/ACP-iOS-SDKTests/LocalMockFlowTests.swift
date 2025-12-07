//
//  LocalMockFlowTests.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import XCTest
@testable import ACP_iOS_SDK

class LocalMockFlowTests: XCTestCase {
    
    func testMockFlow() {
        // Setup for local mock testing
        let mockMCP = MockMCPNetworkClient()
        _ = try! mockMCP.registerGetResponse("/acp/products", value: [ProductDTO(id: "p1", title: "Shirt", price: Decimal(50))])
        _ = try! mockMCP.registerPostResponse("/acp/checkout", value: CreateCheckoutResponse(checkoutID: "co_1", amount: Decimal(50)))

        let mockAgent = MockAgent(responses: ["shirt": AgentResponse(message: "Here are shirts", suggestedProductIDs: ["p1"])])
        let mockPSP = MockPSPAdapter()

        let acp = ACPClient(mcpClient: mockMCP, agent: mockAgent, pspAdapter: mockPSP)

        // Example flow
        Task {
            let products = try await acp.product.list()
            try acp.cart.add(productID: "p1", quantity: 1)
            let session = try await acp.checkout.start(cartID: "cart_1")
            try await acp.checkout.complete(session: session)
            print("Done")
        }
    }
    

}
