//
//  StructuredIntent.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 22/02/2026.
//

import Foundation

struct StructuredIntent: Codable {
    let action: String
    let product: String
    let maxPriceCents: Int
}
