//
//  Story.swift
//  news
//
//  Created by Benjamin Fantini on 8/30/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

class Story {
    
}

// MARK: Api
extension Story {
    
    public static func getStories(completionHandler: @escaping (Bool, Error?) -> Void) {
        // Build the search by date url, using custom query param
        let url = ApiConfig.sharedInstance.buildUrl(relativePath: "search_by_date")
        let parameters = ["query": "ios"]
        let request = Alamofire.request(url,
                                        parameters: parameters)
        
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(true, nil)
                
            case .failure(let error):
                completionHandler(false, error)
            }
        }
    }
    
}
