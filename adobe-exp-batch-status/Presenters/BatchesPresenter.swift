//
//  BatchesPresenter.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

class BatchesPresenter: BatchesPresenterProtocol {

    var viewCallback: BatchesViewControllerProtocol?
    var model: BatchesModelProtocol?

    init(callback: BatchesViewControllerProtocol) {
        self.viewCallback = callback
        self.model = BatchesModel(callback: self)
    }
    
    func retrieveBatches(dataset: String) {
        if (model == nil) {
            model = BatchesModel(callback: self)
        }
        model?.retrieveBatches(datasetId: dataset)
    }
    
    func updateBatches(batches: [Batch]) {
        self.viewCallback?.updateBatches(batches: batches)
    }
}
