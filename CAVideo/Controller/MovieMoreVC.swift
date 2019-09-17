//
//  MovieMoreVC.swift
//  CAVideo
//
//  Created by Cary on 2019/8/28.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import ESPullToRefresh

class MovieMoreVC: UIViewController {
    
    private var mainList = [Vod]()
    var ztid:String?
    var id:String?
    var api:MoyaApi?
    var page:Int = 1
    
    private lazy var collectionView:UICollectionView = {
        let layout = UCollectionViewSectionBackgroundLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        collectionView.backgroundColor = UIColor.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cellType: MainCollectionViewCell.self)
        collectionView.es.addPullToRefresh {
            self.setupLoadData(more: false)
        }
        collectionView.es.addInfiniteScrolling {
            self.setupLoadData(more: true)
        }
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "更多"
        setupLayout()
        setupLoadData(more: false)
    }
    private func setupLoadData(more:Bool) {
        
        page = (more ? (page+1):1)
        if ztid == nil {
            api = .movieMore(page: "\(page)", size: "21", id: id!)
        } else {
            api = .more(page: "\(page)", size: "21", ztid: ztid!)
        }
        
        ApiLoadingProvider.request(api!, model: Vod.self) { (returnData) in
            self.collectionView.es.stopPullToRefresh()
            if returnData?.count == 0 {
                self.collectionView.es.noticeNoMoreData()
            } else {
                self.collectionView.es.stopLoadingMore()
            }
            if more == false {self.mainList.removeAll()}
            self.mainList.append(contentsOf: returnData ?? [])
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

extension MovieMoreVC:UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mainList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MainCollectionViewCell.self)
        cell.model = mainList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(xScreenWidth - 60.0) / 3.0)
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = mainList[indexPath.row]
        let vc = MovieDetailVC(movieId: model.id)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}




