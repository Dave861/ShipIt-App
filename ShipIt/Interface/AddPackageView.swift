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
    case Cargus = "Cargus"
}

struct AddPackageView: View {
    
    @Binding var isPresented: Bool
    
    @State var pickedIconName = "shippingbox.fill"
    
    @State var trackingNumberFieldText = ""
    @State var packageNameFieldText = ""
    
    @FetchRequest(sortDescriptors: []) var orders : FetchedResults<Package>
    @Environment(\.managedObjectContext) var moc
    
    @State var showAlert: Bool = false
    @State var alertText: String = "There was an error tracking this AWB. Please enter a valid AWB or check the courier."
    @State var expanding = false
    
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
                        Templates.MenuButton(title: "Cargus") { selectedCourier = .Cargus }
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
                .alert("Tracking Error", isPresented: $showAlert, actions: {
                    Button("OK", role: .cancel) { }
                }, message: {
                    Text("Please enter a valid tracking number for the selected courier.")
                })
            }
        }
        .frame(width: UIScreen.main.bounds.width-40, height: 385)
        .background(Color("BG2")
            .cornerRadius(22.0)
            .shadow(radius: 15))
        .onAppear() {
            focusOnTrackingNumberField = true
        }
        .popover(
            present: $showAlert,
            attributes: {
                $0.blocksBackgroundTouches = true
                $0.rubberBandingMode = .none
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
                    ]
                )
                $0.presentation.animation = .easeOut(duration: 0.15)
                $0.dismissal.mode = .none
                $0.onTapOutside = {
                    withAnimation(.easeIn(duration: 0.15)) {
                        expanding = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 0.4)) {
                            expanding = false
                        }
                    }
                }
            }
        ) {
            AlertViewPopover(present: $showAlert, expanding: $expanding, content: $alertText)
        } background: {
            Color.black.opacity(0.1)
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
                                DispatchQueue.main.async {
                                    self.alertText = "Oops! We encountered an error saving your package data."
                                    self.showAlert.toggle()
                                }
                            }
                        } catch let err {
                            if err as! OrderManager.OrderErrors == .AWBNotFound {
                                print("Wrong AWB")
                                DispatchQueue.main.async {
                                    self.alertText = "There was an error tracking this AWB. Please enter a valid AWB or check the courier."
                                    self.showAlert.toggle()
                                }
                            } else {
                                print("JSON Fail")
                                DispatchQueue.main.async {
                                    self.alertText = "There was a problem with the courier's tracking response."
                                    self.showAlert.toggle()
                                }
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
                                DispatchQueue.main.async {
                                    self.alertText = "Oops! We encountered an error saving your package data."
                                    self.showAlert.toggle()
                                }
                            }
                        } catch let err {
                            if err as! OrderManager.OrderErrors == .AWBNotFound {
                                print("Wrong AWB")
                                DispatchQueue.main.async {
                                    self.alertText = "There was an error tracking this AWB. Please enter a valid AWB or check the courier."
                                    self.showAlert.toggle()
                                }
                            } else {
                                print("JSON Fail")
                                DispatchQueue.main.async {
                                    self.alertText = "There was a problem with the courier's tracking response."
                                    self.showAlert.toggle()
                                }
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
                            DispatchQueue.main.async {
                                self.alertText = "Oops! We encountered an error saving your package data."
                                self.showAlert.toggle()
                            }
                        }
                    } catch let err {
                        if err as! OrderManager.OrderErrors == .AWBNotFound {
                            print("Wrong AWB")
                            DispatchQueue.main.async {
                                self.alertText = "There was an error tracking this AWB. Please enter a valid AWB or check the courier."
                                self.showAlert.toggle()
                            }
                        } else {
                            print("JSON Fail")
                            DispatchQueue.main.async {
                                self.alertText = "There was a problem with the courier's tracking response."
                                self.showAlert.toggle()
                            }
                        }
                    }
                }
            case .Cargus:
                Task(priority: .high) {
                    do {
                        try await OrderManager(contextMOC: moc).getCargusOrderAsync(package: newPackage)
                        do {
                            try moc.save()
                            DispatchQueue.main.async {
                                self.isPresented.toggle()
                            }
                        } catch let err {
                            print(err)
                            print("Core Data Fail")
                            DispatchQueue.main.async {
                                self.alertText = "Oops! We encountered an error saving your package data."
                                self.showAlert.toggle()
                            }
                        }
                    } catch let err {
                        if err as! OrderManager.OrderErrors == .AWBNotFound {
                            print("Wrong AWB")
                            DispatchQueue.main.async {
                                self.alertText = "There was an error tracking this AWB. Please enter a valid AWB or check the courier."
                                self.showAlert.toggle()
                            }
                        } else {
                            print("JSON Fail")
                            DispatchQueue.main.async {
                                self.alertText = "There was a problem with the courier's tracking response."
                                self.showAlert.toggle()
                            }
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.alertText = "Please fill in all required fields."
                self.showAlert.toggle()
            }
        }
       
    }
}

