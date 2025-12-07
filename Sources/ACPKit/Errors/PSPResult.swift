//
//  PSPResult.swift
//  ACP-iOS-SDK
//
//  Created by Deepesh Vasthimal on 07/12/2025.
//

public enum PSPResult {
    case success(token: String)
    case failure(error: ACPError)
    case cancelled
}
