//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Edwin on 5/1/24.
//

import Foundation
import MapKit
import CoreLocation

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
        }
        func update(location: Location) {
            guard let selectedPlace else { return }

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
        }
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
    }
}