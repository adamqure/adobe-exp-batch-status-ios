//
//  DatasetsModel.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 2/25/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

class DatasetsModel: DatasetsModelProtocol {
    var presenterCallback: DatasetsPresenterProtocol?
    
    init(callback: DatasetsPresenterProtocol) {
        self.presenterCallback = callback
    }
    
    func retrieveDatasets() {
        //Retrieve Datasets
        let headers = ["Authorization": "Bearer " + auth.token,
                       "x-api-key": authInfo.apiKey,
        "x-gw-ims-org-id": authInfo.imsOrg]
        let baseURL = URL(string: "https://platform.adobe.io/data/foundation/catalog/dataSets")!
        let request = NSMutableURLRequest(url: baseURL,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    var datasets: [Dataset] = []
                    for (id, datasetDictionary) in dictionary {
                        let dictionary = datasetDictionary as! NSDictionary
                        let dataset = Dataset(name: dictionary.value(forKey: "name") as! String, id: id as! String, state: dictionary.value(forKey: "state") as! String)
                        datasets.append(dataset)
                    }
                    
                    self.presenterCallback?.updateDatasets(datasets: datasets)
                } catch {
                    
                }
            }
        })

        task.resume()
    }
}
