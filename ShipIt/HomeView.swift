//
//  HomeView.swift
//  ShipIt
//
//  Created by Mihnea on 12/27/22.
//

import SwiftUI
import PopoverPresenter

struct HomeView: View {
    
    @State private var searchText = String()
    @State private var showSettingsView = false
    @StateObject var popoverPresenter = PopoverPresenter()
    
    var body: some View {
        NavigationStack {
            List() {
                NavigationLink(destination: PackageDetailView()) {
                    VStack{
                        HStack{
                            Image(systemName: "shoeprints.fill")
                                .foregroundColor(Color("oceanBlue"))
                                .font(.title2)
                            Spacer()
                        }
                        HStack{
                            Text("Shoes")
                                .foregroundColor(Color("oceanBlue"))
                                .bold()
                                .font(.title2)
                                .padding([.top, .bottom], 0.2)
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "shippingbox.fill")
                                .foregroundColor(.gray)
                            Text("Out for Delivery")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("Tomorrow")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color("oceanBlue"))
                        }
                    }
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.gray.opacity(0.2)
                               .clipped()
                               .cornerRadius(18))
                .listRowSeparator(.hidden)
                Button {
                    popoverPresenter.currentPopover = AnyView(
                        VStack {
                            Spacer()
                            AddPackageView()
                                .padding()
                            Spacer()
                        }
                    )
                    popoverPresenter.activePopover = .any
                } label: {
                    HStack {
                        Spacer()
                        Label("Add Package", systemImage: "box.truck.fill")
                            .foregroundColor(Color("oceanBlue"))
                            .font(.system(size: 18, weight: .medium))
                            .padding(.top, 5)
                        Spacer()
                    }
                    .padding(.all)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(Color("oceanBlue").opacity(0.45))
                    .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: 50))
                .padding(.bottom, 5)
            }
            .scrollContentBackground(.hidden)
            
            .navigationTitle("Tracking")
            .navigationBarBackButtonHidden(true)
            .onAppear {
                UserDefaults.standard.set(true, forKey: "com.ShipIt.launchToHome")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettingsView.toggle()
                    } label : {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .foregroundColor(Color("oceanBlue"))
                    }
                }
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
        .searchable(text: $searchText, prompt: "Search or Add Package")
        .tint(Color("oceanBlue"))
        .environment(\.popoverPresenterKey, popoverPresenter)
        .customPopover(item: $popoverPresenter.activePopover) { popover in
            switch popover {
            default:
                popoverPresenter.currentPopover
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
