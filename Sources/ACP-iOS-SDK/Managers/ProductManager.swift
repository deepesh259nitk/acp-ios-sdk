//
//  File.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//
import Foundation

/// Product model used by SDK (decodable/encodable friendly)
public struct ProductDTO: Codable {
    public let id: String
    public let title: String
    public let description: String?
    public let price: Decimal
    public let currency: String?

    public init(id: String, title: String, description: String? = nil, price: Decimal, currency: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.currency = currency
    }
}

/// ProductManager now uses a protocol MCPNetworkClient to fetch products.
public final class ProductManager {
    private let client: MCPNetworkClient

    /// Initialize with an MCPNetworkClient (URLSession or Mock)
    public init(client: MCPNetworkClient) {
        self.client = client
    }

    /// Fetches all products from the MCP `/acp/products` endpoint.
    /// - Returns: Array of ProductDTO
    /// - Throws: MCPNetworkError if network or decoding fails
    public func list() async throws -> [ProductDTO] {
        // The path is the relative path per ACP spec; adjust if MCP uses a different path
        return try await client.get("/acp/products", as: [ProductDTO].self)
    }

    /// Search (simple implementation): call MCP search endpoint or filter locally.
    public func search(query: String) async throws -> [ProductDTO] {
        // Try server-side search endpoint first (optional)
        do {
            return try await client.get("/acp/products?search=\(urlEncode(query))", as: [ProductDTO].self)
        } catch {
            // Fallback: fetch all and filter locally
            let all = try await list()
            return all.filter { $0.title.localizedCaseInsensitiveContains(query) || ($0.description?.localizedCaseInsensitiveContains(query) ?? false) }
        }
    }

    private func urlEncode(_ s: String) -> String {
        return s.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? s
    }
}
