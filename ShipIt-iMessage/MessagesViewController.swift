//
//  MessagesViewController.swift
//  ShipIt-iMessage
//
//  Created by David Retegan on 06.01.2023.
//

import UIKit
import Messages

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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = UIImage(named: "TEST")
        // Create a new message with the generated image
        let message = MSMessage()
        let layout = MSMessageTemplateLayout()
        layout.image = image
        message.summaryText = "Tracked with ShipIt"
        message.layout = layout
        
        // Add the message to the active conversation
        activeConversation?.insert(message)
    }
    
}
