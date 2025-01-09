//
//  PlaceAnnotationDataModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import Foundation
import MapKit

/* Code  to manage tourist place map pins */

struct PlaceAnnotationDataModel: Identifiable {

    // MARK:  list of attributes to map pins
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

