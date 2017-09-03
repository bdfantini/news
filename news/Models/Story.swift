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
    
    fileprivate enum JsonKey: String {
        case hits = "hits"
        case storyId = "story_id"
        case storyTitle = "story_title"
        case author = "author"
        case storyUrl = "story_url"
        case createdAtI = "created_at_i"
    }

    // MARK: Properties
    dynamic var objectId: Int64 = 0
    dynamic var title: String = ""
    dynamic var author: String = ""
    dynamic var urlString: String = ""
    dynamic var createdAt: Date = Date()
    dynamic var isDeleted: Bool = false
    
    // MARK: Object overrides
    override static func primaryKey() -> String? {
        return "objectId"
    }
    
    // MARK: Creation
    static func create(with json: JSON) -> Story? {
        
        if let objectId = json[JsonKey.storyId.rawValue].int64,
            let title = json[JsonKey.storyTitle.rawValue].string,
            let author = json[JsonKey.author.rawValue].string,
            let urlString = json[JsonKey.storyUrl.rawValue].string,
            let createdAtDouble = json[JsonKey.createdAtI.rawValue].double {
            
            let story = Story()
            story.objectId = objectId
            story.title = title
            story.author = author
            story.urlString = urlString
            story.createdAt = Date(timeIntervalSince1970: createdAtDouble)

            return story
        } else {
            return nil
        }
    }

    static func createAndSave(withJsonArray jsonArray:[JSON]) {
        do {
            let realm = try Realm()
            
            try jsonArray.forEach { json in
                
                if let objectId = json[JsonKey.storyId.rawValue].int64,
                    realm.object(ofType: Story.self, forPrimaryKey: objectId) == nil,
                    let story = Story.create(with: json) {
                    
                    try realm.write {
                        realm.add(story)
                    }
                }
            }
        } catch let error as NSError {
            // TODO: BF: Do something
            print(error)
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
                if let hitsJson = json[JsonKey.hits.rawValue].array {
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
