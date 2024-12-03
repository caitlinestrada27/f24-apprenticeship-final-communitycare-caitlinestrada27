//
//  CareCentersService.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

// THIS FILE IS A STRUCT THAT CREATES THE fetchAllCareCenters() FUNCTION

import Foundation
import CoreLocation
import MapKit

struct CareCentersService {
    private let searchRadius: CLLocationDistance = 300
    
    // @property(nonatomic, copy, nullable) NSString *naturalLanguageQuery;
    
    func fetchCareCentersAsync(near location: CLLocation) async throws -> [CareCenter] {
        let categories = ["hospital", "clinic", "pharmacy", "urgent care", "medical center"]
        var allResults: [CareCenter] = []

        for category in categories {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = category
            searchRequest.region = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: searchRadius,
                longitudinalMeters: searchRadius
            )

            let search = MKLocalSearch(request: searchRequest)

            do {
                let response = try await search.start()
                let categoryResults = response.mapItems.compactMap { CareCenter.from($0) }
                allResults.append(contentsOf: categoryResults)
            } catch {
                print("Error searching for \(category): \(error.localizedDescription)")
            }
        }

        return allResults
    }
    
    func fetchCareCenters(
        near location: CLLocationCoordinate2D,
        completion: @escaping (([CareCenter], String?)) -> Void
    ) {
        let categories = ["hospital", "clinic", "pharmacy", "urgent care", "medical center"]
        let searchRadius: CLLocationDistance = 300
        var allResults: [CareCenter] = []
        var errors: [String] = []
        
        let searchGroup = DispatchGroup()
        
        for category in categories {
            searchGroup.enter()
            
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = category
            searchRequest.region = MKCoordinateRegion(
                center: location,
                latitudinalMeters: searchRadius,
                longitudinalMeters: searchRadius
            )
            
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                if let error = error {
                    errors.append("\(category) search failed: \(error.localizedDescription)")
                } else if let response = response {
                    let categoryResults = response.mapItems.compactMap { CareCenter.from($0) }
                    allResults.append(contentsOf: categoryResults)
                }
                searchGroup.leave()
            }
        }
    }
}
