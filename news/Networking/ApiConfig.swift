//
//  ApiConfig.swift
//  news
//
//  Created by Benjamin Fantini on 8/30/17.
//  Copyright © 2017 Benjamin Fantini. All rights reserved.
//

import Foundation


/**
 Class helper, works as a basic wrapper of setup func parameters
 */
private class SingletonSetup {
    var baseUrlString: String?
}

/**
 ApiConfig singleton class works for building further api url for requests
 */
public class ApiConfig: NSObject {

    static let sharedInstance = ApiConfig()
    private static let setup = SingletonSetup()

    private let baseUrl: URL

    /**
     Setup helper for shared instance, set this before calling the sharedIntance
     func

     - parameters:
     - baseUrl

     Example

     ApiConfig.setup(baseUrlString: "http://domain.com/api/v1/")
     */
    public class func setup(baseUrlString: String) {
        ApiConfig.setup.baseUrlString = baseUrlString
    }

    /**
     Private init, use <#sharedInstance#> instead
     */
    private override init() {
        if let baseUrlString = ApiConfig.setup.baseUrlString,
            let baseUrl = URL(string: baseUrlString) {
            self.baseUrl = baseUrl
        } else {
            fatalError("Error - call setup before accessing ApiConfig.sharedInstance")
        }
    }

    /**
     URL builder, pass a relative path as a parameter

     - parameters:
     - relativePath: The relative path that will be appended

     - returns: builded url

     Example

     ApiConfig.sharedInstance.buildUrl(relativePath: "events")
     */
    public func buildUrl(relativePath: String) -> URL {
        return self.baseUrl.appendingPathComponent(relativePath)
    }

}
