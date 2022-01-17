//
//  NetworkManager.swift
//  Clockifier
//
//  Created by Filippo Zaffoni on 21/03/2020.
//  Copyright © 2020 Filippo Zaffoni. All rights reserved.
//

import Foundation
import LogManager

public final class NetworkManager {
    
    // MARK: - Properties
    private let decoder: JSONDecoder
    private let logger: LogManager
    
    // MARK: - Instance
    public static let shared = NetworkManager()
    
    private init() {
        self.decoder = JSONDecoder()
        self.logger = LogManager.shared
    }
    
    // MARK: - Methods
    @available(macOS 12.0, *)
    @available(macCatalyst 15.0, *)
    @available(iOS 15.0, *)
    public func request(baseURL: URL,
                 endpoint: String,
                 method: NetworkMethod,
                 parameters: NetworkParameters? = nil,
                 encoding: NetworkRequestEncoding = .url,
                 additionalHeaders: [String: String?]? = nil) async throws {
        let request = try buildRequest(
            baseURL: baseURL,
            endpoint: endpoint,
            method: method,
            parameters: parameters,
            encoding: encoding,
            additionalHeaders: additionalHeaders
        )
        
        logger.logMessage(source: .services, message: "new request @ \(endpoint)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.networking(error: .invalidResponse)
            }
            guard httpResponse.statusCode == 200 else {
                let message = String(decoding: data, as: UTF8.self)
                throw NetworkError.networking(error: .wrongStatusCode(statusCode: httpResponse.statusCode,
                                                                  message: message))
            }
        } catch {
            throw NetworkError.generic(message: error.localizedDescription)
        }
    }
    
    @available(macOS 12.0, *)
    @available(macCatalyst 15.0, *)
    @available(iOS 15.0, *)
    public func request<T: Codable>(baseURL: URL,
                             endpoint: String,
                             method: NetworkMethod,
                             parameters: NetworkParameters? = nil,
                             encoding: NetworkRequestEncoding = .url,
                             additionalHeaders: [String: String?]? = nil) async throws -> T {
        let request = try buildRequest(
            baseURL: baseURL,
            endpoint: endpoint,
            method: method,
            parameters: parameters,
            encoding: encoding,
            additionalHeaders: additionalHeaders
        )
        
        logger.logMessage(source: .services, message: "new request @ \(endpoint)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.networking(error: .invalidResponse)
            }
            guard httpResponse.statusCode == 200 else {
                let message = String(decoding: data, as: UTF8.self)
                throw NetworkError.networking(error: .wrongStatusCode(statusCode: httpResponse.statusCode,
                                                                  message: message))
            }
            
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.generic(message: error.localizedDescription)
        }
    }
}

// MARK: - Internals
private extension NetworkManager {
    
    func buildRequest(baseURL: URL,
                      endpoint: String,
                      method: NetworkMethod,
                      parameters: NetworkParameters?,
                      encoding: NetworkRequestEncoding,
                      additionalHeaders: [String: String?]?) throws -> URLRequest {
        var endpointPath = baseURL.appendingPathComponent(endpoint)
        var body: String?
        
        if let parameters = parameters {
            switch encoding {
            case .json:
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    body = String(data: jsonData, encoding: String.Encoding.ascii)
                } catch {
                    logger.logMessage(source: .services,
                                      message: "Error while encoding parameters for call to: \(endpoint)",
                                      type: .error)
                    throw NetworkError.encoding
                }
            case .url:
                parameters.forEach { key, value in
                    endpointPath.append(name: key, value: value)
                }
            }
        }
        
        var _request = URLRequest(url: endpointPath)
        if let body = body {
            _request.httpBody = body.data(using: .utf8, allowLossyConversion: false)
        }
        
        if let additionalHeaders = additionalHeaders {
            for header in additionalHeaders {
                _request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }

        _request.setValue("application/json", forHTTPHeaderField: "Accept")
        _request.httpMethod = method.rawValue
        return _request
    }
}
