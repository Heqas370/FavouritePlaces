//
//  PlaceEditView.swift
//  FavouritePlaces
//
//  Created by Adam Herman on 17/02/2026.
//

import SwiftUI

struct PlaceEditView: View {
    
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    
    @State private var name: String
    @State private var description: String
    
    @State private var loadingState: LoadingState = .loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                }
                Section(header: Text("Description")) {
                    TextField("Description", text: $description)
                }
                Section(header: Text("Close Places")){
                    switch loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        List(pages, id: \.pageid) { page in
                            VStack(alignment: .leading){
                                Text(page.title).bold()
                                
                                Text(page.description).italic()
                            }
                        }
                    case .failed:
                        Text("Failed to load places")
                    }
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
            .task {
              await fetchData()
            }
        }
    }
    
    func fetchData() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
    
        
        guard let url = URL(string: urlString) else {
            print("Incorrect URL")
            return
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let items =  try JSONDecoder().decode(Result.self, from: data)
            
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        }
        catch{
            print("Error during fetching data: \(error.localizedDescription)")
            loadingState = .failed
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
