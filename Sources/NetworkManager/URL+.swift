//
//  URL+.swift
//  URL+
//
//  Created by Filippo Zaffoni on 01/09/21.
//  Copyright © 2021 Filippo Zaffoni. All rights reserved.
//

import Foundation

extension URL {
    
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else { preconditionFailure("Invalid static URL string: \(string)") }
        self = url
    }
    
    mutating func append(name: String, value: Any?) {
        guard let value = value, var urlComponents = URLComponents(string: absoluteString) else { return }
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: name, value: String(describing: value))
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        self = urlComponents.url!
    }
}
