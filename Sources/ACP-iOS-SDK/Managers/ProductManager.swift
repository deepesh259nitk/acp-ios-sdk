//
//  ProductManager.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation

/// Handles product listing and search
public class ProductManager {

    private let mcpBaseURL: String

    public init(mcpBaseURL: String) {
        self.mcpBaseURL = mcpBaseURL
    }

    /// Fetch all products
    public func list() async throws -> [Product] {
        // Mock implementation
        return [
            Product(id: "p1", name: "Shirt", price: 49.99),
            Product(id: "p2", name: "Pants", price: 79.99)
        ]
    }

    /// Search products via agent or MCP
    public func search(_ query: String) async throws -> [Product] {
        // Mock implementation
        return try await list().filter { $0.name.lowercased().contains(query.lowercased()) }
    }
}
