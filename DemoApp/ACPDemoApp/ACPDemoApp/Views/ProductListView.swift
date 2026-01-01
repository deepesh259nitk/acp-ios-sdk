//
//  ProductListView.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 08/12/2025.
//

import SwiftUI
import ACPKit

struct ProductListView: View {
    @StateObject var vm: ProductViewModel

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading Products…")
                } else {
                    List(vm.products, id: \.id) { product in
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .font(.headline)
                            Text("£\(product.price)")
                                .font(.subheadline)

                            Button("Add to Cart") {
                                vm.addToCart(product)
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top, 4)
                        }
                    }
                }
            }
            .navigationTitle("Products")
            .task {
                await vm.loadProducts()
            }
        }
    }
}
