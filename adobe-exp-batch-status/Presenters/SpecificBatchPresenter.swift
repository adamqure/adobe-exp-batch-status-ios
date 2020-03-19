//
//  SpecificBatchPresenter.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

class SpecificBatchPresenter: SpecificBranchPresenterProtocol {
    
    var viewCallback: SpecificBranchViewControllerProtocol
    var model: SpecificBranchModelProtocol?
    
    init(callback: SpecificBranchViewControllerProtocol) {
        self.viewCallback = callback
        self.model = SpecificBatchModel(presenter: self)
    }
    
    func retrieveBatchData(id: String) {
        if (model == nil) {
            self.model = SpecificBatchModel(presenter: self)
        }
        model?.retrieveBatchData(id: id)
    }
    
    func updateBatchData(batch: BatchDetails?) {
        viewCallback.updateData(batch: batch)
    }
    
    
}
