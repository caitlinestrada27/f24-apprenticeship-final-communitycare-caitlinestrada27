//
//  CareCenterDetailsView.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

import SwiftUI

struct CareCenterDetailsView: View {
    @StateObject var vm: CareCenterDetailsViewModel
    
    init(careCenter: CareCenter) {
        // This is the syntax needed to initialize a StateObject with parameters
        self._vm = StateObject(wrappedValue: CareCenterDetailsViewModel(careCenter: careCenter))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    ZStack {
                        Image(systemName: vm.careCenter.type.systemImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
                            .padding(16)
                            .foregroundStyle(vm.careCenter.type.typeColor)
                            .background(Color.secondary.opacity(0.2), in: Circle())
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(vm.careCenter.type.displayName)
                            .font(Font.custom("SF Pro", size: 17)
                                .weight(.semibold))
                        Text(vm.careCenter.name)
                            .font(Font.custom("SF Pro", size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                MapView(coordinates: vm.careCenter.coordinates)
                    .frame(height: 200)
                    .cornerRadius(20)
                
                /* Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                    GridRow {
                        MetricView(title: "Latitude", value: "\(vm.careCenter.latitude)")
                        MetricView(title: "Longitude", value: "\(vm.careCenter.longitude)")
                    }
                } */
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Address")
                        .font(Font.custom("SF Pro", size: 13))
                        .foregroundColor(.secondary)
                    HStack {
                        // navigate to Apple Maps
                        Button {
                            let mapURL = URL(string: "maps:?daddr=\(vm.careCenter.coordinates)")!
                            
                            UIApplication.shared.open(mapURL, options: [:], completionHandler: nil)
                        } label: {
                            Text(vm.careCenter.address)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    Divider()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Insurance Providers Accepted")
                        .font(Font.custom("SF Pro", size: 18))
                    // setting to default values becuase APIs are not free :(
                    Text("Private: ")
                        .font(Font.custom("SF Pro", size: 15))
                    Text("Blue Cross Blue Shield, UnitedHealthcare, Aetna, Cigna, Humana")
                        .font(Font.custom("SF Pro", size: 13))
                    Text("Government-Provided:")
                        .font(Font.custom("SF Pro", size: 15))
                    Text("Medicare, Medicaid, TRICARE, Veterans Affairs (VA) Benefits")
                        .font(Font.custom("SF Pro", size: 13))
                }
                Spacer()
                Text("Please contact your provider for more information")
                    .italic()
            }
            .navigationTitle(vm.careCenter.name)
            .onAppear {
                vm.fetchDetails()
            }
            .padding(8)
        }
    }
}

struct MetricView: View {
    var title: String
    var value: String

    var body: some View {
        VStack {
            Text(title)
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.bottom, 1)
            Text(value)
                .font(.title3)
                .bold()

        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
    }
}


#Preview {
    NavigationStack {
        CareCenterListView()
        /* Text("yo")
            .navigationDestination(isPresented: .constant(true)) {
                CareCenterDetailsView(careCenter: .hospitalExample)
            }
         */
    }
}
