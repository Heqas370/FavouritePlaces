//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Adam Herman on 17/02/2026.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    
    let startPosistion = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 50, longitude: 20), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    )
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        
        MapReader{ map in
            Map(initialPosition: startPosistion){
                ForEach(viewModel.locations){ location in
                    
                    Annotation(location.name, coordinate: location.coordinate){
                            
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 40, height: 40)
                            .onLongPressGesture(minimumDuration: 0.1) {
                                viewModel.selectedLocation = location
                            }
                    }
                }
            }
                .mapStyle(.hybrid)
                .onTapGesture { position in
                    if let coordinate = map.convert(position, from: .local){
                        viewModel.addLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedLocation){ location in
                    PlaceEditView(location: location) {
                        viewModel.updateLocation(for: $0)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
