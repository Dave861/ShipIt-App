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
    
    func decideAccentOnIndex(index: Int) -> Color {
        switch index%3 {
            case 0:
                return Color("oceanBlue")
            case 1:
                return Color("blueNCS")
            case 2:
                return Color("darkBlue")
            default:
                return Color("oceanBlue")
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(packages.indexed(), id: \.1.self) { index, package in
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .foregroundColor(Color.gray.opacity(0.2))
                        NavigationLink(destination: PackageDetailView(package: package, accentColor: decideAccentOnIndex(index: index))) {
                            VStack {
                                HStack {
                                    Image(systemName: package.systemImage ?? "questionmark")
                                        .foregroundColor(decideAccentOnIndex(index: index))
                                        .font(.title2)
                                    Spacer()
                                    Text(package.courier ?? "")
                                        .foregroundColor(decideAccentOnIndex(index: index))
                                }
                                HStack{
                                    Text(package.name ?? "ShipIt")
                                        .foregroundColor(decideAccentOnIndex(index: index))
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
                                    Text(String((package.lastDate ?? "0").split(separator: "T")[0]))
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(decideAccentOnIndex(index: index))
                                }
                            }
                        }
                        .padding([.leading, .trailing])
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            moc.delete(package)
                            try? moc.save()
                        } label : {
                            Image(systemName: "trash.fill")
                        }
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color("W&B"))
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
            .listStyle(.plain)
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
            $0.blocksBackgroundTouches = true
        }) {
            AddPackageView(isPresented: $showAddPackageView)
                .environment(\.managedObjectContext, self.moc)
        }
        .searchable(text: $searchText, prompt: "Search or Add Package")
        .onChange(of: searchText) { search in
            packages.nsPredicate = search.isEmpty ? nil : NSPredicate(format: "name CONTAINS %@" , search)
        }
        .refreshable {
            for package in packages {
                while package.eventsArray.count >= 1 {
                    package.removeFromEvents(package.eventsArray[package.eventsArray.count-1])
                }
                if package.courier == "DHL" {
                    Task(priority: .high) {
                        do {
                            try await OrderManager(contextMOC: moc).getDHLOrderAsync(package: package)
                            do {
                                try moc.save()
                            } catch let err {
                                print(err)
                            }
                        } catch let err {
                            print(err)
                        }
                    }
                } else if package.courier == "Sameday" {
                    Task(priority: .high) {
                        do {
                            try await OrderManager(contextMOC: moc).getSamedayOrderAsync(package: package)
                            do {
                                try moc.save()
                            } catch let err {
                                print(err)
                            }
                        } catch let err {
                            print(err)
                        }
                    }
                } else if package.courier == "GLS" {
                    Task(priority: .high) {
                        do {
                            try await OrderManager(contextMOC: moc).getGLSOrderAsync(package: package)
                            do {
                                try moc.save()
                            } catch let err {
                                print(err)
                            }
                        } catch let err {
                            print(err)
                        }
                    }
                } else if package.courier == "Cargus" {
                    Task(priority: .high) {
                        do {
                            try await OrderManager(contextMOC: moc).getCargusOrderAsync(package: package)
                            do {
                                try moc.save()
                            } catch let err {
                                print(err)
                            }
                        } catch let err {
                            print(err)
                        }
                    }
                }
            }
        }
        .tint(Color("oceanBlue"))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
