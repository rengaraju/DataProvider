//
//  TableViewProviderDataSourceHandler.swift
//  Pods
//
//  Created by Guilherme Silva Lisboa on 2016-03-22.
//
//

import UIKit

public class TableViewProviderDataSourceHandler : NSObject, UITableViewDataSource{
    // MARK: Properties
    
    public weak var provider : TableViewProvider!
    
    // MARK: UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.provider.sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.provider.sections[section].items.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let providerItem : ProviderItem = self.provider.sections[indexPath.section].items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: providerItem.cellReusableIdentifier)! as UITableViewCell
        
        if let cellProtocol = cell as? ProviderCellProtocol {
            cellProtocol.configureCell(cellData: providerItem.data)
        }
        return cell
    }
}
