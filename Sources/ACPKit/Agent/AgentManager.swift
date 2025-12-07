//
//  File.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation

/// Response types the Agent can return.
/// This is intentionally simple; expand as you need (intent, actions, messages).
public struct AgentResponse: Codable {
    public let message: String
    public let suggestedProductIDs: [String]?

    public init(message: String, suggestedProductIDs: [String]? = nil) {
        self.message = message
        self.suggestedProductIDs = suggestedProductIDs
    }
}

/// Agent error cases
public enum AgentError: Error, Equatable {
    case networkError(String)
    case invalidResponse
    case unknown
}

/// Agent protocol — implement a real LLM backed agent or a mock/local agent
public protocol Agent {
    /// Send a natural language query to the agent and receive a structured response.
    func ask(_ query: String) async throws -> AgentResponse
}

/// AgentManager - coordinates agent usage inside the SDK.
/// It accepts an `Agent` implementation (mock or real) to keep code testable.
public final class AgentManager {
    private let agent: Agent

    /// Initialize with any Agent implementation
    public init(agent: Agent) {
        self.agent = agent
    }

    /// Ask the agent a question (e.g. "Show me shirts under £200")
    /// - Parameter query: Natural language query
    /// - Returns: AgentResponse with text and optional product IDs
    /// - Throws: AgentError on failure
    public func ask(_ query: String) async throws -> AgentResponse {
        do {
            return try await agent.ask(query)
        } catch let err as AgentError {
            throw err
        } catch {
            throw AgentError.unknown
        }
    }
}

/// Simple mock agent that returns deterministic responses (good for local dev)
public final class MockAgent: Agent {
    private let responses: [String: AgentResponse]

    /// Initialize with a mapping from query -> response
    /// Queries are matched case-insensitively by contains.
    public init(responses: [String: AgentResponse] = [:]) {
        self.responses = responses
    }

    public func ask(_ query: String) async throws -> AgentResponse {
        // very basic matching: find first key where query contains key
        let lower = query.lowercased()
        for (k, v) in responses {
            if lower.contains(k.lowercased()) { return v }
        }
        // default fallback
        return AgentResponse(message: "I found these products for you", suggestedProductIDs: nil)
    }
}

