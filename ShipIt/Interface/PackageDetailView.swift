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
    
    @State private var markerLocations = [Marker]()
    var body: some View {        
        NavigationStack{
            VStack {
                HStack{
                    Text("Where is My Package?")
                        .font(.title3)
                        .bold()
                        .padding([.top, .leading, .trailing])
                    Spacer()
                }
                
                Map(coordinateRegion: $region, showsUserLocation: false, annotationItems: markerLocations) { item in
                    MapMarker(coordinate: .init(latitude: item.latitude, longitude: item.longitude), tint: item.address == package.eventsArray.first?.address ? Color.indigo : Color.red)
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
                            .foregroundColor((Color("oceanBlue")))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(event.text!)
                            Text("\(event.timestamp!) - \(event.address!)")
                                .foregroundColor((Color("oceanBlue")))
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
                    .foregroundColor(Color("oceanBlue"))
                    .font(.system(size: 18, weight: .medium))
                    .padding([.bottom, .top], 12)
                Spacer()
            }
            .background(RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color("oceanBlue").opacity(0.45)))
            .padding([.top, .leading, .trailing])
        }
        Text("Tracking Number 4385722438")
            .font(.system(size: 16))
            .foregroundColor(.gray)
        Spacer()
        .onAppear() {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(package.address ?? "") { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                else {
                    return
                }
                region.center.longitude = location.coordinate.longitude
                region.center.latitude = location.coordinate.latitude
            }
            
            for event in package.eventsArray {
                let address = event.address?.replacingOccurrences(of: "-", with: "")
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(address ?? "") { (placemarks, error) in
                    guard
                        let placemarks = placemarks,
                        let location = placemarks.first?.location
                    else {
                        return
                    }
                    let marker = Marker(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, systemImage: event.systemImage!, address: event.address!)
                    
                    if markerLocations.filter({$0.address == marker.address}).count == 0 {
                        markerLocations.append(marker)
                    }
                }
            }
        }
    }
}
