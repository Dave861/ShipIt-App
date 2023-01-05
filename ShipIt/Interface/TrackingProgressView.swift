//
//  TrackingProgressView.swift
//  ShipIt
//
//  Created by Mihnea on 1/4/23.
//

import SwiftUI

struct TrackingProgressView: View {
    @Binding var package: Package
    
    @State var accentColor : Color
    
    @State private var registerCondition = false
    @State private var transitCondition = false
    @State private var deliveryCondition = false
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "shippingbox.fill")
                .foregroundColor(registerCondition ? Color("W&B") : accentColor)
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
                .foregroundColor(transitCondition == true ? Color("W&B") : accentColor)
                .frame(width: 18, height: 18)
                .font(.system(size: 20))
                .padding()
                .background {
                    Circle()
                        .stroke(accentColor, lineWidth: 4)
                        .background(Circle().foregroundColor(transitCondition ? accentColor : Color("W&B")))
                }
            Rectangle()
                .frame(width: 75, height: 10)
                .foregroundColor(transitCondition ? accentColor : Color.gray.opacity(0.4))
            
            Image(systemName: "figure.wave")
                .foregroundColor(deliveryCondition ? Color("W&B") : accentColor)
                .frame(width: 18, height: 18)
                .font(.system(size: 24))
                .padding()
                .background {
                    Circle()
                        .stroke(accentColor, lineWidth: 4)
                        .background(Circle().foregroundColor(deliveryCondition ? accentColor : Color("W&B")))
                }
        }
        .onAppear() {
            withAnimation(.linear(duration: 1)) {
                registerCondition = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                withAnimation(.linear(duration: 1)){
                    transitCondition = package.eventsArray.first?.systemImage == "box.truck.fill" || package.eventsArray.first?.systemImage == "figure.wave"
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                withAnimation(.linear(duration: 1)){
                    deliveryCondition = package.eventsArray.first?.systemImage == "figure.wave"
                }
            }
        }
    }
}
