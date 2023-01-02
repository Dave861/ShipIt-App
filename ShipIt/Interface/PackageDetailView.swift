//
//  PackageDetailView.swift
//  ShipIt
//
//  Created by Mihnea on 12/27/22.
//

import SwiftUI
import MapKit

struct PackageDetailView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var package : Package
    @State var accentColor : Color
    
    @State private var markerLocations = [Marker]()
    
    @State private var minLong = 1000.0
    @State private var maxLong = 0.0
    @State private var minLat = 1000.0
    @State private var maxLat = 0.0
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Where is My Package?")
                        .font(.title3)
                        .bold()
                        .padding([.top, .leading, .trailing])
                    Spacer()
                }
                
                Map(coordinateRegion: $region, showsUserLocation: false, annotationItems: markerLocations) { item in
                    MapMarker(coordinate: .init(latitude: item.latitude, longitude: item.longitude), tint: item.address == package.eventsArray.first?.address ? accentColor : Color.gray)
                    
                }
                .frame(height: UIScreen.main.bounds.height/4)
                .navigationTitle(package.name!)
                .cornerRadius(20)
                .padding([.trailing, .leading])
                
                HStack {
                    Text("Delivery Status")
                        .font(.title3)
                        .bold()
                        .padding([.top, .leading, .trailing])
                    Spacer()
                }
                List(package.eventsArray.indexed(), id: \.1.self) { index, event in
                    HStack {
                        Image(systemName: event.systemImage!)
                            .font(.system(size: 25))
                            .frame(width: 40)
                            .foregroundColor((accentColor))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(event.text!)
                            Text("\(event.timestamp!) - \(event.address!.replacingOccurrences(of: " - ", with: ", "))")
                                .foregroundColor((accentColor))
                                .font(.system(size: 17))
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(RoundedRectangle(cornerRadius: 16)
                        .padding([.leading, .trailing])
                        .foregroundColor(index%2 == 0 ? Color.gray.opacity(0.2) : Color.clear))
                    
                }
                
            }
        }
        .listStyle(.plain)
        Button {} label: {
            HStack {
                Spacer()
                Label("Open on Website", systemImage: "link")
                    .foregroundColor(accentColor)
                    .font(.system(size: 18, weight: .medium))
                    .padding([.bottom, .top], 12)
                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 12)
                .foregroundColor(accentColor.opacity(0.45)))
            .padding([.top, .leading, .trailing])
        }
        Text("Tracking Number 4385722438")
            .font(.system(size: 16))
            .foregroundColor(.gray)
        Spacer()
            .onAppear() {
                let geoCoder = CLGeocoder()
                var lastLocation: CLLocation!
                Task {
                    do {
                        let placemarks = try await geoCoder.geocodeAddressString(package.address ?? "")
                        lastLocation = placemarks.first?.location
                        DispatchQueue.main.async {
                            self.region.center.longitude = lastLocation.coordinate.longitude
                            self.region.center.latitude = lastLocation.coordinate.latitude
                        }
                    } catch let err {
                        print(err)
                    }
                    
                    var events = package.eventsArray
                    if package.eventsArray.count > 5 {
                        events = Array(package.eventsArray[..<5])
                    }
                    
                    for event in events {
                        let address = event.address?.replacingOccurrences(of: "-", with: "")
                        let geoCoder = CLGeocoder()
                        var markerLocation: CLLocation!
                        
                        do {
                            let placemarks = try await geoCoder.geocodeAddressString(address ?? "")
                            markerLocation = placemarks.first?.location
                            let marker = Marker(latitude: markerLocation.coordinate.latitude, longitude: markerLocation.coordinate.longitude, systemImage: event.systemImage!, address: event.address!)
                            if markerLocations.filter({$0.address == marker.address}).count == 0 {
                                markerLocations.append(marker)
                                
                                minLat = min(minLat, marker.latitude)
                                minLong = min(minLong, marker.longitude)
                                maxLong = max(maxLong, marker.longitude)
                                maxLat = max(maxLat, marker.latitude)
                            }
                        } catch let err {
                            print(err)
                        }
                    }
                    DispatchQueue.main.async {
                        self.region.center.latitude = (minLat + maxLat)/2
                        self.region.center.longitude = (minLong + maxLong)/2
                        
                        self.region.span.latitudeDelta = (maxLat - minLat) * 1.27
                        self.region.span.longitudeDelta = (maxLong - minLong) * 1.37
                    }
                }
                
            }
    }
}
