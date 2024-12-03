//
//  RequestLocationAccessView.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

// THIS FILE CONTAINS THE FIRST VIEW WHEN YOU OPEN THE APP
// COMMUNITY CARE WILL REQUEST YOUR LOCATION WITH A BUTTON AND POP UP TO ALLOW LOCATION

import SwiftUI

struct RequestLocationAccessView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Location Access")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("CommunityCare uses your current location to find health resources near you.")
                .multilineTextAlignment(.center)
                .foregroundColor(Color.secondary)
            
            Spacer()
            
            // TODO: Replace image later
            Image(systemName: "person.line.dotted.person.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(16)
            
            Spacer()
                
            Button {
                locationManager.requestLocationAccess()
                locationManager.startFetchingCurrentLocation()
            } label: {
                Spacer()
                Text("Allow \("CommunityCare") to use your location?")
                    .padding(16)
                    .font(.custom("SF Pro Text", size: 17))
                    .foregroundColor(Color.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .background(.blue, in: .rect(cornerRadius: 16))
                
            Spacer()
            }
    }
}


#Preview {
    RequestLocationAccessView(locationManager: LocationManager())
}
