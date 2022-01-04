//
//  NetworkService.swift
//  Clockifier
//
//  Created by Filippo Zaffoni on 04/01/22.
//  Copyright © 2022 Filippo Zaffoni. All rights reserved.
//

import Foundation

public typealias NetworkParameters = [String: Any?]

public enum NetworkMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
}

public enum NetworkRequestEncoding {
    case json, url
}
