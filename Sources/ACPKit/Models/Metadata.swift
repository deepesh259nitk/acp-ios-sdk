//
//  Metadata.swift
//  ACPKit
//
//  Created by Deepesh Vasthimal on 24/05/2026.
//

public struct Metadata: Codable {

    public let model: String?

    public let toolUsed: String?

    public let latencyMs: Int?

    public init(
        model: String? = nil,
        toolUsed: String? = nil,
        latencyMs: Int? = nil
    ) {
        self.model = model
        self.toolUsed = toolUsed
        self.latencyMs = latencyMs
    }
}
