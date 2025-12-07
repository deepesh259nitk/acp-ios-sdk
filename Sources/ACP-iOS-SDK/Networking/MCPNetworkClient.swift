//
//  File.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation

/// Errors thrown by the MCP network client
public enum MCPNetworkError: Error {
    case invalidURL(String)
    case network(error: Error)
    case decodingFailed
    case httpError(statusCode: Int, data: Data?)
    case unknown
}

extension MCPNetworkError: Equatable {
    public static func == (lhs: MCPNetworkError, rhs: MCPNetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL(let l), .invalidURL(let r)):
            return l == r
        case (.network, .network):
            return true // cannot compare underlying Error
        case (.decodingFailed, .decodingFailed):
            return true
        case (.httpError(let l1, _), .httpError(let r1, _)):
            return l1 == r1 // ignoring data for testability
        case (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
/// Minimal generic network client protocol for MCP (merchant) interactions.
/// Implementations:
///  - `URLSessionMCPNetworkClient` for real network calls
///  - `MockMCPNetworkClient` for tests/local demo
public protocol MCPNetworkClient {
    /// Perform a GET request and decode JSON into the requested Decodable type
    func get<T: Decodable>(_ path: String, as type: T.Type) async throws -> T

    /// Perform a POST request with an Encodable body and decode JSON into the requested Decodable type
    func post<Body: Encodable, Response: Decodable>(_ path: String, body: Body, as type: Response.Type) async throws -> Response
}

public struct MCPConfig {
    public let baseURL: URL
    public let defaultTimeout: TimeInterval

    public init(baseURL: URL, defaultTimeout: TimeInterval = 15.0) {
        self.baseURL = baseURL
        self.defaultTimeout = defaultTimeout
    }
}

/// Real URLSession-backed MCP network client
public final class URLSessionMCPNetworkClient: MCPNetworkClient {
    private let config: MCPConfig
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    public init(config: MCPConfig, session: URLSession = .shared) {
        self.config = config
        self.session = session
        self.jsonDecoder = JSONDecoder()
        self.jsonEncoder = JSONEncoder()
    }

    public func get<T>(_ path: String, as type: T.Type) async throws -> T where T : Decodable {
        guard let url = URL(string: path, relativeTo: config.baseURL) else {
            throw MCPNetworkError.invalidURL(path)
        }
        var req = URLRequest(url: url, timeoutInterval: config.defaultTimeout)
        req.httpMethod = "GET"
        req.addValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await session.data(for: req)
            try validate(response: response, data: data)
            return try jsonDecoder.decode(T.self, from: data)
        } catch let err as MCPNetworkError {
            throw err
        } catch {
            throw MCPNetworkError.network(error: error)
        }
    }

    public func post<Body, Response>(_ path: String, body: Body, as type: Response.Type) async throws -> Response where Body : Encodable, Response : Decodable {
        guard let url = URL(string: path, relativeTo: config.baseURL) else {
            throw MCPNetworkError.invalidURL(path)
        }
        var req = URLRequest(url: url, timeoutInterval: config.defaultTimeout)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.httpBody = try jsonEncoder.encode(body)

        do {
            let (data, response) = try await session.data(for: req)
            try validate(response: response, data: data)
            return try jsonDecoder.decode(Response.self, from: data)
        } catch let err as MCPNetworkError {
            throw err
        } catch {
            throw MCPNetworkError.network(error: error)
        }
    }

    private func validate(response: URLResponse, data: Data?) throws {
        guard let http = response as? HTTPURLResponse else {
            throw MCPNetworkError.unknown
        }
        switch http.statusCode {
        case 200..<300:
            return
        default:
            throw MCPNetworkError.httpError(statusCode: http.statusCode, data: data)
        }
    }
}

/// Simple in-memory mock MCP client used for unit tests and local dev.
/// You can initialize it with precomputed responses for endpoints.
public final class MockMCPNetworkClient: MCPNetworkClient {
    private var getResponses: [String: Data] = [:]
    private var postResponses: [String: Data] = [:]

    public init() {}

    /// Register a mock response (encoded JSON) for a GET path
    public func registerGetResponse<T: Encodable>(_ path: String, value: T) throws {
        let data = try JSONEncoder().encode(value)
        getResponses[path] = data
    }

    /// Register a mock response for a POST path
    public func registerPostResponse<T: Encodable>(_ path: String, value: T) throws {
        let data = try JSONEncoder().encode(value)
        postResponses[path] = data
    }

    public func get<T>(_ path: String, as type: T.Type) async throws -> T where T : Decodable {
        guard let data = getResponses[path] else {
            throw MCPNetworkError.invalidURL("No mock GET response for path: \(path)")
        }
        let obj = try JSONDecoder().decode(T.self, from: data)
        return obj
    }

    public func post<Body, Response>(_ path: String, body: Body, as type: Response.Type) async throws -> Response where Body : Encodable, Response : Decodable {
        guard let data = postResponses[path] else {
            throw MCPNetworkError.invalidURL("No mock POST response for path: \(path)")
        }
        let obj = try JSONDecoder().decode(Response.self, from: data)
        return obj
    }
}
