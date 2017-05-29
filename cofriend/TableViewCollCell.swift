//
//  TableViewCollCell.swift
//  cofriend
//
//  Created by Markus Flodmark on 2017-05-25.
//  Copyright © 2017 Markus Flodmark. All rights reserved.
//

import Foundation
import UIKit

class TableViewCollCell: UITableViewCell {


    

    @IBOutlet private weak var myCollectionView: UICollectionView!
    
    
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        myCollectionView.delegate = dataSourceDelegate
        myCollectionView.dataSource = dataSourceDelegate
        myCollectionView.tag = row
        myCollectionView.setContentOffset(myCollectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        myCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { myCollectionView.contentOffset.x = newValue }
        get { return myCollectionView.contentOffset.x }
    }

}
