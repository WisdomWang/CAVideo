//
//  MoviePlayVC.swift
//  CAVideo
//
//  Created by Cary on 2019/8/29.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import BMPlayer

class MoviePlayVC: UIViewController {

    private var model: Ji?
    var name:String?
    
    convenience init(model: Ji) {
        self.init()
        self.model = model
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        let player = BMPlayer()
        view.addSubview(player)
        player.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.right.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
        // Back button event
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                let deviceType = UIDevice.current.model
                if deviceType == "iPad" {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                return
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        let asset = BMPlayerResource(url: URL(string: (model?.purl!)!)!,
                                     name: (model?.name!)!)
        player.setVideo(resource: asset)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

