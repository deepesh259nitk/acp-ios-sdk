//
//  ACPDemoAppApp.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import SwiftUI
import ACPKit

@main
struct ACPDemoAppApp: App {

    let client: ACPClient
    let cartVM: CartViewModel

    init() {
        let mockMCP = MockMCPNetworkClient()

        // 🔹 Register mock responses HERE
        try! mockMCP.registerGetResponse(
            "/acp/products",
            value: [
                ProductDTO(
                    id: "p1",
                    title: "Shirt",
                    description: "Blue cotton shirt",
                    price: Decimal(50),
                    currency: "GBP"
                ),
                ProductDTO(
                    id: "p2",
                    title: "Jeans",
                    description: "Slim fit jeans",
                    price: Decimal(80),
                    currency: "GBP"
                )
            ]
        )

        try! mockMCP.registerPostResponse(
            "/acp/checkout",
            value: CreateCheckoutResponse(
                checkoutID: "co_1",
                amount: Decimal(130),
                currency: "GBP"
            )
        )
        
        try! mockMCP.registerPostResponse(
            "/acp/checkout/co_1/complete",
            value: CompleteCheckoutResponse(status: "succeeded")
        )
        
        let mockAgent = MockAgent(responses: [
            "shirt": AgentResponse(
                message: "Found shirts",
                suggestedProductIDs: ["p1"]
            )
        ])

        let mockPSP = MockPSPAdapter()

        self.client = ACPClient(
            mcpClient: mockMCP,
            agent: mockAgent,
            pspAdapter: mockPSP
        )

        self.cartVM = CartViewModel()
    }

    var body: some Scene {
        WindowGroup {
            ProductListView(
                vm: ProductViewModel(
                    client: client,
                    cartVM: cartVM
                )
            )
        }
    }
}
