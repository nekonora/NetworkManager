//
//  NetworkService.swift
//  Clockifier
//
//  Created by Filippo Zaffoni on 04/01/22.
//  Copyright © 2022 Filippo Zaffoni. All rights reserved.
//

import Foundation

typealias NetworkParameters = [String: Any?]

enum NetworkMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
}

enum NetworkRequestEncoding {
    case json, url
}
