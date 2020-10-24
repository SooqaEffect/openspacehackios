//
//  BaseURLRequest.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import Foundation

struct BaseURLRequest {
    var params: [String : Any]?
    var url: URL
    var httpMethod: HTTPMethod
    var rawRequest: URLRequest
    
    init(params: [String : Any]? = nil, url: URL, httpMethod: HTTPMethod, timeoutInterval: Int = 5, contentType: NetworkContentType) {
        self.params = params
        self.url = url
        self.httpMethod = httpMethod
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.timeoutInterval = TimeInterval(timeoutInterval)
        request.setValue(contentType.contentTypeHeader, forHTTPHeaderField: "Content-Type")
        self.rawRequest = request
    }
}
