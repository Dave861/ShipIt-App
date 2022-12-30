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
                
                Map(coordinateRegion: $region)
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
                            Text(event.timestamp!)
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
        }
    }
}
