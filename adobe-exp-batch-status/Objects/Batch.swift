//
//  Batch.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 3/10/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

struct Batch: Codable {
    let id: String
    let lastUpdated: Int
    let status: String
    
    enum BatchStatus {
        case success
        case failure
        case processing
        case givenUp
    }
    
    static func stringToBatchStatus(statusString: String) -> BatchStatus {
        switch(statusString) {
            case "success":
                return .success
            case "failure", "failed":
                return .failure
            case "aborted", "abandoned", "inactive":
                return .givenUp
            default:
                return .processing
        }
    }
}
