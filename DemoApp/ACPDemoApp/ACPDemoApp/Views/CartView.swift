//
//  CartView.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 08/12/2025.
//

import SwiftUI
import ACPKit

struct CartView: View {

    @ObservedObject var cartVM: CartViewModel
    let products: [Product]

    var body: some View {
        List {
            ForEach(cartVM.viewData(products: products)) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text("x\(item.quantity)")
                }
            }
        }
        .navigationTitle("Cart")
    }
}
