//
//  MainCollectionViewCell.swift
//  CAVideo
//
//  Created by Cary on 2019/8/28.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class MainCollectionViewCell: BaseCollectionViewCell {
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 2
        iconView.layer.masksToBounds = true
        return iconView
    }()
    
    private lazy var pfLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.orange
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textAlignment = .right
        return titleLabel
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override func setupLayout() {
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
        }
        
        iconView.addSubview(pfLabel)
        pfLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2);
            make.right.equalToSuperview().offset(-2);
        }
    }
    
    var model:Vod? {
        didSet {
            guard let model = model else {
                return
            }
            iconView.kf.setImage(
                with: URL(string: model.pic),
                placeholder: UIImage(named: "placeholder"),
                options: [.transition(.fade(1)), .loadDiskFileSynchronously],
                progressBlock: { receivedSize, totalSize in
            },
                completionHandler: { result in
                     //print(result)
            })
            titleLabel.text = model.name
            //pfLabel.text = model.pf+"分"
        }
    }
}
