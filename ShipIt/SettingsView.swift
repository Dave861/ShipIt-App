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
            List() {
                Toggle("Detect clipboard", isOn: $detectClipboardSwitch)
                Toggle("Notifications before delivery", isOn: $notificationsBeforeSwitch)
                Toggle("Show packages in live activity", isOn: $liveActivitySwitch)
            }
                .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
