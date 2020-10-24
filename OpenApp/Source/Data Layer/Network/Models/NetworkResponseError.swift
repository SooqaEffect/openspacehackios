//
//  Error.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import Foundation

enum NetworkResponseError: Error {
    case jsonParsingFailure
    case requestFail
    case invalidData
    case responseNotOK(statusCode: Int)
}
