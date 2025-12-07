//
//  MCPNetworkClientTests.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import XCTest
@testable import ACP_iOS_SDK // replace appropriately

final class MCPNetworkClientTests: XCTestCase {
    func testMockMCPGetAndPost() async throws {
        let mock = MockMCPNetworkClient()

        // Register sample GET response
        let products = [ProductDTO(id: "p1", title: "Shirt", price: Decimal(50))]
        try mock.registerGetResponse("/acp/products", value: products)

        let fetched: [ProductDTO] = try await mock.get("/acp/products", as: [ProductDTO].self)
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.id, "p1")

        // Register POST response for creating checkout
        let createResp = CreateCheckoutResponse(checkoutID: "co_123", amount: Decimal(100))
        try mock.registerPostResponse("/acp/checkout", value: createResp)

        let req = CreateCheckoutRequest(cartID: "cart_1")
        let resp: CreateCheckoutResponse = try await mock.post("/acp/checkout", body: req, as: CreateCheckoutResponse.self)
        XCTAssertEqual(resp.checkoutID, "co_123")
    }
}

