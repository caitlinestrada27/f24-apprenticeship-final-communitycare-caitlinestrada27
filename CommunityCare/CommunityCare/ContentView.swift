//
//  ContentView.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        // only show MapView when location access has been approved by user
        if locationManager.hasLocationAccess {
            // MapView(coordinates: CLLocationCoordinate2D(latitude: (locationManager.userLocation?.coordinate.latitude)!, longitude: (locationManager.userLocation?.coordinate.longitude)!))
            CareCenterListView()
                .environmentObject(locationManager)
        } else {
            RequestLocationAccessView(locationManager: locationManager)
        }
    }
}

#Preview {
    ContentView()
}
