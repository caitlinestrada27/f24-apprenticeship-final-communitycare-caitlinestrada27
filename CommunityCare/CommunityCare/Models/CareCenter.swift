//
//  CareCenter.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

// THIS FILE CONTAINS THE STRUCT FOR CARE CENTER INCLUDING ALL OF ITS FIELDS AND VARIABLES
// FIELDS ARE ID, NAME, TYPE, AND CARE CENTERS
// VARIABLE IS COORDINATES (taken from CLLocationCoordinate2D Map)


import Foundation
import MapKit
import Contacts

struct CareCenter: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let type: CareCenterType
    let latitude: Double
    let longitude: Double
    
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func from(_ mapItem: MKMapItem) -> CareCenter? {
        guard let name = mapItem.name,
              let address = formatAddress(mapItem.placemark.postalAddress) else {
            return nil
        }
        
        return CareCenter(
            name: name,
            address: address,
            type: determineType(from: mapItem),
            latitude: mapItem.placemark.coordinate.latitude,
            longitude: mapItem.placemark.coordinate.longitude
        )
    }
    
    private static func formatAddress(_ postalAddress: CNPostalAddress?) -> String? {
        guard let address = postalAddress else { return nil }
        
        let formatter = CNPostalAddressFormatter()
        return formatter.string(from: address)
    }
    
    private static func determineType(from mapItem: MKMapItem) -> CareCenterType {
        if mapItem.pointOfInterestCategory == .hospital {
            return .hospital
        } else if mapItem.name?.lowercased().contains("clinic") ?? false {
            return .clinic
        } else if mapItem.name?.lowercased().contains("pharmacy") ?? false {
            return .pharmacy
        } else if mapItem.name?.lowercased().contains("urgent care") ?? false {
            return .urgent_care
        } else {
            return .other
        }
    }
}

extension CareCenter {
    static var hospitalExample: CareCenter {
        CareCenter(
            name: "UNC Hospital",
            address: "101 Manning Dr 101 Manning Dr Chapel Hill, NC 27514",
            type: .hospital,
            latitude: 35.9,
            longitude: -79.01
        )}
}
