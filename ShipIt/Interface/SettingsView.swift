//
//  SettingsView.swift
//  ShipIt
//
//  Created by Mihnea on 12/27/22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State private var detectClipboardSwitch = true
    @State private var notificationsBeforeSwitch = true
    @State private var liveActivitySwitch = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("SecondGrey")
                    .ignoresSafeArea()
                VStack {
                    Toggle("Detect Clipboard", isOn: $detectClipboardSwitch)
                        .tint(Color("oceanBlue"))
                        .padding(.all)
                        .padding([.leading, .trailing])
                        .frame(height: 45)
                        .background(RoundedRectangle(cornerRadius: 14)
                            .padding([.leading, .trailing])
                            .foregroundColor(Color("W&B")))
                    Toggle("Notifications before Delivery", isOn: $notificationsBeforeSwitch)
                        .tint(Color("blueNCS"))
                        .padding(.all)
                        .padding([.leading, .trailing])
                        .frame(height: 45)
                        .background(RoundedRectangle(cornerRadius: 14)
                            .padding([.leading, .trailing])
                            .foregroundColor(Color("W&B")))
                    Toggle("Show packages in Live Activity", isOn: $liveActivitySwitch)
                        .tint(Color("darkBlue"))
                        .padding(.all)
                        .padding([.leading, .trailing])
                        .frame(height: 45)
                        .background(RoundedRectangle(cornerRadius: 14)
                            .padding([.leading, .trailing])
                            .foregroundColor(Color("W&B")))
                    Spacer()
                    Button(action: {}) {
                        HStack {
                            Spacer()
                            Text("Delete all my data")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding([.top, .bottom], 13)
                        .background(RoundedRectangle(cornerRadius: 14)
                            .foregroundColor(Color.red.opacity(0.4))
                                    .padding([.leading, .trailing]))
                    }
                    Button(action: {}) {
                        HStack {
                            Spacer()
                            Text("Privacy Policy & Legal")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(Color("darkBlue"))
                            Spacer()
                        }
                        .padding([.top, .bottom], 13)
                        .background(RoundedRectangle(cornerRadius: 14)
                            .foregroundColor(Color("darkBlue").opacity(0.4))
                                    .padding([.leading, .trailing]))
                    }
                }
                .navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .frame(width: 10)
                                .fontWeight(.medium)
                            Text("Tracking")
                        }
                        .tint(Color("oceanBlue"))
                    }
                }
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}