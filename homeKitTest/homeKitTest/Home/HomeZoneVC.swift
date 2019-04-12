//
//  HomeZoneVC.swift
//  homeKitTest
//
//  Created by Minewtech on 2019/4/10.
//  Copyright © 2019 Minewtech. All rights reserved.
//

import UIKit
import HomeKit

class HomeZoneVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var table :UITableView!
    var home : HMHome!
    var zones : Array<HMZone>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Zones"
        
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addZone))
        
    }
    
    //MARK: - tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellString = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
        cell.textLabel?.text = zones[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let zone = zones[indexPath.row]
        
        let vc = ZoneRoomVC.init()
        vc.zone = zone
        vc.home = home
        vc.rooms = zone.rooms
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        home.removeZone(zones[indexPath.row]) { (error) in
            if (error != nil) {
                print(error?.localizedDescription as Any)
            }
            else {
                self.zones.remove(at: indexPath.row)
                self.table.reloadData()
            }
        }
    }
    //MARK: - btn events
    //add Room
    @objc func addZone() -> Void {
        
        let alert = UIAlertController.init(title: "Add Zone", message: "", preferredStyle: UIAlertController.Style.alert)
        
        var textF = UITextField.init()
        
        alert.addTextField { (textF1) in
            textF = textF1
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            print("cancel")
        }
        let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
            if textF.text?.lengthOfBytes(using: String.Encoding.utf8) == 0 {
                print("zoneName string is nil")
                return
            }
            self.home.addZone(withName: textF.text!, completionHandler: { (zone, error) in
                if (error != nil) {
                    print("add zone is failed,error:\(String(describing: error))")
                }
                else {
                    self.zones.append(zone!)
                    self.table.reloadData()
                    print("add zone is success,zoneName:\(String(describing: zone?.name))")
                }
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - callback function
    
    deinit {
        print("\(self.classForCoder) dealloc")
    }


}
