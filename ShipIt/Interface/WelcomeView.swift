//
//  WelcomeView.swift
//  ShipIt
//
//  Created by Mihnea on 12/27/22.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView{
            VStack {
                Image(systemName: "box.truck.fill")
                    .font(.title)
                    .foregroundColor(Color("oceanBlue"))
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                
                Text("Welcome to")
                    .font(.system(size: 35, weight: .bold))
                    .frame(height: 25)
                
                LinearGradient(gradient: Gradient(colors: [
                                    Color("oceanBlue"),
                                    Color("blueNCS")
                                ]), startPoint: .leading, endPoint: .trailing)
                    .mask(
                        Text("ShipIt")
                            .font(.system(size: 35, weight: .bold))
                    )
                    .frame(height: 45)
                    .padding(.bottom, 15)
                
                ZStack{
                    Rectangle()
                        .fill(colorScheme == .dark ? Color.black : Color.white)
                        .frame(width: 150, height: 70)
                        .cornerRadius(20)
                        .shadow(
                            color: Color.gray.opacity(0.75),
                            radius: 8,
                            x: 0,
                            y: 0
                        )
                    Text("Fast & \n Easy to Use")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("oceanBlue"))
                        .bold()
                        .padding()
                }
                
                HStack{
                    Spacer()
                    ZStack{
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.black : Color.white)
                            .frame(width: 150, height: 70)
                            .cornerRadius(20)
                            .shadow(
                                color: Color.gray.opacity(0.75),
                                radius: 8,
                                x: 0,
                                y: 0
                            )
                        Text("Your Packages. \n Your Data.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("blueNCS"))
                            .bold()
                            .padding()
                    }.padding([.top, .bottom, .leading])
                    Spacer(minLength: 13)
                    ZStack{
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.black : Color.white)
                            .frame(width: 150, height: 70)
                            .cornerRadius(20)
                            .shadow(
                                color: Color.gray.opacity(0.75),
                                radius: 8,
                                x: 0,
                                y: 0
                            )
                        Text("Delivery Date at a Glance.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(colorScheme == .dark ? Color("beauBlue") : Color("russianViolet"))
                            .bold()
                            .padding()
                    }.padding([.top, .bottom, .trailing])
                    Spacer()
                }
                
                Image("box")
                    .padding()
                
                Spacer()
                
                NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true)) {
                    Text("Let's Go")
                        .font(.system(size: 17, weight: .medium))
                        .frame(maxWidth: UIScreen.main.bounds.width-75)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("blueNCS"))
                        .cornerRadius(15)
                        .shadow(
                            color: Color("blueNCS").opacity(0.75),
                            radius: 8,
                            x: 0,
                            y: 0
                        )
                }
                    
            }
        }
        .onAppear {
            UserDefaults.standard.set(true, forKey: userDefaultsClipboardKey)
            UserDefaults.standard.set(true, forKey: userDefaultsNotificationsBeforeDeliveryKey)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
