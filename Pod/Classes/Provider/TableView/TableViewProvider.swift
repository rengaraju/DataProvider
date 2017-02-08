//
//  ProviderTableView.swift
//  Pods
//
//  Created by Guilherme Silva Lisboa on 2015-12-22.
//
//

import UIKit

open class TableViewProvider : Provider {
	
	// MARK: Properties
	
	open weak var delegate : TableViewProviderDelegate?
	fileprivate unowned var tableView : UITableView
    fileprivate var tableViewDelegate : TableViewProviderDelegateHandler!
    fileprivate var tableViewDataSource : TableViewProviderDataSourceHandler!
	// MARK: Initialization
	
	/**
	Initialize table view provider for use on table view.
	
	- parameter tableView: provider's table view.
	- parameter sections:  initial sections data for the table view.
	- parameter delegate:  provider delegate.
	- parameter cellConfiguration : configuration for the provider cells registration on the table view.
	
	- returns: instance of the provider.
	*/
    public init(withTableView tableView: UITableView, sections: [ProviderSection],
                              delegate : TableViewProviderDelegate?, cellConfiguration : [ProviderConfiguration],
                              tableDelegate : TableViewProviderDelegateHandler = TableViewProviderDelegateHandler(), tableDataSource : TableViewProviderDataSourceHandler = TableViewProviderDataSourceHandler()) {
        self.delegate = delegate
        self.tableView = tableView        
		super.init(withSections: sections)
		self.configureTableView(cellConfiguration, tableDelegate: tableDelegate, tableDataSource: tableDataSource)
	}
    
	// MARK: - Public API
	// MARK: Section
	/**
	Add sections to table view.
	
	- parameter sections:     sections to be added.
	- parameter rowAnimation: UITableViewRowAnimation for the sections.
	*/
	open func addSections(_ sections: [ProviderSection], rowAnimation : UITableViewRowAnimation = UITableViewRowAnimation.automatic) {
		let indexSet : IndexSet = super.addSections(sections)
		self.tableView.insertSections(indexSet, with: rowAnimation)
	}
	
	/**
	Add section to table view in a specific index.
	
	- parameter section:      section to be added.
	- parameter index:        index of the section to be added.
	- parameter rowAnimation: UITableViewRowAnimation for section insert.
	*/
	open func addSection(_ section: ProviderSection, index: Int, rowAnimation : UITableViewRowAnimation = UITableViewRowAnimation.automatic) {
		super.addSection(section, index: index)
		self.tableView.insertSections(IndexSet(integer: index), with: rowAnimation)
	}
	
	/**
	remove sections from table view.
	
	- parameter removeBlock: block to remove the sections with. return true to remove, false otherwise.
	- parameter rowAnimation:     UITableViewRowAnimation for the deletion.
	*/
	open func removeSections(_ rowAnimation : UITableViewRowAnimation = UITableViewRowAnimation.automatic, removeBlock : ProviderRemoveSectionBlock) {
		let indexSet : IndexSet = super.removeSections(removeBlock)
		self.tableView.deleteSections(indexSet, with: rowAnimation)
	}
	
	/**
	Remove Sections at indexes in an index set.
	
	- parameter indexes:      index set
	- parameter rowAnimation: UITableViewRowAnimation for the deletion.
	*/
	open func removeSections(_ indexes: IndexSet, rowAnimation : UITableViewRowAnimation = UITableViewRowAnimation.automatic) {
		super.removeSections(indexes)
		self.tableView.deleteSections(indexes, with: rowAnimation)
	}
	
	// MARK: Items
	/**
	Add items to table view in a specific section.
	
	- parameter items:        items to be added.
	- parameter sectionIndex: index of section to add items.
	- parameter rowAnimation: UITableViewRowAnimation for the insertion.
	*/
	open func addItemsToProvider(_ items: [ProviderItem], inSection sectionIndex: Int, rowAnimation : UITableViewRowAnimation = UITableViewRowAnimation.automatic) {
		let initialPosition = self.sections[sectionIndex].items.count
		super.addItemsToProvider(items, inSection: sectionIndex)
		
		var indexPaths : [IndexPath] = []
		for i in initialPosition..<self.sections[sectionIndex].items.count {
			indexPaths.append(IndexPath(row: i, section: sectionIndex))
		}
		self.tableView.insertRows(at: indexPaths, with: rowAnimation)
	}
	
