//
//  AppFullscreenController.swift
//  AppStoreJA
//
//  Created by joe on 2023/05/15.
//

import UIKit

class AppFullscreenController: UITableViewController {
    
    var dismissHandler: (() -> ())?
    var todayItem: TodayItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never   // top area of safeAreaLayoutGuide gets gone
        
        /*
        let statusBarHeight = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.windowScene?.statusBarManager?.statusBarFrame.height ?? CGFloat.zero
        * 'windows' was deprecated in iOS 15.0: Use UIWindowScene.windows on a relevant window scene instead
        */
        let statusBarHeight = UIApplication.shared.connectedScenes
            .filter({$0 is UIWindowScene})
            .compactMap({($0 as! UIWindowScene)})
            .first?.statusBarManager?.statusBarFrame.height ?? CGFloat.zero
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: statusBarHeight, right: 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let headerCell = AppFullscreenHeaderCell()
            headerCell.closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            return headerCell
        }
        
        let cell = AppFullscreenDescriptionCell()
        return cell
    }
    
    @objc fileprivate func handleDismiss(button: UIButton) {
        button.isHidden = true
        dismissHandler?()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 450
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
