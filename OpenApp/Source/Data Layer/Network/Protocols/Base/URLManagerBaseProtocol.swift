//
//  URLManagerBaseProtocol.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import Foundation

protocol URLManagerBaseProtocol {
    var mainURL: String { get }
    init(with mainURL: String)
    func getMainAddress() -> String
}
