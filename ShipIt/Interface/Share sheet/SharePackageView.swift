//
//  SharePackageView.swift
//  ShipIt
//
//  Created by Mihnea on 1/5/23.
//

import SwiftUI

struct SharePackageView: View {
    @State var package : Package
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("oceanBlue"), Color("blueNCS")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
            VStack{
                HStack{
                    Image(systemName: package.systemImage!)
                        .padding([.trailing, .leading, .top])
                        .font(.title2)
                        .foregroundColor(.white)
                    Spacer()
                }
                HStack{
                    Text(package.name!)
                        .padding([.leading, .bottom, .trailing])
                        .bold()
                        .font(.title)
                        .foregroundColor(.white)
                    Spacer()
                }
                Text(" ")
                ShareTrackingProgressView(package: $package, accentColor: .white)
                Text(" ")
                Text(" ")
                    .font(.title)
                HStack{
                    Image(systemName: "shippingbox.fill")
                        .foregroundColor(.white)
                        .padding(.leading)
                    Text(package.statusText!)
                        .foregroundColor(.white)
                        .bold()
                    Spacer()
                    Text((package.lastDate?.turnToDate().turnToReadableString())!)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.trailing)
                }
            }
        }
    }
}
