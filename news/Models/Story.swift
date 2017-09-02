//
//  Story.swift
//  news
//
//  Created by Benjamin Fantini on 8/30/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import Alamofire
import Foundation
import RealmSwift
import SwiftyJSON

class Story: Object {

    // MARK: Properties
    dynamic var objectId: Int64 = 0
    dynamic var title: String?
    dynamic var author: String?
    dynamic var createdAt: Date?
    
    // MARK: Object overrides
    override static func primaryKey() -> String? {
        return "objectId"
    }
    
    // MARK: Creation
    static func create(with json: JSON) -> Story? {
        if let objectIdString = json["objectID"].string,
            let objectId = Int64(objectIdString) {
            
            let story = Story()
            story.objectId = objectId
            story.title = json["story_title"].string
            story.author = json["author"].string
            
            if let createdAtDouble = json["created_at_i"].double {
                story.createdAt = Date(timeIntervalSince1970: createdAtDouble)
            }

            return story
        } else {
            return nil
        }
    }

    static func createAndSave(withJsonArray jsonArray:[JSON]) {
        let realm = try! Realm()
        
        jsonArray.forEach { json in
            
            if let story = Story.create(with: json) {
                try! realm.write {
                    realm.add(story, update: true)
                }
            }
            
        }
    }
    
}

// MARK:- API
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
                // Create a json object with the result
                let json = JSON(value)
                
                // Create and save every object retrieved from the api
                if let hitsJson = json["hits"].array {
                    createAndSave(withJsonArray: hitsJson)
                    
                    // Callback with suceed value
                    completionHandler(true, nil)
                } else {
                    // TODO: BF: Add error handling
                }
                
            case .failure(let error):
                // Callback with failure value
                completionHandler(false, error)
            }
        }
    }
    
}
