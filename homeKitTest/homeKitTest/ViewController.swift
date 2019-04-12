//
//  ViewController.swift
//  homeKitTest
//
//  Created by Minewtech on 2019/3/29.
//  Copyright © 2019 Minewtech. All rights reserved.
//

import UIKit
import HomeKit

class ViewController: UIViewController,HMHomeManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var manager : HMHomeManager!
    
    var homes : Array<HMHome>!
    var rooms : Array<HMRoom>!
    var services : Array<HMService>!
    var characteristics : Array<HMCharacteristic>!
    
    var table : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homes = []

        manager = HMHomeManager.init()
        manager.delegate = self
        
        self.initViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Homes"
    }
    
    //MARK: - initViews
    func initViews() -> Void {
        
        table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.estimatedSectionFooterHeight = 0
        
        self.view.addSubview(table)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addHome))

    }
    
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return homes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellString = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
        cell.textLabel?.text = homes[indexPath.section].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let home = homes[indexPath.section]
        
        let vc = HomeDetailVC.init()
        vc.home = home
        vc.rooms = home.rooms
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    //MARK: - btn events
    //add Home
    @objc func addHome() -> Void {
        
        let alert = UIAlertController.init(title: "Add Home", message: "", preferredStyle: UIAlertController.Style.alert)
        
        var textF = UITextField.init()
        
        alert.addTextField { (textF1) in
            textF = textF1
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            print("cancel")
        }
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
            if textF.text?.lengthOfBytes(using: String.Encoding.utf8) == 0 {
                print("homeName string is nil")
                return
            }
            self.manager.addHome(withName: textF.text!) { (home, error) in
                
                if (error != nil) {
                    
                    print(error?.localizedDescription as Any)
                }
                else {
                    self.table.reloadData()
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - homeManager delegate
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        homes = manager.homes
        
        table.reloadData()
    }
    
    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        print("add home,homeName:\(home.name)")
    }
    //MARK: - callback function

}

