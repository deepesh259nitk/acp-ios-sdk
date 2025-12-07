//
//  CartManager.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation

/// Handles cart operations
public class CartManager {

    private(set) public var items: [CartItem] = []

    public init() {}

    public func add(productID: String, quantity: Int = 1) throws {
        guard quantity > 0 else { throw ACPError.invalidResponse }
        if let index = items.firstIndex(where: { $0.productID == productID }) {
            items[index].quantity += quantity
        } else {
            items.append(CartItem(productID: productID, quantity: quantity))
        }
    }

    public func remove(productID: String) {
        items.removeAll { $0.productID == productID }
    }

    public var total: Decimal {
        // Simple mock calculation
        return items.reduce(0) { $0 + Decimal($1.quantity) * 50 } // Assume 50 each
    }

    public func clear() {
        items.removeAll()
    }
}
