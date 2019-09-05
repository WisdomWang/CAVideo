//
//  SearchVC.swift
//  CAVideo
//
//  Created by Cary on 2019/8/28.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class SearchVC: UIViewController {
    
    private var mainList = [Vod]()
    
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

    private  lazy var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.backgroundColor = UIColor.white
        searchBar.textColor = UIColor.gray
        searchBar.tintColor = UIColor.darkGray
        searchBar.font = UIFont.systemFont(ofSize: 15)
        searchBar.placeholder = "输入影剧名称"
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
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledTextDidChange(noti:)), name: UITextField.textDidChangeNotification, object: searchBar)
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.searchBar.frame = CGRect(x: 0, y: 0, width: xScreenWidth - 60, height: 30)
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancelAction))
        
        setupLayout()
    }
    
    @objc private func cancelAction() {
        searchBar.resignFirstResponder()
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .reveal
        transition.subtype = .fromBottom
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }
    
    private func setupLoadData(keyword:String) {
        
        ApiProvider.request(.search(key: keyword, page: "1", size: "100"), model:Vod.self) { (returnData) in
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
}

extension SearchVC:UITextFieldDelegate {
    
    @objc func textFiledTextDidChange(noti: Notification) {
        guard let textField = noti.object as? UITextField,
            let text = textField.text else { return }
            if text == "" {return}
        //若要搜索文字一改变就请求可在该方法执行
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {return}
        setupLoadData(keyword: textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField.text == "" {return textField.resignFirstResponder()}
        setupLoadData(keyword: textField.text!)
        return textField.resignFirstResponder()
    }
}

extension SearchVC:UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource{
    
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

extension SearchVC:EmptyDataSetDelegate,EmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let text =  "暂时没有你想要的资源哦~"
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0), range: NSRange(location: 0, length: text.count))
        attStr.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: 0, length: text.count))
        return attStr
    }
}
