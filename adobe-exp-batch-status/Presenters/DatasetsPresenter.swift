//
//  DatasetsPresenter.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

class DatasetsPresenter: DatasetsPresenterProtocol {

    var viewCallback: DatasetsViewControllerProtocol?
    var model: DatasetsModelProtocol?
    
    init(callback: DatasetsViewControllerProtocol) {
        self.viewCallback = callback
        self.model = DatasetsModel(callback: self)
    }
    
    func retrieveDatasets() {
        if (model == nil) {
            model = DatasetsModel(callback: self)
        }
        model?.retrieveDatasets()
    }
    
    func updateDatasets(datasets: [Dataset]) {
        viewCallback?.updateDatasets(datasets: datasets)
    }
}
