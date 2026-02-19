//
//  PlaceEditView.swift
//  FavouritePlaces
//
//  Created by Adam Herman on 17/02/2026.
//

import SwiftUI

struct PlaceEditView: View {
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    
    @State private var name: String
    @State private var description: String
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                }
                Section(header: Text("Description")) {
                    TextField("Description", text: $description)
                }
            }
            .navigationBarTitle("Edit Place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("Save"){
                    
                    var newLocation = location
                    newLocation.id = UUID() 
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void ){
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}


#Preview {
    PlaceEditView(location: .example) { _ in }
}
