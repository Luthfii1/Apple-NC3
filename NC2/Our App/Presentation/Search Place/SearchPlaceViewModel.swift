//
//  SearchPlaceViewModel.swift
//  NC2
//
//  Created by Luthfi Misbachul Munir on 12/07/24.
//
import Foundation
import MapKit
import Combine
import CoreLocation

class SearchPlaceViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var searchLocation: String = ""
    @Published var suggestedLocations: [MKMapItem] = []
    @Published var selectedLocation: MKMapItem? = nil
    @Published var isSheetPresented: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        $searchLocation
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.performSearch(for: query)
            }
            .store(in: &cancellables)
    }

    private func performSearch(for query: String) {
        guard let userLocation = locationManager.location else {
            print("User location not available.")
            return
        }
        
        guard !query.isEmpty else {
            self.suggestedLocations = []
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(String(describing: error))")
                self.suggestedLocations = []
                return
            }

            self.suggestedLocations = response.mapItems
        }
    }

    func selectLocation(_ location: MKMapItem) {
        selectedLocation = location
        searchLocation = location.name ?? "Unknown"
        isSheetPresented = false
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Handle authorization granted
            print("Location authorization granted.")
        case .denied, .restricted:
            // Handle authorization denied or restricted
            print("Location authorization denied or restricted.")
        case .notDetermined:
            // Handle authorization not determined
            print("Location authorization not determined.")
        default:
            break
        }
    }
}
