//
//  TelevisionVC.swift
//  CAVideo
//
//  Created by Cary on 2019/8/28.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit

class TelevisionVC: UIViewController {
    
    private var mainList = [MainData]()
    
    private lazy var collectionView:UICollectionView = {
        let layout = UCollectionViewSectionBackgroundLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = UIColor.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cellType: MainCollectionViewCell.self)
        collectionView.register(supplementaryViewType: MainCollectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "美剧"
        setupLayout()
        setupLoadData()

    }
    
    private func setupLoadData() {
        ApiProvider.request(.movie(id: "2", vsize: "9"), model: MainData.self) { (returnData) in
            self.mainList = returnData ?? []
            self.collectionView.reloadData()
        }
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
}

extension TelevisionVC:UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mainList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = mainList[section]
        return comicList.vod?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MainCollectionHeaderView.self)
        head.backgroundColor = UIColor.background
        let comicList = mainList[indexPath.section]
        head.titleLabel.text = comicList.name
        head.moreActionClosure {
            let vc = MovieMoreVC()
            vc.id = comicList.id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return head
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = mainList[section]
        return comicList.vod?.count ?? 0 > 0 ? CGSize(width: xScreenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return mainList.count - 1 != section ? CGSize(width: xScreenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MainCollectionViewCell.self)
        let comicList = mainList[indexPath.section]
        cell.model = comicList.vod?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(xScreenWidth - 60.0) / 3.0)
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let comicList = mainList[indexPath.section]
        let model = comicList.vod?[indexPath.row]
        let vc = MovieDetailVC(movieId: model!.id)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


