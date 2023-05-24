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
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        tableView.tableFooterView = footerView
        
        tableView.backgroundColor = .white
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
            headerCell.clipsToBounds = true
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
            return TodayController.cellSize
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
