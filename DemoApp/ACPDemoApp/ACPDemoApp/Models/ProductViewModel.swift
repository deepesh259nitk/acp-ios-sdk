//
//  ProductViewModel.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 08/12/2025.
//
import Foundation
import ACPKit
import Combine

@MainActor
final class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: String?

    private let client: ACPClient
    private let cartVM: CartViewModel

    init(client: ACPClient, cartVM: CartViewModel) {
        self.client = client
        self.cartVM = cartVM
    }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await client.product.list()
            self.products = result
        } catch {
            self.error = error.localizedDescription
        }
    }

    func addToCart(_ product: Product) {
        cartVM.add(product: product)
    }
}

