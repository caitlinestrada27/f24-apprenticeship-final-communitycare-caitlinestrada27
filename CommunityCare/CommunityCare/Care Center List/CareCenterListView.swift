//
//  CareCenterListView.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

import SwiftUI
import CoreLocation
import MapKit

// MARK: - Main View
struct CareCenterListView: View {
    @StateObject private var viewModel = CareCenterListViewModel()
    @State private var selectedType: CareCenterType?
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    loadingView
                } else {
                    mainListView
                }
            }
            .navigationTitle(dynamicTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterButton
                }
            }
        }
        .task {
            await viewModel.loadCareCenters()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    // MARK: - Subviews
    private var loadingView: some View {
        VStack {
            ProgressView()
            Text("Finding care centers...")
                .foregroundColor(.secondary)
        }
    }
    
    private var mainListView: some View {
        List(filteredCareCenters) { center in
            NavigationLink {
                CareCenterDetailsView(careCenter: center)
            } label: {
                CareCenterRow(center: center)
            }
        }
        // search bar
        .searchable(text: $searchText, prompt: searchPrompt)
        .refreshable {
            await viewModel.refreshCareCenters()
        }
        .overlay {
            if filteredCareCenters.isEmpty && !viewModel.isLoading {
                ContentUnavailableView(
                    "No \(dynamicTitle) Found",
                    systemImage: "cross.case",
                    description: Text("Try changing your search criteria or location")
                )
            }
        }
    }
    
    private var filterButton: some View {
        Menu {
            Button("All", role: .none) {
                selectedType = nil
            }
            
            Button("Hospitals", role: .none) {
                selectedType = .hospital
            }
            
            Button("Clinics", role: .none) {
                selectedType = .clinic
            }
            
            Button("Pharmacies", role: .none) {
                selectedType = .pharmacy
            }
            
            Button("Urgent Care", role: .none) {
                selectedType = .urgent_care
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
        }
    }
    
    // MARK: - Filtered Data
    private var filteredCareCenters: [CareCenter] {
        viewModel.careCenters.filter { center in
            (selectedType == nil || center.type == selectedType) &&
            (searchText.isEmpty || center.name.localizedCaseInsensitiveContains(searchText) || center.address.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    // MARK: - Dynamic Text
    private var dynamicTitle: String {
        switch selectedType {
        case .hospital:
            return "Hospitals"
        case .clinic:
            return "Clinics"
        case .pharmacy:
            return "Pharmacies"
        case .urgent_care:
            return "Urgent Cares"
        default:
            return "Care Centers"
        }
    }
    
    private var searchPrompt: String {
        switch selectedType {
        case .hospital:
            return "Search Hospitals"
        case .clinic:
            return "Search Clinics"
        case .pharmacy:
            return "Search Pharmacies"
        case .urgent_care:
            return "Search Urgent Cares"
        default:
            return "Search Care Centers"
        }
    }
}

// MARK: - Row View
struct CareCenterRow: View {
    let center: CareCenter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(center.name)
                .font(.headline)
            
            Text(center.address)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: typeIcon)
                    .foregroundColor(typeColor)
                Text(typeText)
                    .font(.caption)
                    .foregroundColor(typeColor)
            }
        }
        .padding(.vertical, 4)
    }
    
    // SUPER INEFFCIENT -- NEED TO USE CareCenterType
    private var typeIcon: String {
        switch center.type {
        case .hospital:
            return "cross.case.fill"
        case .clinic:
            return "stethoscope"
        case .pharmacy:
            return "pills.fill"
        case .urgent_care:
            return "heart.fill"
        case .other:
            return "heart.square.fill"
        }
    }
    
    private var typeText: String {
        switch center.type {
        case .hospital:
            return "Hospital"
        case .clinic:
            return "Clinic"
        case .pharmacy:
            return "Pharmacy"
        case .urgent_care:
            return "Urgent Care"
        case .other:
            return "Care Center"
        }
    }
    
    private var typeColor: Color {
        switch center.type {
        case .hospital:
            return .red
        case .clinic:
            return .blue
        case .pharmacy:
            return .green
        case .urgent_care:
            return .orange
        case .other:
            return .gray
        }
    }
}

#Preview {
    CareCenterListView()
}
