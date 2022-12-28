//
//  AddPackageView.swift
//  ShipIt
//
//  Created by David Retegan on 28.12.2022.
//

import SwiftUI

struct AddPackageView: View {
    
    @Binding var isPresented: Bool
    
    @State var trackingNumberFieldText = "Tracking Number"
    @State var packageNameFieldText = "Package Name"
    @State var websiteLinkFieldText = "Order Link"
    
    var body: some View {
        VStack {
            HStack {
                Text("Add Package")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.leading)
                Spacer()
                Button {
                    isPresented.toggle()
                } label: {
                    Button {} label: {
                        
                        Text("Cancel")
                            .fontWeight(.medium)
                            .padding(.trailing)
                            .foregroundColor(Color("blueNCS"))
                    }
                }
                HStack(spacing: 4) {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.gray)
                        .padding(.leading, 10)
                    TextField("", text: $trackingNumberFieldText).foregroundColor(Color.gray).font(.system(size: 17))
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color.gray.opacity(0.2))
                    .padding([.leading, .trailing])
                    .padding([.top, .bottom], 5))
                HStack {
                    Text("Optional Details")
                        .font(.system(size: 20, weight: .medium))
                        .bold()
                        .padding([.leading, .trailing])
                    Spacer()
                }
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "textformat")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.gray)
                            .padding(.leading, 10)
                        TextField("", text: $packageNameFieldText).foregroundColor(Color.gray).font(.system(size: 17))
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color.gray.opacity(0.2))
                        .padding([.leading, .trailing])
                        .padding([.top, .bottom], 5))
                    HStack {
                        Image(systemName: "shippingbox.fill")
                            .font(.system(size: 22))
                            .padding(.leading)
                            .padding(.leading, 8)
                            .foregroundColor(Color("blueNCS"))
                        Button {} label: {
                            HStack {
                                Spacer()
                                Text("Pick Icon")
                                Spacer()
                            }
                            .foregroundColor(Color("blueNCS"))
                            .padding([.top, .bottom], 10)
                            .font(.system(size: 18, weight: .medium))
                            .background(RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(Color("blueNCS").opacity(0.45))
                                .padding([.leading, .trailing]))
                        }
                        
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "link")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.gray)
                            .padding(.leading, 10)
                        TextField("", text: $websiteLinkFieldText).foregroundColor(Color.gray).font(.system(size: 17))
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color.gray.opacity(0.2))
                        .padding([.leading, .trailing])
                        .padding([.top, .bottom], 5))
                }
            }
            .frame(width: UIScreen.main.bounds.width-40, height: 350)
            .background(Color("W&B")
                .cornerRadius(22.0)
                .shadow(radius: 15))
        }
    }
}

