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
    
    var deliveryStatus = [
        DeliveryStatus(systemImage: "figure.stand", statusText: "Handed to Courier", lastDate: "21.12.2022 14:53"),
        DeliveryStatus(systemImage: "building.fill", statusText: "Arrived at Processing Hub", lastDate: "20.12.2022 19:55"),
        DeliveryStatus(systemImage: "mail.fill", statusText: "Picked from Sender", lastDate: "19.12.2022 12:04")
    ]
        
    var body: some View {
        let withIndex = deliveryStatus.enumerated().map({ $0 })
        
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
                    .navigationTitle("Shoes")
                    .cornerRadius(20)
                    .padding([.trailing, .leading])
                
                HStack {
                    Text("Delivery Status")
                        .font(.title3)
                        .bold()
                        .padding([.top, .leading, .trailing])
                    Spacer()
                }
                List(withIndex, id: \.element.statusText) { index, deliveryStatus in
                    HStack {
                        Image(systemName: deliveryStatus.systemImage)
                            .font(.system(size: 25))
                            .frame(width: 40)
                            .foregroundColor((Color("oceanBlue")))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(deliveryStatus.statusText)
                            Text(deliveryStatus.lastDate)
                                .foregroundColor((Color("oceanBlue")))
                                .font(.system(size: 17))
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(RoundedRectangle(cornerRadius: 16)
                        .padding([.leading, .trailing])
                        .foregroundColor(index%2 == 0 ? Color.gray.opacity(0.2) : Color.clear))
                    
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
            }
        }
    }
}

struct PackageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PackageDetailView()
    }
}
