//
//  CustomCollectionCell.swift
//  DataProvider
//
//  Created by Guilherme Silva Lisboa on 2016-03-16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import DataProvider

class CustomCollectionCell: UICollectionViewCell,ProviderCellProtocol {
    fileprivate var label : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
        self.backgroundColor = UIColor.black
    }
    
    fileprivate func createView() {
        let frame = CGRect(x: self.frame.size.width/4, y: self.frame.size.height/4, width: self.frame.size.width, height: self.frame.size.height)
        let label = UILabel(frame: frame)
        label.textColor = UIColor.white
        self.addSubview(label)
        self.label = label
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func configureCell(_ cellData: Any) {
        if let person = cellData as? Person {
            label.text = person.name + " " + person.lastName
        }
    }
}
