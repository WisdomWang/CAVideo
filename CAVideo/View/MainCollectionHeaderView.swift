//
//  MainCollectionHeaderView.swift
//  CAVideo
//
//  Created by Cary on 2019/8/28.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import Hue

// 回调 相当于 OC中的Block (闭包)
typealias MainCollectionHeaderMoreActionBlock = ()->Void

// 代理
protocol MainComicCollecHeaderViewDelegate: class {
    func mainCollectionHeaderView(_ comicCHead: MainCollectionHeaderView, moreAction button: UIButton)
}

class MainCollectionHeaderView: BaseCollectionReusableView {

    // 代理声明 弱引用
    weak var delegate: MainComicCollecHeaderViewDelegate?
    // 回调声明 相当于 OC中的Block
    private var moreActionClosure: MainCollectionHeaderMoreActionBlock?
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor(hex: "#333333")
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var moreButton: UIButton = {
        let mn = UIButton(type: .system)
        mn.setTitle("更多", for: .normal)
        mn.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        mn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        mn.addTarget(self, action: #selector(moreActionClick), for: .touchUpInside)
        return mn
    }()
    
    @objc func moreActionClick(button: UIButton) {
        delegate?.mainCollectionHeaderView(self, moreAction: button)
        
        guard let closure = moreActionClosure else { return }
        closure()
    }
    
    func moreActionClosure(_ closure: MainCollectionHeaderMoreActionBlock?) {
        moreActionClosure = closure
    }
    
    override func setupLayout() {
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.height.equalToSuperview()
        }
        
        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(40)
        }
    }
    
}
