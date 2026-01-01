//
//  CartViewModel.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 08/12/2025.
//

import Foundation
import ACPKit
import Combine


@MainActor
final class CartViewModel: ObservableObject {
    
    @Published private(set) var items: [CartItem] = []
    
    func add(product: Product) {
        if let index = items.firstIndex(where: { $0.productID == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(
                CartItem(productID: product.id, quantity: 1)
            )
        }
    }
    
    func clear() {
        items.removeAll()
    }
    
    /// UI adapter
    func viewData(products: [Product]) -> [CartItemViewData] {
        items.compactMap { item -> CartItemViewData? in
            guard let product = products.first(where: { $0.id == item.productID }) else {
                return nil
            }

            return CartItemViewData(
                id: product.id,
                name: product.name,
                price: product.price,
                quantity: item.quantity
            )
        }
    }

    
}