    /**
     Insert Items in provider from a specific index path.
     
     - parameter items:        items to be inserted
     - parameter indexPath:    starting index path
     - parameter rowAnimation: UITableViewRowAnimation for the insertion.
     */
    open func insertItemsToProvider(_ items: [ProviderItem], fromIndexPath indexPath: IndexPath, rowAnimation: UITableViewRowAnimation) {
        var indexPaths = [IndexPath]()
        for (index, item) in items.enumerated() {
            let newIndexPath = IndexPath(row: indexPath.row + index, section: indexPath.section)
            indexPaths.append(newIndexPath)
            super.addItemToProvider(item, atIndexPath: newIndexPath)
        }
        tableView.insertRows(at: indexPaths, with: rowAnimation)
    }

    
	/**
	Add item to provider in a specific index path.
	
	- parameter item:         item to be added.
	- parameter indexPath:    index path to add the item.
	- parameter rowAnimation: UITableViewRowAnimation for the insertion.
	*/
	open func addItemToProvider(_ item: ProviderItem, atIndexPath indexPath: IndexPath, rowAnimation : UITableViewRowAnimation = UITableViewRowAnimation.automatic) {
		super.addItemToProvider(item, atIndexPath: indexPath)
		
		self.tableView.insertRows(at: [indexPath], with: rowAnimation)
	}
	
    
    
    /**
     Remove items in a section with a block.
     
     - parameter removeBlock:  Items to be removed from section.
     - parameter sectionIndex: index of the section to remove those items.
     - parameter rowAnimation: row animation for the deletion.
     */
    open func removeItems(_ removeBlock : ProviderRemoveItemBlock, inSection sectionIndex: Int, rowAnimation : UITableViewRowAnimation = UITableViewRowAnimation.automatic)  {
        let indexSet : IndexSet = super.removeItems(removeBlock, inSection: sectionIndex)
        
        var indexPaths : [IndexPath] = []
		for (index, _) in indexSet.enumerated() {
			indexPaths.append(IndexPath(row: index, section: sectionIndex))
		}
        
        self.tableView.deleteRows(at: indexPaths, with: rowAnimation)
    }
	
    /**
     Remove items at index paths from provider and table view.
     
     - parameter indexPaths:   index paths of items to be removed.
     - parameter rowAnimation: row animation for the deletion.
     */
    open func removeItems(_ indexPaths : [IndexPath], rowAnimation : UITableViewRowAnimation = UITableViewRowAnimation.automatic) {
        super.removeItems(indexPaths)
		
        self.tableView.deleteRows(at: indexPaths, with: rowAnimation)
    }
    
	// MARK: Update
	
	override open func updateProviderData(_ newSections: [ProviderSection]) {
		super.updateProviderData(newSections)
		self.tableView.reloadData()
	}
	
	/**
	Replace the data in a table view section.
	
	- parameter newItems:     new items for the section
	- parameter sectionIndex: index of the section to update.
	- parameter rowAnimation: UITableViewRowAnimation for the operation.
	*/
	open func updateSectionData(_ newItems: [ProviderItem], sectionIndexToUpdate sectionIndex: Int, rowAnimation : UITableViewRowAnimation = UITableViewRowAnimation.automatic) {
		super.updateSectionData(newItems, sectionIndexToUpdate: sectionIndex)
		self.tableView.reloadSections(IndexSet(integer: sectionIndex), with: rowAnimation)
	}
	
	// MARK: - Private API
	// MARK: Configuration
	
	/**
	Configure table view for use with provider.
	
	- parameter tableView:     table view to be configured.
	- parameter configuration: extra configuration for cells if desired.
	*/
	fileprivate func configureTableView (_ configuration : [ProviderConfiguration], tableDelegate : TableViewProviderDelegateHandler, tableDataSource : TableViewProviderDataSourceHandler) {
        
        self.tableViewDelegate = tableDelegate
        self.tableViewDataSource = tableDataSource
        
        tableDataSource.provider = self
        tableDelegate.provider = self
        
        self.tableView.delegate = tableDelegate
        self.tableView.dataSource = tableDataSource
        
		
		for config in configuration {
			if (config.cellClass != nil) {
				tableView.register(config.cellClass, forCellReuseIdentifier: config.cellReuseIdentifier)
			} else {
				tableView.register(UINib(nibName: config.cellNibName!, bundle: config.nibBundle), forCellReuseIdentifier: config.cellReuseIdentifier)
			}
		}
	}
}
