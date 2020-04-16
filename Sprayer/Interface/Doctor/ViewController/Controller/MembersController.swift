//
//  MembersController.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/14.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class MembersController: BaseViewController {

    var dataArr:[UserInfoModel] = []
    
    lazy var tableView:UITableView = {
        let tbView = UITableView.init(frame: .zero, style: .plain)
        tbView.separatorStyle = .none
        tbView.backgroundColor = .white
        tbView.delegate = self
        tbView.dataSource = self
        return tbView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setNavTitle("患者列表")
        self.setInterface()
        self.requestData()
        self.setBlock()
    }
    
    func setInterface() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT)
        }
        tableView.register(UINib.init(nibName: "MembersListCell", bundle: nil), forCellReuseIdentifier: "MembersListCell")
    }
}

//数据相关
extension MembersController {
    func requestData() {
        if let roleId = UserInfoData.mr_findFirst()?.roleId {
            DoctorRequestObject.shared.requestGetPatientsInfoList(doctorId: roleId)
        }
    }
    
    func setBlock() {
        DoctorRequestObject.shared.requestGetPatientsInfoListSuc = {[weak self](dataList) in
            if let weakself = self {
                weakself.dataArr = dataList
                weakself.tableView.reloadData()
            }
        }
    }
}

extension MembersController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MembersListCell", for: indexPath) as! MembersListCell
        let model = dataArr[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60*IPONE_SCALE)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MembersLungTestController()
        let model = dataArr[indexPath.row]
        vc.patientId = model.ssId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
