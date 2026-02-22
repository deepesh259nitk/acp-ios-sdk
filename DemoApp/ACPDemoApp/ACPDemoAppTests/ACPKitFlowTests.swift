//
//  ACPKitFlowTests.swift
//  ACPDemoAppTests
//
//  Created by Deepesh Vasthimal on 20/01/2026.
//

import XCTest
@testable import ACPKit

final class ACPKitFlowTests: XCTestCase {

    func testEndToEndMockFlow() async throws {
        let mockMCP = MockMCPNetworkClient()

        try mockMCP.registerGetResponse(
            "/acp/products",
            value: [
                ProductDTO(id: "p1", title: "Shirt", price: Decimal(50))
            ]
        )

        try mockMCP.registerPostResponse(
            "/acp/checkout",
            value: CreateCheckoutResponse(
                checkoutID: "co_1",
                amount: Decimal(50),
                currency: "GBP"
            )
        )

        let mockAgent = MockAgent(responses: [
            "shirt": AgentResponse(message: "Here are shirts", suggestedProductIDs: ["p1"])
        ])

        let acp = ACPClient(
            mcpClient: mockMCP,
            agent: mockAgent,
            pspAdapter: MockPSPAdapter()
        )

        let products = try await acp.product.list()
        XCTAssertEqual(products.count, 1)

        try acp.cart.add(productID: "p1", quantity: 1)

        let session = try await acp.checkout.start(cartID: "cart_1")
        try await acp.checkout.complete(session: session)
    }
}
