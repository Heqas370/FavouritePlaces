//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Adam Herman on 17/02/2026.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    @State private var locations = [Location]()
    @State private var selectedLocation: Location?
    
    let startPosistion = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 10, longitude: 20), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    )
    
    var body: some View {
        
        MapReader{ map in
            Map(initialPosition: startPosistion){
                ForEach(locations){ location in
                    
                    Annotation(location.name, coordinate: location.coordinate){
                            
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 40, height: 40)
                            .padding(30)
                            .onLongPressGesture(minimumDuration: 0.1) {
                                selectedLocation = location
                            }
                    }
                }
            }
                .mapStyle(.hybrid)
                .onTapGesture { position in
                    if let coordinate = map.convert(position, from: .local){
                        let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                        locations.append(newLocation)
                    }
                }
                .sheet(item: $selectedLocation){ location in
                    Text(location.name)
                }
        }
    }
}

#Preview {
    ContentView()
}
