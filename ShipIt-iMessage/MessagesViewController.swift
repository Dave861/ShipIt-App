//
//  MessagesViewController.swift
//  ShipIt-iMessage
//
//  Created by David Retegan on 06.01.2023.
//

import UIKit
import Messages
import SwiftUI

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var packages = [Package]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getPackages()
    }
    
    func getPackages() {
        self.packages = DataController.shared.getStoredDataFromCoreData() as! [Package]
        tableView.reloadData()
    }
    


}
extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharePackageCell") as! SharePackageCell
        cell.titleLbl.text = packages[indexPath.row].name!
        cell.packageIcon.image = UIImage(systemName: packages[indexPath.row].systemImage!)
        cell.statusLbl.text = packages[indexPath.row].statusText!
        switch indexPath.row%3 {
                case 0:
                    cell.packageIcon.tintColor = UIColor(named: "oceanBlue")
                    cell.titleLbl.textColor = UIColor(named: "oceanBlue")
                case 1:
                    cell.packageIcon.tintColor = UIColor(named: "blueNCS")
                    cell.titleLbl.textColor = UIColor(named: "blueNCS")
                case 2:
                    cell.packageIcon.tintColor = UIColor(named: "darkBlue")
                    cell.titleLbl.textColor = UIColor(named: "darkBlue")
                default:
                    cell.packageIcon.tintColor = UIColor(named: "oceanBlue")
                    cell.titleLbl.textColor = UIColor(named: "oceanBlue")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let render = ImageRenderer(content: SharePackageView(package: packages[indexPath.row]))
        render.scale = 3
        if let imageData = render.uiImage?.pngData() {
            // Create a new message with the generated image
            let message = MSMessage()
            let layout = MSMessageTemplateLayout()
            layout.image = UIImage(data: imageData)
            message.summaryText = "Tracked with ShipIt"
            message.layout = layout
            
            // Add the message to the active conversation
            activeConversation?.insert(message)
        }
    }
    
}
