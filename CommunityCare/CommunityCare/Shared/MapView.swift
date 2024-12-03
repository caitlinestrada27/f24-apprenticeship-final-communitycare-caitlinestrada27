//
//  MapView.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

// THIS VIEW SHOWS THE MAP

import SwiftUI
import MapKit

struct MapView: View {
    let coordinates: CLLocationCoordinate2D
    
    @State private var region: MKCoordinateRegion
    
    init(coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        Map(coordinateRegion: Binding(
            get: { region },
            set: { newRegion in
                if newRegion.center.latitude != coordinates.latitude ||
                    newRegion.center.longitude != coordinates.longitude {
                    updateRegion(for: coordinates)
                } else {
                    region = newRegion
                }
            }
        ), annotationItems: [AnnotationItem(coordinate: coordinates)]) { item in
            MapAnnotation(coordinate: item.coordinate) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                    Text("Care Center")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
        }
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    private func updateRegion(for newCoordinates: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: newCoordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }
}

// Define an identifiable annotation item
struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
