//
//  CartManagerTests.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import XCTest
@testable import ACPKit

final class CartManagerTests: XCTestCase {

    func testAddRemoveItems() throws {
        let cart = CartManager()
        try cart.add(productID: "p1", quantity: 2)
        XCTAssertEqual(cart.items.count, 1)
        XCTAssertEqual(cart.items.first?.quantity, 2)

        cart.remove(productID: "p1")
        XCTAssertEqual(cart.items.count, 0)
    }

    func testTotalCalculation() throws {
        let cart = CartManager()
        try cart.add(productID: "p1", quantity: 2)
        try cart.add(productID: "p2", quantity: 1)
        XCTAssertEqual(cart.total, 150) // 3 items * 50 mock price
    }
}
