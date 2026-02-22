//
//  CartItemViewData.swift
//  ACPDemoApp
//
//  Created by Deepesh Vasthimal on 01/01/2026.
//

import Foundation

struct CartItemViewData: Identifiable {
    let id: String          // productID
    let name: String
    let price: Decimal
    let quantity: Int
}
