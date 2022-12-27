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
                    .navigationTitle("Shoes")
                    .cornerRadius(20)
                    .padding([.trailing, .leading, .bottom])
                
                HStack{
                    Text("Delivery Status")
                        .font(.title3)
                        .bold()
                        .padding([.top, .leading, .trailing])
                    Spacer()
                }
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
