//
//  TrackingProgressView.swift
//  ShipIt
//
//  Created by Mihnea on 1/4/23.
//

import SwiftUI

struct ShareTrackingProgressView: View {
    @Binding var package: Package
    
    @State var accentColor : Color
    
    @State private var registerCondition = true
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "shippingbox.fill")
                .foregroundColor(Color("oceanBlue"))
                .frame(width: 18, height: 18)
                .font(.system(size: 20))
                .padding()
                .background {
                    Circle()
                        .stroke(accentColor, lineWidth: 4)
                        .background(Circle().foregroundColor(registerCondition ? accentColor : Color("W&B")))
                }
            
            Rectangle()
                .frame(width: 75, height: 10)
                .foregroundColor(registerCondition == true ? accentColor : Color("W&B"))
            
            Image(systemName: "box.truck.fill")
                .foregroundColor(package.eventsArray.first?.systemImage == "box.truck.fill" || package.eventsArray.first?.systemImage == "figure.wave" ? Color("oceanBlue") : .white)
                .frame(width: 18, height: 18)
                .font(.system(size: 20))
                .padding()
                .background {
                    Circle()
                        .stroke(accentColor, lineWidth: 4)
                        .background(Circle().foregroundColor(package.eventsArray.first?.systemImage == "box.truck.fill" || package.eventsArray.first?.systemImage == "figure.wave" ? accentColor : .clear))
                }
            Rectangle()
                .frame(width: 75, height: 10)
                .foregroundColor(package.eventsArray.first?.systemImage == "box.truck.fill" || package.eventsArray.first?.systemImage == "figure.wave" ? accentColor : Color.gray.opacity(0.4))
            
            Image(systemName: "figure.wave")
                .foregroundColor(package.eventsArray.first?.systemImage == "figure.wave" ? Color("oceanBlue") : .white)
                .frame(width: 18, height: 18)
                .font(.system(size: 24))
                .padding()
                .background {
                    Circle()
                        .stroke(accentColor, lineWidth: 4)
                        .background(Circle().foregroundColor(package.eventsArray.first?.systemImage == "figure.wave" ? accentColor : .clear))
                }
        }
    }
}
