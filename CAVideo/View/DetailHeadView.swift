//
//  DetailHeadView.swift
//  CAVideo
//
//  Created by Cary on 2019/8/29.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class DetailHeadView: BaseCollectionReusableView {

    lazy var bgView: UIImageView = {
        let bgView = UIImageView()
        bgView.isUserInteractionEnabled = true
        //bgView.contentMode = .scaleAspectFill
        bgView.blurView.setup(style: .dark, alpha: 1).enable()
        return bgView
    }()
    
    lazy var coverView: UIImageView = {
        let coverView = UIImageView()
       // coverView.contentMode = .scaleAspectFill
        coverView.layer.cornerRadius = 3
        coverView.layer.borderWidth = 1
        coverView.layer.borderColor = UIColor.white.cgColor
        return coverView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        return nameLabel
    }()
    
    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.textColor = UIColor.white
        authorLabel.font = UIFont.systemFont(ofSize: 13)
        authorLabel.numberOfLines = 0
        return authorLabel
    }()
    
    private lazy var totalLabel: UILabel = {
        let totalLabel = UILabel()
        totalLabel.textColor = UIColor.white
        totalLabel.font = UIFont.systemFont(ofSize: 13)
        totalLabel.numberOfLines = 0
        return totalLabel
    }()
    
    private lazy var typelLabel: UILabel = {
        let typelLabel = UILabel()
        typelLabel.textColor = UIColor.white
        typelLabel.font = UIFont.systemFont(ofSize: 13)
        typelLabel.numberOfLines = 0
        return typelLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bgView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(90)
            make.height.equalTo(120)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(coverView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(coverView)
        }
        
        bgView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
        
        bgView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.left.equalTo(authorLabel)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(authorLabel.snp.bottom).offset(5)
        }
        
        bgView.addSubview(typelLabel)
        typelLabel.snp.makeConstraints { make in
            make.left.equalTo(authorLabel)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(totalLabel.snp.bottom).offset(5)
        }
    }
    
    var model:PlotMessageData? {
        didSet {
            guard let model = model else {return}
            bgView.kf.setImage(
                with: URL(string: model.pic!),
                placeholder: nil,
                options: [.transition(.fade(1)), .loadDiskFileSynchronously],
                progressBlock: { receivedSize, totalSize in
            },
                completionHandler: { result in
                    // print(result)
            })
            
            coverView.kf.setImage(
                with: URL(string: model.pic!),
                placeholder: nil,
                options: [.transition(.fade(1)), .loadDiskFileSynchronously],
                progressBlock: { receivedSize, totalSize in
            },
                completionHandler: { result in
                    // print(result)
            })
            
            nameLabel.text = model.name
            authorLabel.text = "导演：\(model.daoyan ?? "")"
            totalLabel.text = "主演：\(model.zhuyan ?? "")"
            typelLabel.text = "类型：\(model.type ?? "")"
        }
    }
}

