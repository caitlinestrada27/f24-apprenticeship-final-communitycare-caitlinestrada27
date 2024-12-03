//
//  CareCenterLocation.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

// THIS FILE CONTAINS THE STRUCT FOR A SPECIFIC CARE CENTER LOCATION'S COORDINATES (LATITUDE AND LONGITUDE)

import Foundation

// Example JSON
// {
//     "latitude": 35.918177364674854,
//     "longitude": -79.0556610644248,
// }

struct CareCenterLocation: Codable {
    let latitude: Double
    let longitude: Double
}
