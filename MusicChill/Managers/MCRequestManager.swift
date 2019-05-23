//
//  MCRequestManager.swift
//  MusicChill
//
//  Created by Shaiful Islam Sujohn on 2/3/16.
//  Copyright © 2016 Hemal. All rights reserved.
//

import UIKit
import Alamofire

class MCRequestManager: Manager {
    
    var baseUrl = NSURL(string: AppConstants.Api.BaseUrl)
    
    static let manager: MCRequestManager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = MCRequestManager.defaultHTTPHeaders
        
        return MCRequestManager(configuration: configuration)
    }()
    
    override func request(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: ParameterEncoding = .URL,
        headers: [String: String]? = nil) -> Request {
            
            let fullUrl = NSURL(string: URLString.URLString, relativeToURL: baseUrl)
            
            return super.request(method, fullUrl!, parameters: parameters, encoding: encoding, headers: headers)
    }

}
