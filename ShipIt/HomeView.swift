//
//  HomeView.swift
//  ShipIt
//
//  Created by Mihnea on 12/27/22.
//

import SwiftUI
import Popovers

struct HomeView: View {
    
    @State private var searchText = String()
    @State private var showSettingsView = false
    @State private var showAddPackageView = false
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var packages : FetchedResults<Package>
    
    var body: some View {
        NavigationStack {
            List() {
                ForEach(packages, id:\.id){ package in
                    NavigationLink(destination: PackageDetailView()) {
                        VStack{
                            HStack{
                                Image(systemName: package.systemImage!)
                                    .foregroundColor(Color("oceanBlue"))
                                    .font(.title2)
                                Spacer()
                            }
                            HStack{
                                Text(package.name!)
                                    .foregroundColor(Color("oceanBlue"))
                                    .bold()
                                    .font(.title2)
                                    .padding([.top, .bottom], 0.2)
                                Spacer()
                            }
                            HStack{
                                Image(systemName: "shippingbox.fill")
                                    .foregroundColor(.gray)
                                Text(package.statusText ?? "Status unknown")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(package.lastDate ?? "0")
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
                }
                Button {
                    showAddPackageView.toggle()
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
        .popover(present: $showAddPackageView, attributes: {
            $0.position = .absolute(
                originAnchor: .top,
                popoverAnchor: .top
            )
        }) {
            AddPackageView(isPresented: $showAddPackageView)
                .environment(\.managedObjectContext, self.moc)
        }
        .searchable(text: $searchText, prompt: "Search or Add Package")
        .tint(Color("oceanBlue"))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
