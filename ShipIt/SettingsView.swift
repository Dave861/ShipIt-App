//
//  SettingsView.swift
//  ShipIt
//
//  Created by Mihnea on 12/27/22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    
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
                }
                .navigationTitle("Settings")
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
