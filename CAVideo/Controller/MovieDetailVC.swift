
//
//  MovieDetailVC.swift
//  CAVideo
//
//  Created by Cary on 2019/8/29.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit


class MovieDetailVC: UIViewController {
    
    private let  xDetailOneCell = "DetailOneCell"
    private let  xDetailTwoCell = "DetailTwoCell"
    private var movieId: String?
    private var detailModel:PlotMessageData?
    
    private lazy var headView: DetailHeadView = {
        return DetailHeadView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = self.headView
        tableView.showsVerticalScrollIndicator = false
        tableView.register(cellType: ChapterTableViewCell.self)
        return tableView
    }()
    
    convenience init(movieId: String) {
        self.init()
        self.movieId = movieId
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupLayout()
        loadData()
    }
    
    private func setupLayout(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadData() {
        ApiLoadingProvider.request(.show(id: movieId ?? "")) { (result) in
            guard let returnData = try? result.value?.mapModel(AnotherResponseData<PlotMessageData>.self) else {
                return
            }
            self.detailModel = returnData.data
            self.headView.model = self.detailModel
            self.navigationItem.title = self.detailModel?.name
            self.tableView.reloadData()
        }
    }
}

extension MovieDetailVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 4;
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: xDetailOneCell)
            cell.textLabel?.text = "作品介绍"
            cell.detailTextLabel?.text = "\(detailModel?.text ?? "")"
            cell.textLabel?.textColor = UIColor(hex: "#333333")
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.textColor = UIColor(hex: "#999999")
            cell.selectionStyle = .none
            return cell
        }
        else if(indexPath.row == 1) {
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: xDetailTwoCell)
            cell.textLabel?.text = "\(self.detailModel?.state ?? "")"
            cell.detailTextLabel?.text = "点击量:\(detailModel?.hits ?? "")"
            cell.textLabel?.textColor = UIColor(hex: "#999999")
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.detailTextLabel?.textColor = UIColor(hex: "#999999")
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.selectionStyle = .none
            return cell
        }
        else if (indexPath.row) == 2 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ChapterTableViewCell.self)
            let model:Zu? = detailModel?.zu[0]
            cell.themes = model?.ji
            cell.collectionView.reloadData()
            cell.collectionItemsClosure = { (model) in
                
                let vc = MoviePlayVC(model:model)
                vc.name = model.name
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        
        else {
            
            let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: xDetailOneCell)
            cell.textLabel?.text = "json"
            cell.detailTextLabel?.text = "\(detailModel?.zu ?? [])"
            cell.textLabel?.textColor = UIColor(hex: "#333333")
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.textColor = UIColor(hex: "#999999")
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 {
            
            UIPasteboard.general.string = "\(detailModel?.zu ?? [])"
            let alert = UIAlertController(title: "复制成功～", message: "", preferredStyle: .alert)
            let actionRead = UIAlertAction(title: "知道了", style: .default) { (UIAlertAction) in
            }
            alert.addAction(actionRead)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
