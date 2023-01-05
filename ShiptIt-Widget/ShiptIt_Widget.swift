//
//  ShiptIt_Widget.swift
//  ShiptIt-Widget
//
//  Created by David Retegan on 05.01.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct ShipItWidgetEntry: TimelineEntry {
    let date = Date()
    let configuration: ConfigurationIntent
}

struct ShipItWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> ShipItWidgetEntry {
        Entry(configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (ShipItWidgetEntry) -> ()) {
        let entry = Entry(configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<ShipItWidgetEntry>) -> Void) {
        let entry = Entry(configuration: configuration)
        let failedUpdates = ["Unknown", "Unknown status"]
        let trackedPackage = entry.configuration.trackedPackage ?? WidgetPackage(identifier: "ph", display: "Placeholder")
        let trackedPackageM = entry.configuration.trackedPackageM ?? WidgetPackage(identifier: "ph", display: "Placeholder")
        
        Task(priority: .high) {
            switch entry.configuration.trackedPackage?.packageCourier {
            case "DHL":
                let updates = try? await WidgetOrderManager.sharedInstance.getDHLOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
            case "Cargus":
                let updates = try? await WidgetOrderManager.sharedInstance.getCargusOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
            case "DPD":
                let updates = try? await WidgetOrderManager.sharedInstance.getDPDOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
            case "Fan Courier":
                let updates = try? await WidgetOrderManager.sharedInstance.getFanCourierOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
            case "GLS":
                let updates = try? await WidgetOrderManager.sharedInstance.getGLSOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
            case "Sameday":
                let updates = try? await WidgetOrderManager.sharedInstance.getSamedayOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
            default:
                trackedPackage.statusDate = "Unknown"
                trackedPackage.packageStatus = "Unknown status"
            }
        }
        if trackedPackageM != WidgetPackage(identifier: "ph", display: "Placeholder") {
            Task(priority: .high) {
                switch entry.configuration.trackedPackage?.packageCourier {
                case "DHL":
                    let updates = try? await WidgetOrderManager.sharedInstance.getDHLOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                    trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                    trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
                case "Cargus":
                    let updates = try? await WidgetOrderManager.sharedInstance.getCargusOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                    trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                    trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
                case "DPD":
                    let updates = try? await WidgetOrderManager.sharedInstance.getDPDOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                    trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                    trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
                case "Fan Courier":
                    let updates = try? await WidgetOrderManager.sharedInstance.getFanCourierOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                    trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                    trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
                case "GLS":
                    let updates = try? await WidgetOrderManager.sharedInstance.getGLSOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                    trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                    trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
                case "Sameday":
                    let updates = try? await WidgetOrderManager.sharedInstance.getSamedayOrderAsync(awb: entry.configuration.trackedPackage!.awb!)
                    trackedPackage.statusDate = (updates ?? failedUpdates)[0]
                    trackedPackage.packageStatus = (updates ?? failedUpdates)[1]
                default:
                    trackedPackage.statusDate = "Unknown"
                    trackedPackage.packageStatus = "Unknown status"
                }
            }
        }
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
}



struct ShiptIt_WidgetEntryView : View {
    var entry: ShipItWidgetProvider.Entry

    @Environment(\.widgetFamily) var family
    let placeholder = WidgetPackage(identifier: "placeholder", display: "TEST_@")
    
    var body: some View {
        switch family {
        case .systemMedium:
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 3) {
                            Image(systemName: "shippingbox.fill")
                                .foregroundColor(Color("oceanBlue"))
                            Text((entry.configuration.trackedPackage ?? placeholder).displayString)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color("oceanBlue"))
                            Text((entry.configuration.trackedPackage ?? placeholder).packageStatus ?? "Unknown Status")
                            Text((entry.configuration.trackedPackage ?? placeholder).statusDate ?? "Jan 4, 12:28")
                                .foregroundColor(Color("russianViolet"))
                        }
                        .padding(.all)
                        .background(RoundedRectangle(cornerRadius: 14.0).foregroundColor(Color("W&B")))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 3) {
                            Image(systemName: "shippingbox.fill")
                                .foregroundColor(Color("oceanBlue"))
                            Text((entry.configuration.trackedPackageM ?? placeholder).displayString)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color("oceanBlue"))
                            Text((entry.configuration.trackedPackageM ?? placeholder).packageStatus ?? "Unknown Status")
                            Text((entry.configuration.trackedPackageM ?? placeholder).statusDate ?? "Jan 4, 12:28")
                                .foregroundColor(Color("russianViolet"))
                        }
                        .padding(.all)
                        .background(RoundedRectangle(cornerRadius: 14.0).foregroundColor(Color("W&B")))
                        Spacer()
                    }
                    Spacer()
                }
                Spacer()
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color("oceanBlue"), Color("blueNCS"), Color("lavenderFloral")]), startPoint: .top, endPoint: .bottom))
        default:
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 3) {
                        Image(systemName: "shippingbox.fill")
                            .foregroundColor(Color("oceanBlue"))
                        Text((entry.configuration.trackedPackage ?? placeholder).displayString)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color("oceanBlue"))
                        Text((entry.configuration.trackedPackage ?? placeholder).packageStatus ?? "Unknown Status")
                        Text((entry.configuration.trackedPackage ?? placeholder).statusDate ?? "Jan 4, 12:28")
                            .foregroundColor(Color("russianViolet"))
                    }
                    .padding([.top, .bottom], 8)
                    .padding([.trailing, .leading], 8)
                    .background(RoundedRectangle(cornerRadius: 14.0).foregroundColor(Color("W&B")))
                    Spacer()
                }
                Spacer()
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color("oceanBlue"), Color("blueNCS"), Color("lavenderFloral")]), startPoint: .top, endPoint: .bottom))
        }
    }
}

struct ShiptIt_Widget: Widget {
    let kind: String = "ShiptIt_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: ShipItWidgetProvider()) { entry in
            ShiptIt_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("ShipIt")
        .supportedFamilies([.systemSmall, .systemMedium])
        .description("Track any package, right on your homescreen.")
    }
}

struct ShiptIt_Widget_Previews: PreviewProvider {
    static var previews: some View {
        ShiptIt_WidgetEntryView(entry: ShipItWidgetEntry(configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
