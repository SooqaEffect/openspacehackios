//
//  NetworkResponse.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import Foundation

enum NetworkResult<T, U> where U: Error {
    case success(T)
    case fail(U)
}
