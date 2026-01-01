//
//  File.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

import Foundation

public struct Product {
    public let id: String
    public let name: String
    public let price: Decimal
    public let description: String?
    public let currency: String?
}

extension Product {
    init(dto: ProductDTO) {
        self.init(
            id: dto.id,
            name: dto.title,
            price: dto.price,
            description: dto.description,
            currency: dto.currency
        )
    }
}
