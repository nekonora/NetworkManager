//
//  NetworkError.swift
//  NetworkError
//
//  Created by Filippo Zaffoni on 01/09/21.
//  Copyright © 2021 Filippo Zaffoni. All rights reserved.
//

import Foundation

public enum NetworkError: LocalizedError {
    public enum NetworkingError {
        case invalidResponse
        case wrongStatusCode(statusCode: Int, message: String)
        case invalidJSONData(data: Data)
    }
    
    public enum AuthError {
        case tokenFetch
    }
    
    case networking(error: NetworkingError)
    case auth(error: AuthError)
    case encoding
    case generic(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .networking(let error):
            switch error {
            case .invalidResponse:
                return "Invalid response"
            case .wrongStatusCode(let statusCode, let message):
                return "Error - status code: \(statusCode), message:\n\(message)"
            case .invalidJSONData(let data):
                if let dataString = String(data: data, encoding: .utf8) {
                    return "Could not create JSON from data: \(dataString)"
                } else {
                    return "Could not create JSON from data"
                }
            }
        case .auth(let error):
            switch error {
            case .tokenFetch:
                return "Could not parse token"
            }
        case .encoding:
            return "Error encoding data"
        case .generic(let message):
            return message
        }
    }
}
