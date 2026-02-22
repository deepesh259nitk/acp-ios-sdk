//
//  MockMCPNetworkClient.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 01/01/2026.
//

import ACPKit
import Foundation

public final class MockMCPNetworkClient: MCPNetworkClient {
    
    private var getResponses: [String: Any] = [:]
    private var postResponses: [String: Any] = [:]
    
    // MARK: - Registration APIs (Mock-only)
    
    public func registerGetResponse<T: Encodable>(_ path: String, value: T) throws {
        getResponses[path] = try JSONEncoder().encode(value)
    }
    
    public func registerPostResponse<T: Encodable>(_ path: String, value: T) throws {
        postResponses[path] = try JSONEncoder().encode(value)
    }
    
    
    public func get<T>(
        _ path: String,
        as type: T.Type
    ) async throws -> T where T : Decodable {

        switch path {

        case "/acp/products":
            let products = [
                ProductDTO(
                    id: "p1",
                    title: "Shirt",
                    description: "Red T-Shirt",
                    price: 29.99,
                    currency: "GBP"
                ),
                ProductDTO(
                    id: "p2",
                    title: "Shoes",
                    description: "Running shoes",
                    price: 89.99,
                    currency: "GBP"
                )
            ]

            // Encode + decode to simulate real network behavior
            let data = try JSONEncoder().encode(products)
            return try JSONDecoder().decode(T.self, from: data)

        default:
            throw MCPNetworkError.invalidURL(
                "No mock GET response for path: \(path)"
            )
        }
    }

    
    public func post<Body, Response>(
        _ path: String,
        body: Body,
        as type: Response.Type
    ) async throws -> Response
    where Body: Encodable, Response: Decodable {

        // 1️⃣ Handle checkout creation
        if path == "/acp/checkout" {
            let response = CreateCheckoutResponse(
                checkoutID: "chk_123",
                amount: Decimal(49.99),
                currency: "GBP"
            )
            let data = try JSONEncoder().encode(response)
            return try JSONDecoder().decode(Response.self, from: data)
        }

        // 2️⃣ Handle dynamic checkout completion paths
        if path.starts(with: "/acp/checkout/") && path.hasSuffix("/complete") {
            let response = CompleteCheckoutResponse(status: "succeeded")
            let data = try JSONEncoder().encode(response)
            return try JSONDecoder().decode(Response.self, from: data)
        }

        // 3️⃣ Fallback
        throw MCPNetworkError.invalidURL(
            "No mock POST response for path: \(path)"
        )
    }

    public init() {}

    // This simulates fetching products from a local mock
    public func listProducts() async throws -> [Product] {
        return [
            Product(id: "p1", name: "Shirt", price: 29.99, description: "Red T-Shirt", currency: "GBP"),
            Product(id: "p2", name: "Shoes", price: 89.99, description: "Running shoes", currency: "GBP"),
            Product(id: "p3", name: "Hat", price: 15.50, description: "Summer hat", currency: "GBP")
        ]
    }
}
