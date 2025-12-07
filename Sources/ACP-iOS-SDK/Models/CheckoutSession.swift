//
//  CheckoutSession.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation

public struct CheckoutSession: Codable {
    public let id: String
    public let total: Decimal

    public init(id: String, total: Decimal) {
        self.id = id
        self.total = total
    }
}
