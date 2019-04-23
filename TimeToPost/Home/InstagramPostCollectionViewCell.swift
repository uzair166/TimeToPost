//
//  InstagramPostCollectionViewCell.swift
//  TimeToPost
//
//  Created by Uzair Ishaq on 15/04/2019.
//  Copyright © 2019 Uzair Ishaq. All rights reserved.
//

import UIKit
import Kingfisher

class InstagramPostCollectionViewCell: UICollectionViewCell {
    
    // MARK: properties
    
    var postModelView: InstagramPostView? {
        didSet {
            updateViews()
        }
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 4
        image.layer.masksToBounds = true
        image.image = UIImage(named: "placeholder")
        return image
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Avenir", size: 14)
        return label
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "Avenir", size: 14)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    // MARK: object life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(likesLabel)
        addSubview(commentsLabel)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        likesLabel.frame = CGRect(x: 0, y: frame.width+6, width: frame.width, height: 16)
        commentsLabel.frame = CGRect(x: 0, y: frame.width+25, width: frame.width, height: 16)
    }
    
    func updateViews() {
        self.likesLabel.text = postModelView?.likes
        self.commentsLabel.text = postModelView?.comments
        if let imageURL = postModelView?.imageURL, let url = URL(string: imageURL) {
            self.imageView.kf.setImage(with: url)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = UIImage(named: "placeholder")
    }
    
}
