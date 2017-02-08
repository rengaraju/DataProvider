//
//  Provider.swift
//  Pods
//
//  Created by Guilherme Silva Lisboa on 2015-12-22.
//
//

public typealias ProviderRemoveItemBlock = ((_ item : ProviderItem) -> Bool)
public typealias ProviderRemoveSectionBlock = ((_ section : ProviderSection) -> Bool)

open class Provider {
    
    // MARK: Properties
    open fileprivate(set) var sections : [ProviderSection]
    
    // MARK: Initialization
    
    /**
    Initialize provider with array of elements
    
    - parameter sections: sections for the provider.
    
    - returns: instance of created provider.
    */
    internal init(withSections sections : [ProviderSection]) {
        self.sections = sections
    }
	
	// MARK: - Public API
    // MARK: Data Methods
    
    /**
    Get the provider item at a specific index path
    
    - parameter indexPath: index path of the desired item.
    
    - returns: item at that index path.
    */
    open func providerItemAtIndexPath(_ indexPath : IndexPath) -> ProviderItem? {
        if(indexPath.section < self.sections.count) {
            let section : ProviderSection = self.sections[indexPath.section]
            if(indexPath.row < section.items.count) {
                return section.items[indexPath.row]
            }
        }
        return nil
    }

    
    // MARK: Sections
    
    /**
    Add sections to provider.
    
    - parameter sections: sections to be added.
    
    - returns: indexset with added sections range.
    */
    internal func addSections(_ sections : [ProviderSection]) -> IndexSet{
        var range : NSRange = NSRange()
        range.location = self.sections.count
        range.length = sections.count
        let indexSet : IndexSet = IndexSet(integersIn: range.toRange() ?? 0..<0)
        self.sections.append(contentsOf: sections)
        return indexSet
    }
    
    /**
    Add section to provider
    
    - parameter section:   section to be added.
    - parameter index: index for the section to be added.
    */
    internal func addSection(_ section : ProviderSection, index : Int) {
        self.sections.insert(section, at: index)
        
    }
    
    /**
     Remove sections with a index set.
     
     - parameter indexes: index set with sections indexes to be deleted.
     */
    internal func removeSections(_ indexes : IndexSet) {
        self.sections.removeObjectsWith(indexes)
    }
    
    /**
     Remove sections of the provider.
     
     - parameter sectionsToRemove: array of sections to remove in the provider.
     - returns: index set of removed sections.
     */
    internal func removeSections(_ removeBlock : ProviderRemoveSectionBlock) -> IndexSet {
        var indexSet = IndexSet()
        
        for (index, section) in self.sections.enumerated() {
            
            if removeBlock(section) {
				indexSet.insert(index)
            }
        }
		
        self.sections.removeObjectsWith(indexSet)
        
        return indexSet
    }
    
    // MARK: Items
    
    /**
    Add Item to provider at a index path
    
    - parameter item:      item to be added.
    - parameter indexPath: index path to add this item at.
    */
    internal func addItemToProvider(_ item : ProviderItem, atIndexPath indexPath : IndexPath) {
        self.sections[indexPath.section].items.insert(item, at: indexPath.row)
    }
    
    /**
     Add an array of items in a section of the provider.
     
     - parameter items:   items to be added.
     - parameter section: index of the provider section to add the items.
     */
    internal func addItemsToProvider(_ items : [ProviderItem], inSection sectionIndex : Int) {
        self.sections[sectionIndex].items.append(contentsOf: items)
    }
    
    /**
     Remove items from provider
     
     - parameter removeBlock:  Block to remove the item.
     - parameter sectionIndex: section index to remove this items from.
     
     - returns: indexes of the deleted items in the section.
     */
    internal func removeItems(_ removeBlock : ProviderRemoveItemBlock, inSection sectionIndex : Int) -> IndexSet{
        
        var indexSet = IndexSet()
        
        for (index, item) in self.sections[sectionIndex].items.enumerated() {
            
            if removeBlock(item) {
                indexSet.insert(index)
            }
        }
		
        self.sections[sectionIndex].items.removeObjectsWith(indexSet)
        return indexSet
    }
    
    /**
     Remove items at index paths
     
     - parameter indexPaths: index paths to be removed.
     */
    internal func removeItems(_ indexPaths : [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            self.sections[indexPath.section].items.remove(at: indexPath.row);
        }
    }
    
    // MARK: update Data
    
    /**
    Replace provider data with new one.
    
    - parameter newSections: new provider data.
    */
    internal func updateProviderData(_ newSections : [ProviderSection]) {
        self.sections = newSections
    }
    
    /**
     Replace the data in a specific section in the provider for the new one.
     
     - parameter newItems:     new section data.
     - parameter sectionIndex: index of the section to replace the data.
     */
    internal func updateSectionData(_ newItems : [ProviderItem], sectionIndexToUpdate sectionIndex : Int) {
        self.sections[sectionIndex].items = newItems
        
    }
    
    
    
    
}
