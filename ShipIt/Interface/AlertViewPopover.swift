//
//  AlertViewPopover.swift
//  ShipIt
//
//  Created by David Retegan on 03.01.2023.
//

import SwiftUI
import Popovers

struct AlertViewPopover: View {
    
    @Binding var present: Bool
    @Binding var expanding: Bool
    @Binding var content: String

    @State var scaled = true

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("Tracking Error")
                    .fontWeight(.semibold)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)

                Text(content)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
            }
            .padding()

            Divider()

            Button {
                present = false
            } label: {
                Text("OK")
                    .fontWeight(.medium)
                    .font(.system(size: 18))
                    .foregroundColor(Color("blueNCS"))
            }
            .buttonStyle(Templates.AlertButtonStyle())
        }
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
        .popoverShadow(shadow: .system)
        .frame(width: 260)
        .scaleEffect(expanding ? 1.05 : 1)
        .scaleEffect(scaled ? 2 : 1)
        .opacity(scaled ? 0 : 1)
        .preferredColorScheme(.light)
        .onAppear {
            withAnimation(.spring(
                response: 0.4,
                dampingFraction: 0.9,
                blendDuration: 1
            )) {
                scaled = false
            }
        }
    }
}
