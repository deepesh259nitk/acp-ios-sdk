//
//  CheckoutView.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 08/12/2025.
//

import SwiftUI
import ACPKit

struct CheckoutView: View {
    let items: [CartItem]
    
    @StateObject private var vm = CheckoutViewModel(
        client: ACPClient(pspAdapter: MockPSPAdapter()),
        psp: MockPSPAdapter()
    )

    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView("Processing...")
            }

            if let success = vm.successMessage {
                Text(success)
                    .foregroundColor(.green)
            }

            if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Pay Now") {
                Task {
                    await vm.checkout(items: items)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Checkout")
    }
}

