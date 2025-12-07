//
//  AgentManagerTests.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import XCTest
@testable import ACP_iOS_SDK // replace with your package module name

final class AgentManagerTests: XCTestCase {
    func testMockAgentReturnsResponse() async throws {
        let responses = [
            "shirts": AgentResponse(message: "Found shirts", suggestedProductIDs: ["p1","p2"]),
            "pants": AgentResponse(message: "Found pants", suggestedProductIDs: ["p3"])
        ]
        let mock = MockAgent(responses: responses)
        let manager = AgentManager(agent: mock)

        let resp = try await manager.ask("Show me shirts under £200")
        XCTAssertEqual(resp.message, "Found shirts")
        XCTAssertEqual(resp.suggestedProductIDs, ["p1","p2"])
    }
}
