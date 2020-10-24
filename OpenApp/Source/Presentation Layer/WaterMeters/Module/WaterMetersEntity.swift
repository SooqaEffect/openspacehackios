//
//  WaterMetersEntity.swift
//  OpenApp
//
//  Created by Вячеслав Яшунин on 23.10.2020.
//

import Foundation

struct WaterMetersResponse: Decodable {
    var serialNumber: String?
    var value: String?
}
