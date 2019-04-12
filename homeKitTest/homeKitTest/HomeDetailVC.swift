//
//  HomeDetailVC.swift
//  homeKitTest
//
//  Created by Minewtech on 2019/4/2.
//  Copyright © 2019 Minewtech. All rights reserved.
//

import UIKit
import HomeKit

class HomeDetailVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    var table : UITableView!
    var home : HMHome!
    var rooms : Array<HMRoom>!
    var dataAry : Array<String>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home Detail"
        dataAry = ["rooms","zones","accessories"]
        self.initViews()
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - initViews
    func initViews() -> Void {
        
        table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none

        self.view.addSubview(table)
    }
    
    //MARK: - tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellString = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
        cell.textLabel?.text = dataAry[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let vc = HomeRoomsVC.init()
            vc.home = home
            vc.rooms = rooms
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if indexPath.row == 1 {
            let vc = HomeZoneVC.init()
            vc.home = home
            vc.zones = home.zones
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = HomeAccessoryVC.init()
            vc.home = home
            vc.accessories = home.accessories
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    //MARK: - btn events

    //MARK: - callback function
    
    deinit {
        print("\(self.classForCoder) dealloc")
    }
    
    
}
