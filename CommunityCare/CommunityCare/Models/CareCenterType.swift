//
//  CareCenterType.swift
//  CommunityCare
//
//  Created by Caitlin Estrada on 11/19/24.
//

// THIS FILE CONTAINS AN ENUM FOR EACH ROUTE TYPE (TBD)

// THE ENUMS CAN BE FORMATTED INTO RAWVALUES, SYSTEMIMAGENAMES, AND DISPLAY NAMES
// THESE DIFFERENT INFO FORMATS CAN BE CALLED UPON FOR DIFFERENT FUNCTIONS

import Foundation
import SwiftUICore

enum CareCenterType: String, Codable, CaseIterable {
    case hospital
    case clinic
    case pharmacy
    case urgent_care
    case other
    
    var rawValue: String {
        switch self {
        case .hospital: "hospital"
        case .clinic: "clinic"
        case .pharmacy: "pharmacy"
        case .urgent_care: "urgent care"
        case .other: "other"
        }
    }
    
    var displayName: String {
        switch self {
        case .hospital: return "Hospital"
        case .clinic: return "Clinic"
        case .pharmacy: return "Pharmacy"
        case .urgent_care: return "Urgent Care"
        case .other: return "Care Center"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .hospital: return "cross.case.fill"
        case .clinic: return "stethoscope"
        case .pharmacy: return "pills.fill"
        case .urgent_care: return "heart.fill"
        case .other: return "heart.square.fill"
        }
    }
    
    var typeColor: Color {
        switch self {
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
