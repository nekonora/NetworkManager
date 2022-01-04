//
//  NetworkHandler.swift
//  Clockifier
//
//  Created by Filippo Zaffoni on 04/01/22.
//  Copyright © 2022 Filippo Zaffoni. All rights reserved.
//

import Foundation

public protocol NetworkHandler: AnyObject {
    var manager: NetworkManager { get }
}

public extension NetworkHandler {
    var manager: NetworkManager { .shared }
}
