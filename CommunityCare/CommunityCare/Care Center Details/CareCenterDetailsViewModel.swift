//
//  CareCenterDetailViewModel.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

import Foundation
import MapKit
import Contacts

class CareCenterDetailsViewModel: ObservableObject {
    @Published var careCenter: CareCenter
    @Published var start: CNPostalAddress?
    @Published var end: CNPostalAddress?

    init(careCenter: CareCenter) {
        self.careCenter = careCenter
    }

    // Fetch additional details for the CareCenter
    func fetchDetails() {
        // Simulate fetching additional data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Generate start and end addresses
            self.start = self.generatePostalAddress(for: self.careCenter)
            self.end = self.generatePostalAddress(for: self.careCenter)
        }
    }

    // Helper to create a postal address from CareCenter
    private func generatePostalAddress(for careCenter: CareCenter) -> CNPostalAddress {
        let mutableAddress = CNMutablePostalAddress()
        mutableAddress.street = careCenter.address
        return mutableAddress as CNPostalAddress
    }
}
