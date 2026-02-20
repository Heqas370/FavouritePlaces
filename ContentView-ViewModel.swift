//
//  ContentView-ViewModel.swift
//  FavouritePlaces
//
//  Created by Adam Herman on 20/02/2026.
//

import Foundation
import MapKit
import Observation

extension ContentView {
    @Observable
    class ViewModel {
        
        let savePath = URL.documentsDirectory.appending(path: "SavedLocations")
        
        private(set) var locations: [Location]
        var selectedLocation: Location?
        
        init(){
            do{
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            }
            catch {
                locations = []
            }
        }
        
        func addLocation(at coordinate: CLLocationCoordinate2D){
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
            locations.append(newLocation)
        }
        
        func updateLocation(for location: Location){
            guard let selectedLocation else { return }
            
            if let index = locations.firstIndex(of: selectedLocation) {
                locations[index] = location
                saveLocation()
            }
        }
        
        func saveLocation() {
            do{
                let encodedData = try JSONEncoder().encode(locations)
                try encodedData.write(to: savePath, options: [.atomic, .completeFileProtection])
            }
            catch{
                print("Unable to save location: \(error.localizedDescription)")
                return
            }
        }
        
    }
}
