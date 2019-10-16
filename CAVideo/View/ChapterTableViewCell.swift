//
//  ChapterTableViewCell.swift
//  CAVideo
//
//  Created by Cary on 2019/8/29.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

typealias CollcetionViewItemsBlock = (_ model:Ji)->Void

class DetailChapterCollectionCell:BaseCollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()
    
    override func setupLayout(){
        layer.cornerRadius = 3
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    var model:Ji? {
        didSet {
            guard let model = model else {return}
            titleLabel.text = model.name
        }}
}

class ChapterTableViewCell: BaseTableViewCell {
    
    public var themes: [Ji]?
    
    var collectionItemsClosure : CollcetionViewItemsBlock?

    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(cellType: DetailChapterCollectionCell.self)
        return collectionView
    }()
    
    override func setupUI() {
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(250)
        }
    }
}

extension ChapterTableViewCell: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: DetailChapterCollectionCell.self)
        cell.model = themes?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = themes?[indexPath.item]
        collectionItemsClosure!(model!)
    }
}


