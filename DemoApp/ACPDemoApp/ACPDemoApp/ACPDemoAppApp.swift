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
    var body: some Scene {
        WindowGroup {
            let mockMCP = MockMCPNetworkClient()
            let mockAgent = MockAgent(responses: [
                "shirt": AgentResponse(message: "Found shirts", suggestedProductIDs: ["p1"])
            ])
            let client = ACPClient(mcpClient: mockMCP, agent: mockAgent, pspAdapter: MockPSPAdapter())
            let cartVM = CartViewModel()
            ProductListView(vm: ProductViewModel(client: client, cartVM: cartVM))
        }
    }
}
