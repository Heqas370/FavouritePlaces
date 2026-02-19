//
//  Location.swift
//  FavouritePlaces
//
//  Created by Adam Herman on 17/02/2026.
//

import MapKit
import Foundation

struct Location: Identifiable, Codable, Equatable {
    
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func ==(lhs: Location, rhs: Location) -> Bool{
        return lhs.id == rhs.id
    }
    
    #if DEBUG
    static let example = Location(id: UUID(), name: "Camp Nou", description: "FC Barcelona Stadium", latitude: 41.2251, longitude: 2.0722)
    #endif
}
