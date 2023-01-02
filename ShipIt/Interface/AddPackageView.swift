//
//  AddPackageView.swift
//  ShipIt
//
//  Created by David Retegan on 28.12.2022.
//

import SwiftUI
import UIKit
import Popovers

enum Courier : String {
    case DHL = "DHL"
    case Sameday = "Sameday"
    case GLS = "GLS"
}

struct AddPackageView: View {
    
    @Binding var isPresented: Bool
    
    @State var pickedIconName = "shippingbox.fill"
    
    @State var trackingNumberFieldText = ""
    @State var packageNameFieldText = ""
    
    @FetchRequest(sortDescriptors: []) var orders : FetchedResults<Package>
    @Environment(\.managedObjectContext) var moc
    
    
    @FocusState var focusOnTrackingNumberField : Bool
    @FocusState var focusOnPackageNameField : Bool
    
    @State private var selectedCourier = Courier.DHL
    
    @State private var hasClipboardContent : Bool = UIPasteboard.general.string != nil

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
                    Text("Cancel")
                        .fontWeight(.medium)
                        .padding(.trailing)
                        .foregroundColor(Color("blueNCS"))
                }
            }
            HStack{
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color.gray.opacity(0.2))
                        .padding([.leading, .trailing])
                        .frame(height: 45)
                    HStack(spacing: 4) {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(uiColor: .systemGray2))
                            .padding(.leading, 10)
                        TextField("Tracking Number", text: $trackingNumberFieldText)
                            .font(.system(size: 17))
                            .tint(Color("blueNCS"))
                            .focused($focusOnTrackingNumberField)
                            .onSubmit {
                                focusOnPackageNameField = true
                            }
                    }
                    .padding()
                }
                if hasClipboardContent {
                    Button {
                        if let value = UIPasteboard.general.string {
                            trackingNumberFieldText = value
                        }
                    } label: {
                        Image(systemName: "doc.on.clipboard")
                    }
                    .padding(.trailing)
                    .frame(width: 30)
                }
            }
            HStack {
                Text("Details")
                    .font(.system(size: 20, weight: .medium))
                    .bold()
                    .padding([.leading, .trailing])
                Spacer()
            }
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color.gray.opacity(0.2))
                        .padding([.leading, .trailing])
                        .frame(height: 45)
                    HStack(spacing: 4) {
                        Image(systemName: "textformat")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(uiColor: .systemGray2))
                            .padding(.leading, 10)
                        TextField("Package Name", text: $packageNameFieldText)
                            .font(.system(size: 17))
                            .tint(Color("blueNCS"))
                            .focused($focusOnPackageNameField)
                    }
                    .padding()
                }
                HStack {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            Button {
                                pickedIconName = "shippingbox.fill"
                            } label: {
                                Image(systemName: "shippingbox.fill")
                                    .font(.system(size: 22))
                                    .padding(.leading)
                                    .foregroundColor($pickedIconName.wrappedValue == "shippingbox.fill" ? Color("blueNCS") : Color.gray)
                            }
                            Button {
                                pickedIconName = "gamecontroller.fill"
                            } label: {
                                Image(systemName: "gamecontroller.fill")
                                    .font(.system(size: 22))
                                    .padding(.leading, 6)
                                    .foregroundColor($pickedIconName.wrappedValue == "gamecontroller.fill" ? Color("blueNCS") : Color.gray)
                            }
                            Button {
                                pickedIconName = "dumbbell.fill"
                            } label: {
                                Image(systemName: "dumbbell.fill")
                                    .font(.system(size: 22))
                                    .padding(.leading, 6)
                                    .foregroundColor($pickedIconName.wrappedValue == "dumbbell.fill" ? Color("blueNCS") : Color.gray)
                            }
                            Button {
                                pickedIconName = "cart.fill"
                            } label: {
                                Image(systemName: "cart.fill")
                                    .font(.system(size: 22))
                                    .padding(.leading, 6)
                                    .foregroundColor($pickedIconName.wrappedValue == "cart.fill" ? Color("blueNCS") : Color.gray)
                            }
                            Button {
                                pickedIconName = "wrench.adjustable.fill"
                            } label: {
                                Image(systemName: "wrench.adjustable.fill")
                                    .font(.system(size: 22))
                                    .padding(.leading, 6)
                                    .foregroundColor($pickedIconName.wrappedValue == "wrench.adjustable.fill" ? Color("blueNCS") : Color.gray)
                            }
                            Button {
                                pickedIconName = "suitcase.fill"
                            } label: {
                                Image(systemName: "suitcase.fill")
                                    .font(.system(size: 22))
                                    .padding(.leading, 6)
                                    .foregroundColor($pickedIconName.wrappedValue == "suitcase.fill" ? Color("blueNCS") : Color.gray)
                            }
                            Button {
                                pickedIconName = "puzzlepiece.fill"
                            } label: {
                                Image(systemName: "puzzlepiece.fill")
                                    .font(.system(size: 22))
                                    .padding(.leading, 6)
                                    .foregroundColor($pickedIconName.wrappedValue == "puzzlepiece.fill" ? Color("blueNCS") : Color.gray)
                            }
                        }
                    }
                    .frame(height: 40)
                    
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color.gray.opacity(0.2))
                        .padding([.leading, .trailing])
                        .frame(height: 45)
                    Templates.Menu {
                        Templates.MenuButton(title: "DHL") { selectedCourier = .DHL }
                        Templates.MenuButton(title: "GLS") { selectedCourier = .GLS }
                        Templates.MenuButton(title: "Sameday") { selectedCourier = .Sameday }
                    } label: { fade in
                        Text(selectedCourier.rawValue)
                            .opacity(fade ? 0.5 : 1)
                    }
                    .padding()
                }
                Button {submitPackage()} label: {
                    HStack {
                        Spacer()
                        Text("Add")
                            .disabled(trackingNumberFieldText == "" || packageNameFieldText == "")
                        Spacer()
                    }
                    .foregroundColor(Color("W&B"))
                    .padding([.top, .bottom], 13)
                    .font(.system(size: 18, weight: .medium))
                    .background(RoundedRectangle(cornerRadius: 14)
                        .foregroundColor(Color("blueNCS"))
                        .padding([.leading, .trailing]))
                }
                .disabled(trackingNumberFieldText == "" || packageNameFieldText == "")
            }
        }
        .frame(width: UIScreen.main.bounds.width-40, height: 385)
        .background(Color("BG2")
            .cornerRadius(22.0)
            .shadow(radius: 15))
        .onAppear() {
            focusOnTrackingNumberField = true
        }
    }
    
    private func submitPackage() {
        if trackingNumberFieldText != "" && packageNameFieldText != "" {
            let newPackage = Package(context: moc)
            newPackage.awb = trackingNumberFieldText
            newPackage.id = UUID()
            newPackage.systemImage = pickedIconName
            newPackage.name = packageNameFieldText
            newPackage.courier = selectedCourier.rawValue
            
            switch selectedCourier {
                case .DHL:
                    Task(priority: .high) {
                        do {
                            try await OrderManager(contextMOC: moc).getDHLOrderAsync(package: newPackage)
                            do {
                                try moc.save()
                                DispatchQueue.main.async {
                                    self.isPresented.toggle()
                                }
                            } catch let err {
                                print(err)
                                print("Core Data Fail")
                            }
                        } catch let err {
                            if err as! OrderManager.OrderErrors == .AWBNotFound {
                                print("Wrong AWB")
                            } else {
                                print("JSON Fail")
                            }
                        }
                    }
                case .Sameday:
                    Task(priority: .high) {
                        do {
                            try await OrderManager(contextMOC: moc).getSamedayOrderAsync(package: newPackage)
                            do {
                                try moc.save()
                                DispatchQueue.main.async {
                                    self.isPresented.toggle()
                                }
                            } catch let err {
                                print(err)
                                print("Core Data Fail")
                            }
                        } catch let err {
                            if err as! OrderManager.OrderErrors == .AWBNotFound {
                                print("Wrong AWB")
                            } else {
                                print("JSON Fail")
                            }
                        }
                    }
            case .GLS:
                Task(priority: .high) {
                    do {
                        try await OrderManager(contextMOC: moc).getGLSOrderAsync(package: newPackage)
                        do {
                            try moc.save()
                            DispatchQueue.main.async {
                                self.isPresented.toggle()
                            }
                        } catch let err {
                            print(err)
                            print("Core Data Fail")
                        }
                    } catch let err {
                        if err as! OrderManager.OrderErrors == .AWBNotFound {
                            print("Wrong AWB")
                        } else {
                            print("JSON Fail")
                        }
                    }
                }
                
            }
        } else {
            print("Please fill in fields")
        }
       
    }
}

