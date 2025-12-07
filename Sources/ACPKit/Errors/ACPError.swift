//
//  ACPError.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//


public enum ACPError: Error {
    case networkError(message: String)
    case invalidResponse
    case checkoutNotAllowed(reason: String)
    case paymentFailed(reason: String)
    case unknown
}

