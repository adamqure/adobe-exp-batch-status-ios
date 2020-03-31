//
//  SpecificBranchModelProtocol.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

protocol SpecificBranchModelProtocol {
    func retrieveBatchData(id: String)
    func beginPolling(id: String)
    func cancelPolling(id: String)
}
