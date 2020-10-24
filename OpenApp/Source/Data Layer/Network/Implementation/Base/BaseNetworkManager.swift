//
//  BaseURLManager.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import Foundation

final class BaseNetworkManager: NetworkManager {
    var session: URLSession
    
    init(with timeoutRequest: Int, timeoutResoucre: Int) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(timeoutRequest)
        config.timeoutIntervalForResource = TimeInterval(timeoutResoucre)
        self.session = URLSession(configuration: config)
    }
}
