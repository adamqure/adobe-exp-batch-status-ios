//
//  BatchDetails.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 3/10/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

struct BatchDetails: Codable {
    let startedTime: Int?
    let endedTime: Int?
    let status: String
    let successfulCount: Int?
    let failedCount: Int?
    let errors: [BatchError]
    
    enum CodingKeys: String, CodingKey {
        case startedTime = "started"
        case endedTime = "completed"
        case status = "status"
        case successfulCount = "recordCount"
        case failedCount = "failedRecordCount"
        case errors = "errors"
    }
}
