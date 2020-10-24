//
//  URLManager.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import Foundation

final class URLManager: URLManagerBaseProtocol {
    private(set) var mainURL: String
    
    init(with mainURL: String) {
        self.mainURL = mainURL
    }
    
    func getMainAddress() -> String {
        return mainURL
    }
}

extension URLManager: WaterMetersURLManagerProtocol {
    func getUploadImageURL() -> URL {
        return URL(string:getMainAddress() + "uploadImage")!
    }
}
