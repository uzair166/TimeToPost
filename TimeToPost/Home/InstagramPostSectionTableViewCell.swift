//
//  InstagramPostSectionTableViewCell.swift
//  TimeToPost
//
//  Created by Uzair Ishaq on 15/04/2019.
//  Copyright © 2019 Uzair Ishaq. All rights reserved.
//

import UIKit

class InstagramPostSectionTableViewCell: UITableViewCell {
    
    // MARK: object life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: properties
    
    let itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let sectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupView() {
        contentView.backgroundColor = UIColor.clear
        addSubview(itemsCollectionView)
        addSubview(dividerLineView)
        addSubview(sectionNameLabel)
        itemsCollectionView.addConstraint(NSLayoutConstraint(item: itemsCollectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (420/2)))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[sectionNameLabel]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["sectionNameLabel": sectionNameLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[dividerLineView]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["dividerLineView": dividerLineView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[itemsCollectionView]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["itemsCollectionView": itemsCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dividerLineView(0.5)][sectionNameLabel(40)][itemsCollectionView]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["itemsCollectionView": itemsCollectionView, "dividerLineView": dividerLineView, "sectionNameLabel": sectionNameLabel]))
        
        itemsCollectionView.register(InstagramPostCollectionViewCell.self, forCellWithReuseIdentifier: AppConfiguration.TableViewCellIDs.cell)
    }



}


// MARK: ui collection view data source

extension InstagramPostSectionTableViewCell{
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        itemsCollectionView.delegate = dataSourceDelegate
        itemsCollectionView.dataSource = dataSourceDelegate
        itemsCollectionView.tag = row
        itemsCollectionView.setContentOffset(itemsCollectionView.contentOffset, animated: false)
        itemsCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { itemsCollectionView.contentOffset.x = newValue }
        get { return itemsCollectionView.contentOffset.x }
    }
}
