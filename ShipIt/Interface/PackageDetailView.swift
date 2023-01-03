//
//  PackageDetailView.swift
//  ShipIt
//
//  Created by Mihnea on 12/27/22.
//

import SwiftUI
import MapKit

struct PackageDetailView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 11.25, longitudeDelta: 22.5))
    @State var package : Package
    @State var accentColor : Color
    
    @State private var markerLocations = [Marker]()
    
    @State private var minLong = 180.0
    @State private var maxLong = 0.0
    @State private var minLat = 90.0
    @State private var maxLat = 0.0
    
    @State private var nameTextField = ""
    
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "pencil")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding(.leading)
                    TextField("", text: $nameTextField)
                        .bold()
                        .font(.title)
                        .padding(.trailing)
                        .onSubmit {
                            package.name = nameTextField
                            try? moc.save()
                        }
                    Spacer()
                }
                if minLong != 180.0 && minLat != 90 {
                    Map(coordinateRegion: $region, showsUserLocation: false, annotationItems: markerLocations) { item in
                        MapMarker(coordinate: .init(latitude: item.latitude, longitude: item.longitude), tint: item.address == package.eventsArray.first?.address ? accentColor : Color.gray)
                    }
                    .frame(height: UIScreen.main.bounds.height/4)
                    .cornerRadius(20)
                    .padding([.trailing, .leading])
                }
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
                            HStack{
                                Text("\(String(event.timestamp!.split(separator: "T")[0]))")
                                    .foregroundColor((accentColor))
                                    .font(.system(size: 17))
                                Spacer()
                                Text("\(event.address!.replacingOccurrences(of: " - ", with: ", "))")
                                    .foregroundColor((accentColor))
                                    .font(.system(size: 17))
                                    .padding(.trailing)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(RoundedRectangle(cornerRadius: 16)
                        .padding([.leading, .trailing])
                        .foregroundColor(index%2 == 0 ? Color.gray.opacity(0.2) : Color.clear)
                    )
                    
                }
                Spacer()
            }
        }
        .listStyle(.plain)
        //        .navigationTitle(package.name!)
        Text("Tracking Number \(package.awb!)")
            .font(.footnote)
            .foregroundColor(.gray)
        Spacer()
            .onAppear() {
                nameTextField = package.name!
                
                let geoCoder = CLGeocoder()
                var lastLocation: CLLocation!
                Task(priority: .high) {
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
                    
                    let events = package.eventsArray
//                    if package.eventsArray.count > 5 {
//                        events = Array(package.eventsArray[..<5])
//                    }
                    
                    for event in events {
                        var address = event.address!
                        if address.contains("-") {
                            address = address.replacingOccurrences(of: "-", with: "")
                        }
                        let geoCoder = CLGeocoder()
                        var markerLocation: CLLocation!
                        
                        do {
                            let placemarks = try await geoCoder.geocodeAddressString(address)
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
                    }
                }
                
            }
    }
}
