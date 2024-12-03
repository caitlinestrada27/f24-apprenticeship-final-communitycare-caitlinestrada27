//
//  CareCenterListViewModel.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

import SwiftUI
import CoreLocation
import MapKit
import Foundation

@MainActor
class CareCenterListViewModel: ObservableObject {
    @Published var careCenters: [CareCenter] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = CareCentersService()
    private let locationManager = LocationManager()

    init() {
        // Start fetching the user's location when the view model is initialized
        locationManager.requestLocationAccess()
    }

    func loadCareCenters(within radius: Double = 300) async {
        isLoading = true
        errorMessage = nil

        guard let userLocation = locationManager.userLocation else {
            errorMessage = "Unable to fetch user location."
            isLoading = false
            return
        }

        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        do {
            let centers = try await service.fetchCareCentersAsync(near: location)
            self.careCenters = centers.sorted { $0.name < $1.name }
        } catch {
            self.errorMessage = "Failed to fetch care centers: \(error.localizedDescription)"
            self.careCenters = []
        }
        
        isLoading = false
    }

    func refreshCareCenters(within radius: Double = 5000) async {
        await loadCareCenters(within: radius)
    }

    func filterCenters(by type: CareCenterType?) -> [CareCenter] {
        guard let type = type else { return careCenters }
        return careCenters.filter { $0.type == type }
    }
}
