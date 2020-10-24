//
//  ContentType.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import Foundation

enum NetworkContentType {
    case formData(boundary: String)
    
    var contentTypeHeader: String {
        switch self {
        case .formData(let boundary): return "multipart/form-data; boundary=\(boundary)"
        }
    }
}
