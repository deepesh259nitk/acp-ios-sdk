//
//  ACPActionRouter.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 24/05/2026.
//

import Foundation
import SwiftUI
import ACPKit
import Combine

@MainActor
public final class ACPActionRouter: ObservableObject {

    private let acp: ACPClient

    // UI state
    @Published public var products: [Product] = []
    @Published public var cartUpdated: Bool = false
    @Published public var showCheckout: Bool = false
    @Published public var paymentAmount: Decimal?

    public init(acp: ACPClient) {
        self.acp = acp
    }

    // MAIN ENTRY POINT
    public func handle(_ response: AgentResponse) async {
        await processActions(response.actions ?? [])
    }
}

private extension ACPActionRouter {

    func processActions(_ actions: [AgentAction]) async {

        for action in actions {

            switch action {

            case .showProducts(let ids):
                await loadProducts(ids)

            case .addToCart(let ids):
                await addToCart(ids)

            case .removeFromCart(let ids):
                removeFromCart(ids)

            case .checkout:
                await startCheckout()

            case .showPaymentSheet(let amount):
                paymentAmount = amount
                showCheckout = true

            case .openProduct(let id):
                print("Navigate to product:", id)

            case .navigate(let route):
                print("Navigate to:", route)
            }
        }
    }
}

private extension ACPActionRouter {

    func loadProducts(_ ids: [String]) async {
        do {
            let all = try await acp.product.list()

            self.products = all.filter { ids.contains($0.id) }

        } catch {
            print("Failed to load products:", error)
        }
    }
}

private extension ACPActionRouter {

    func addToCart(_ ids: [String]) async {
        do {
            for id in ids {
                try acp.cart.add(productID: id, quantity: 1)
            }

            cartUpdated = true

        } catch {
            print("Cart error:", error)
        }
    }

    func removeFromCart(_ ids: [String]) {
        ids.forEach { acp.cart.remove(productID: $0) }
    }
}

private extension ACPActionRouter {

    func startCheckout() async {
        do {
            let session = try await acp.checkout.start(cartID: "default")
            paymentAmount = session.total
            showCheckout = true

        } catch {
            print("Checkout failed:", error)
        }
    }
}
