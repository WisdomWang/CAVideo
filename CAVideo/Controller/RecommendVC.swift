//
//  RecommendVC.swift
//  CAVideo
//
//  Created by Cary on 2019/8/28.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import Alamofire
import EmptyDataSet_Swift

class RecommendVC: UIViewController {
    
    private var mainList = [MainData]()
    
    private  lazy var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.backgroundColor = UIColor.white
        searchBar.textColor = UIColor.gray
        searchBar.tintColor = UIColor.darkGray
        searchBar.font = UIFont.systemFont(ofSize: 15)
        searchBar.placeholder = "请输入搜索关键字"
        searchBar.layer.cornerRadius = 15
        searchBar.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        let img = UIImageView(image: UIImage(named: "search"))
        img.frame = CGRect(x: 10, y: 5, width: 20, height: 20)
        searchBar.addSubview(img)
        searchBar.leftViewMode = .always
        searchBar.clearsOnBeginEditing = true
        searchBar.clearButtonMode = .whileEditing
        searchBar.returnKeyType = .search
        searchBar.delegate = self
        return searchBar
    }()
    
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
        collectionView.register(supplementaryViewType: MainCollectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        self.searchBar.frame = CGRect(x: 0, y: 0, width: xScreenWidth - 60, height: 30)
        navigationItem.titleView = searchBar
        let button = UIButton(type: .detailDisclosure)
        button.addTarget(self, action: #selector(riskCache), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        setupLayout()
        setupLoadData()
        NetworkMonitoring()
    }
    
    @objc func riskCache() {
        
        let alert = UIAlertController(title: "您确定清除缓存\(getCacheSize())么", message: "", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
        }
        let actionRead = UIAlertAction(title: "确认", style: .default) { (UIAlertAction) in
            
            clearCache()
        }
        alert.addAction(actionCancel)
        alert.addAction(actionRead)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupLoadData() {
      
        ApiLoadingProvider.request(.index(vsize: "6"), model: MainData.self) { (returnData) in
            self.mainList = returnData ?? []
            self.collectionView.emptyDataSetDelegate = self
            self.collectionView.emptyDataSetSource = self
            self.collectionView.reloadData()
        }
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    func NetworkMonitoring() {
        
        let net = NetworkReachabilityManager()
        net?.startListening()
        net?.listener = { status in
            switch status{
            case .notReachable:
                print("此时没有网络")
                self.collectionView.emptyDataSetDelegate = self
                self.collectionView.emptyDataSetSource = self
                self.collectionView.reloadData()
                
            case .unknown:
                print("未知")
            case .reachable(.ethernetOrWiFi):
                print("WiFi")
                self.setupLoadData()
            case .reachable(.wwan):
                print("移动网络")
                self.setupLoadData()
            }
        }
    }
}

extension RecommendVC:UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource{
    
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
            vc.ztid = comicList.id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return head
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = mainList[section]
        return comicList.vod?.count ?? 0 > 0 ? CGSize(width: xScreenWidth, height: 44) : CGSize.zero
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

extension RecommendVC:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let vc = SearchVC()
        vc.hidesBottomBarWhenPushed = true
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .moveIn
        transition.subtype = .fromTop
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
        
         return false
    }
}

extension RecommendVC:EmptyDataSetDelegate,EmptyDataSetSource {
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        
        let text =  "网络不给力，请点击重试哦~"
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0), range: NSRange(location: 0, length: text.count))
        attStr.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: text.count))
        attStr.addAttribute(.foregroundColor, value:UIColor.navColor, range: NSRange(location: 7, length: 4))
        return attStr
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        setupLoadData()
    }
}

