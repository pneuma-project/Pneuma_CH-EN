//
//  SLungTestTipController.swift
//  Sprayer
//
//  Created by fanglin on 2020/3/12.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class SLungTestTipController: BaseViewController,CustemBBI {
    
    lazy var tableView:UITableView = {
        let tbView = UITableView.init(frame: .zero, style: .plain)
        tbView.separatorStyle = .none
        tbView.backgroundColor = .white
        tbView.delegate = self
        tbView.dataSource = self
        return tbView
    }()
    
    var testNumLabel:UILabel = UILabel.init()
    var tipLabel:UILabel = UILabel.init()
    var startTestButton:UIButton = UIButton.init(type: .custom)
    
    var todayTestArr:[ExhaleNumberModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setNavTitle(NSLocalizedString("Pulmonary Function Test", comment: ""))
        self.setInterface()
        self.requestDataBlock()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWith(UIImage.init(named: "icon-back"), andTarget: self, andinfoStr: "first")
        self.requestData()
    }
    
    func bbIdidClick(withName infoStr: String!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestData() {
        guard let dateTime = DisplayUtils.getTimestampData("YYYY-MM-dd") else {
            return
        }
        let startStr = String.init(format: "%@ 00:00:00", dateTime)
        let endStr = String.init(format: "%@ 23:59:59", dateTime)
        DeviceRequestObject.shared.requestGetNowExhaleData(addDate: startStr, endDate: endStr)
    }
}

//数据回调
extension SLungTestTipController {
    func requestDataBlock() {
        DeviceRequestObject.shared.requestGetNowExhaleDataSuc = {[weak self](dataList) in
            if let weakself = self {
                weakself.todayTestArr = dataList
                weakself.testNumLabel.text = "您今天完成了\(dataList.count)次测试"
                weakself.tableView.reloadData()
            }
        }
    }
}

extension SLungTestTipController {
    func setInterface() {
        
        testNumLabel.font = UIFont.boldSystemFont(ofSize: 18)
        testNumLabel.text = "您今天完成了0次测试"
        self.view.addSubview(testNumLabel)
        testNumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT+CGFloat(10*IPONE_SCALE))
            make.height.equalTo(18*IPONE_SCALE)
            make.centerX.equalToSuperview()
        }
        
        tipLabel.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        tipLabel.text = "1、建议每天进行测试，每次测试完整三组.\n\n2、点击开始训练，跟着提示进行测试."
        tipLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        tipLabel.numberOfLines = 0
        self.view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(testNumLabel.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
            make.top.equalTo(tipLabel.snp.bottom).offset(20*IPONE_SCALE)
            make.bottom.equalTo(-20*IPONE_SCALE)
        }
        tableView.register(UINib.init(nibName: "SLungTestNumCell", bundle: nil), forCellReuseIdentifier: "SLungTestNumCell")
    }
}

extension SLungTestTipController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todayTestArr.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLungTestNumCell", for: indexPath) as! SLungTestNumCell
        cell.testNumLabel.text = "开始第\(indexPath.row + 1)次测试"
        if todayTestArr.count == 0 {
            cell.bgView.backgroundColor = HEXCOLOR(h: 0x29D18D, alpha: 1)
            cell.testNumLabel.textColor = HEXCOLOR(h: 0x113576, alpha: 1)
            cell.dataNum = 0
        }else {
            if indexPath.row == todayTestArr.count {
                cell.dataNum = 0
                let model = todayTestArr[todayTestArr.count-1]
                if model.isNext {
                    cell.bgView.backgroundColor = HEXCOLOR(h: 0x29D18D, alpha: 1)
                    cell.testNumLabel.textColor = HEXCOLOR(h: 0x113576, alpha: 1)
                }else {
                    cell.bgView.backgroundColor = HEXCOLOR(h: 0x999999, alpha: 1)
                    cell.testNumLabel.textColor = HEXCOLOR(h: 0xffffff, alpha: 1)
                }
            }else {
                let model = todayTestArr[indexPath.row]
                cell.dataNum = model.list.count
                if indexPath.row == todayTestArr.count-1 {
                    if model.isNext {
                        cell.bgView.backgroundColor = HEXCOLOR(h: 0x999999, alpha: 1)
                        cell.testNumLabel.textColor = HEXCOLOR(h: 0xffffff, alpha: 1)
                    }else {
                        cell.bgView.backgroundColor = HEXCOLOR(h: 0x29D18D, alpha: 1)
                        cell.testNumLabel.textColor = HEXCOLOR(h: 0x113576, alpha: 1)
                    }
                }else {
                    cell.bgView.backgroundColor = HEXCOLOR(h: 0x999999, alpha: 1)
                    cell.testNumLabel.textColor = HEXCOLOR(h: 0xffffff, alpha: 1)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(55*IPONE_SCALE)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if todayTestArr.count == 0 {
            let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Are you ready", comment: ""), message: "准备好测试了吗？", okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Wait a minute", comment: "")) {
                let slungTestDateVC = SLungTestDateController()
                slungTestDateVC.testNum = 0
                self.navigationController?.pushViewController(slungTestDateVC, animated: true)
            }
            self.present(alertVC, animated: true, completion: nil)
        }else {
            if indexPath.row == todayTestArr.count {
                let model = todayTestArr[todayTestArr.count-1]
                if model.isNext {
                   let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Are you ready", comment: ""), message: "准备好测试了吗？", okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Wait a minute", comment: "")) {
                       let slungTestDateVC = SLungTestDateController()
                       slungTestDateVC.testNum = 0
                       self.navigationController?.pushViewController(slungTestDateVC, animated: true)
                   }
                   self.present(alertVC, animated: true, completion: nil)
                }
            }else {
                let model = todayTestArr[indexPath.row]
                if indexPath.row == todayTestArr.count-1 {
                    if !model.isNext {
                        let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Are you ready", comment: ""), message: "准备好测试了吗？", okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Wait a minute", comment: "")) {
                            let slungTestDateVC = SLungTestDateController()
                            slungTestDateVC.testNum = model.list.count
                            self.navigationController?.pushViewController(slungTestDateVC, animated: true)
                        }
                        self.present(alertVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
