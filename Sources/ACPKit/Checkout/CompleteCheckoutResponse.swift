//
//  File.swift
//  ACPKit
//
//  Created by Deepesh Vasthimal on 20/01/2026.
//
public struct CompleteCheckoutResponse: Codable {
    public let status: String

    public init(status: String) {
        self.status = status
    }
}
