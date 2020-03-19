//
//  BatchError.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 3/19/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

struct BatchError: Codable {
    let errorCode: String
    let errorDescription: String
    
    enum CodingKeys: String, CodingKey {
        case errorCode = "code"
        case errorDescription = "description"
    }
}
