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
        DeviceRequestObject.shared.requestGetNowExhaleData(ssId: 0, addDate: startStr, endDate: endStr)
    }
}

//数据回调
extension SLungTestTipController {
    func requestDataBlock() {
        DeviceRequestObject.shared.requestGetNowExhaleDataSuc = {[weak self](dataList) in
            if let weakself = self {
                weakself.todayTestArr = dataList
                weakself.testNumLabel.text = String.init(format: NSLocalizedString("today_time", comment: ""), dataList.count)
                weakself.tableView.reloadData()
            }
        }
    }
}

extension SLungTestTipController {
    func setInterface() {
        
        testNumLabel.font = UIFont.boldSystemFont(ofSize: 18)
        testNumLabel.textColor = RGBCOLOR(r: 8, g: 153, b: 239, alpha: 1)
        self.view.addSubview(testNumLabel)
        testNumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT+CGFloat(10*IPONE_SCALE))
            make.height.equalTo(18*IPONE_SCALE)
            make.centerX.equalToSuperview()
        }
        
        tipLabel.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        tipLabel.text = NSLocalizedString("test_guide", comment: "")
        let attrStr = NSMutableAttributedString(string: tipLabel.text!)
        //设置行间距
        let style:NSMutableParagraphStyle  = NSMutableParagraphStyle()
        style.lineSpacing = 5              //行间距（垂直上的间距）
        attrStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSRange(location: 0, length: (tipLabel.text?.count)!))
        tipLabel.attributedText = attrStr
        tipLabel.textColor = RGBCOLOR(r: 8, g: 153, b: 239, alpha: 1)
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
            make.top.equalTo(tipLabel.snp.bottom).offset(10*IPONE_SCALE)
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
        cell.testNumLabel.text = String.init(format: NSLocalizedString("testing_time", comment: ""), indexPath.row + 1)
        if todayTestArr.count == 0 { //当天测试次数为0
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
                    cell.bgView.backgroundColor = HEXCOLOR(h: 0xBABABA, alpha: 1)
                    cell.testNumLabel.textColor = HEXCOLOR(h: 0xffffff, alpha: 1)
                }
            }else {
                let model = todayTestArr[indexPath.row]
                cell.dataNum = model.list.count
                if indexPath.row == todayTestArr.count-1 {
                    if model.isNext {
                        cell.bgView.backgroundColor = HEXCOLOR(h: 0xBABABA, alpha: 1)
                        cell.testNumLabel.textColor = HEXCOLOR(h: 0xffffff, alpha: 1)
                    }else {
                        cell.bgView.backgroundColor = HEXCOLOR(h: 0x29D18D, alpha: 1)
                        cell.testNumLabel.textColor = HEXCOLOR(h: 0x113576, alpha: 1)
                    }
                }else {
                    cell.bgView.backgroundColor = HEXCOLOR(h: 0xBABABA, alpha: 1)
                    cell.testNumLabel.textColor = HEXCOLOR(h: 0xffffff, alpha: 1)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60*IPONE_SCALE)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if todayTestArr.count == 0 {
            let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Are you ready", comment: ""), message: String.init(format: NSLocalizedString("test_ready", comment: ""), indexPath.row + 1), okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Wait a minute", comment: "")) {
                let slungTestDateVC = SLungTestDateController()
                slungTestDateVC.testGroupNum = 0
                slungTestDateVC.testNum = indexPath.row
                self.navigationController?.pushViewController(slungTestDateVC, animated: true)
            }
            self.present(alertVC, animated: true, completion: nil)
        }else {
            if indexPath.row == todayTestArr.count {
                let model = todayTestArr[todayTestArr.count-1]
                if model.isNext {
                   let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Are you ready", comment: ""), message: String.init(format: NSLocalizedString("test_ready", comment: ""), indexPath.row + 1), okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Wait a minute", comment: "")) {
                       let slungTestDateVC = SLungTestDateController()
                       slungTestDateVC.testGroupNum = 0
                       slungTestDateVC.testNum = indexPath.row
                       self.navigationController?.pushViewController(slungTestDateVC, animated: true)
                   }
                   self.present(alertVC, animated: true, completion: nil)
                }
            }else {
                let model = todayTestArr[indexPath.row]
                if indexPath.row == todayTestArr.count-1 {
                    if !model.isNext {
                        let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Are you ready", comment: ""), message: String.init(format: NSLocalizedString("test_ready", comment: ""), indexPath.row + 1), okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Wait a minute", comment: "")) {
                            let slungTestDateVC = SLungTestDateController()
                            slungTestDateVC.testGroupNum = model.list.count
                            slungTestDateVC.testNum = indexPath.row
                            self.navigationController?.pushViewController(slungTestDateVC, animated: true)
                        }
                        self.present(alertVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
