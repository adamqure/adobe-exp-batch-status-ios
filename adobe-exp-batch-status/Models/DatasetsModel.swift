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
    var datasets: [Dataset] = []
    var start = 0
    var limit = 20
    
    init(callback: DatasetsPresenterProtocol) {
        self.presenterCallback = callback
        datasets.removeAll()
        start = 0
    }
    
    func retrieveDatasets() {
        //Retrieve Datasets
        let headers = ["Authorization": "Bearer " + auth.token,
                       "x-api-key": authInfo.apiKey,
        "x-gw-ims-org-id": authInfo.imsOrg]
        var baseURL = URLComponents(string: "https://platform.adobe.io/data/foundation/catalog/dataSets")!
        
        baseURL.queryItems = [
            URLQueryItem(name: "orderBy", value: "desc:created"),
            URLQueryItem(name: "start", value: String(start)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        var request = URLRequest(url: baseURL.url!,
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    for (id, datasetDictionary) in dictionary {
                        let dictionary = datasetDictionary as! NSDictionary
                        let dataset = Dataset(name: dictionary.value(forKey: "name") as! String, id: id as! String, state: dictionary.value(forKey: "state") as! String)
                        self.datasets.append(dataset)
                    }
                    self.start += dictionary.count
                    
                    if (dictionary.count < self.limit) {
                        self.presenterCallback?.updateDatasets(datasets: self.datasets)
                    } else {
                        self.presenterCallback?.updateDatasets(datasets: self.datasets)
                        self.retrieveDatasets()
                    }
                    
                } catch {
                    
                }
            }
        })

        task.resume()
    }
}
