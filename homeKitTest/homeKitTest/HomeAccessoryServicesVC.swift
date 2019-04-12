//
//  HomeAccessoryDetailVC.swift
//  homeKitTest
//
//  Created by Minewtech on 2019/4/11.
//  Copyright © 2019 Minewtech. All rights reserved.
//

import UIKit
import HomeKit

class HomeAccessoryServicesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var services : Array<HMService>!
    var accessory : HMAccessory!
    var home : HMHome!
    var table : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Accessory's services"
        
        self.initViews()
        print(home.serviceGroups)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - initViews
    func initViews() -> Void {
        
        table = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        
        self.view.addSubview(table)
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addRoom))
        
    }
    
    //MARK: - tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == table {
            return services.count
//        }
//        return services.rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell.init()
        if tableView == table {
            let cellString = "cell"
            cell = table.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
            cell.textLabel?.text = services[indexPath.row].name
        }
//        else {
//            let cellString = "searchcell"
//            cell = roomsTable.dequeueReusableCell(withIdentifier: cellString) ?? UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellString)
//            cell.textLabel?.text = home.rooms[indexPath.row].name
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == table {
            let vc = HomeAccessoryCharacteriticsVC.init()
            vc.characteritics = services[indexPath.row].characteristics
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        else if tableView == roomsTable {
//            let alert = UIAlertController.init(title: "Add Room", message: "Are you sure add \(home.rooms[indexPath.row].name)", preferredStyle: UIAlertController.Style.alert)
//
//            let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
//                print("cancel")
//            }
//            let defaultAction = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default) { (action) in
//
//                self.zone.addRoom(self.home.rooms[indexPath.row], completionHandler: { (error) in
//                    if (error != nil) {
//                        print(error?.localizedDescription as Any)
//                    }
//                    else {
//                        self.rooms.append(self.home.rooms[indexPath.row])
//                        self.table.reloadData()
//                        self.roomsView.isHidden = true
//                    }
//                })
//            }
//            alert.addAction(cancelAction)
//            alert.addAction(defaultAction)
//            self.present(alert, animated: true, completion: nil)
//        }
//        else {
//
//        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    //MARK: - btn events
    //add Room
//    @objc func addRoom() -> Void {
//
//        if (roomsView != nil) {
//            roomsView.isHidden = false
//            roomsTable.reloadData()
//        }
//        else {
//            roomsView = UIView.init()
//            roomsView.frame = CGRect.init(x: self.view.frame.width/2-100, y: self.view.frame.height/2-200, width: 200, height: 400)
//            roomsView.layer.borderWidth = 2
//            roomsView.layer.borderColor = UIColor.blue.cgColor
//            self.view.addSubview(roomsView)
//
//
//            roomsTable = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 350), style: UITableView.Style.plain)
//
//            roomsTable.delegate = self
//            roomsTable.dataSource = self
//            roomsTable.separatorStyle = .none
//
//            roomsView.addSubview(roomsTable)
//            roomsTable.reloadData()
//
//            cancelBtn = UIButton.init(type: UIButton.ButtonType.custom)
//            cancelBtn.frame = CGRect.init(x: 0, y: 350, width: 200, height: 50)
//            cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: UIControl.Event.touchUpInside)
//            cancelBtn.setTitle("Cancel", for: UIControl.State.normal)
//            cancelBtn.setTitleColor(UIColor.black, for: UIControl.State.normal)
//            roomsView.addSubview(cancelBtn)
//
//        }
//    }
//
//    @objc func cancelBtnClick() -> Void {
//        roomsView.isHidden = true
//    }
    //MARK: - callback function
    func addServiceGroup() -> Void {
        home.addServiceGroup(withName: "ssss", completionHandler: { (servicesGroup, error) in
            if (error != nil) {
                print("addServiceGroup failed,error:\(String(describing: error))")
                
            }
            else {
                print("addServiceGroup success,servicesGroup:\(String(describing: servicesGroup))")
            }
        })
    }
    func removeServiceGroup() -> Void {
        self.home.removeServiceGroup(self.home.serviceGroups.first!, completionHandler: { (error) in
            if (error != nil) {
                print("removeServiceGroup failed,error:\(String(describing: error))")
            }
            else {
                print("removeServiceGroup success")
            }
        })
    }
    
    func changeServiceName(service : HMService, name : String) -> Void {
        service.updateName(name) { (error) in
            if (error != nil) {
                print("changeServiceName failed,error:\(String(describing: error))")
            }
            else {
                print("changeServiceName success,name:\(name)")
            }
        }
    }
    
    func addActionSet() -> Void {
        home.addActionSet(withName: "action1") { (actionSet, error) in
            if (error != nil) {
                print("addActionSet failed,error:\(String(describing: error))")
            }
            else {
                print("addActionSet success,actionSet:\(String(describing: actionSet))")
            }
        }
    }
    
    func addActionToActionSet(actionSet : HMActionSet) -> Void {
        
        let action = HMAction.init()
        
        actionSet.addAction(action) { (error) in
            if (error != nil) {
                print("addAction failed,error:\(String(describing: error))")
            }
            else {
                print("addAction success,action:\(action)")
            }
        }
    }
    
    
    deinit {
        print("\(self.classForCoder) dealloc")
    }

}
