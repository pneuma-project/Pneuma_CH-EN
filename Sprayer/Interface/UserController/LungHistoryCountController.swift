//
//  LungHistoryCountController.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/3.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class LungHistoryCountController: BaseViewController,CustemBBI {
    
    lazy var tableView:UITableView = {
        let tbView = UITableView.init(frame: .zero, style: .plain)
        tbView.separatorStyle = .none
        tbView.backgroundColor = .white
        tbView.delegate = self
        tbView.dataSource = self
        return tbView
    }()
    
    var dataArr:[ExhaleDataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setNavTitle(NSLocalizedString("Pulmonary Function Test History", comment: ""))
        self.setInterface()
        self.requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWith(UIImage.init(named: "icon-back"), andTarget: self, andinfoStr: "first")
    }
    
    func bbIdidClick(withName infoStr: String!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setInterface() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tableView.register(UINib.init(nibName: "SLungTestNumCell", bundle: nil), forCellReuseIdentifier: "SLungTestNumCell")
    }
    
    func requestData() {
        DeviceRequestObject.shared.requestGetHistoryExhaleData()
        DeviceRequestObject.shared.requestGetHistoryExhaleDataSuc = {[weak self](dataList) in
            if let weakself = self {
                weakself.dataArr = dataList
                weakself.tableView.reloadData()
            }
        }
    }
}

extension LungHistoryCountController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(50*IPONE_SCALE)))
        headBgView.backgroundColor = HEXCOLOR(h: 0xEDEDED, alpha: 1)
        
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: CGFloat(10*IPONE_SCALE), width: SCREEN_WIDTH, height: CGFloat(40*IPONE_SCALE)))
        bgView.backgroundColor = .white
        headBgView.addSubview(bgView)
        
        let timeLabel = UILabel.init(frame: CGRect.init(x: CGFloat(15*IPONE_SCALE), y: 0, width: SCREEN_WIDTH-CGFloat(30*IPONE_SCALE), height: CGFloat(40*IPONE_SCALE)))
        timeLabel.backgroundColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: CGFloat(17*IPONE_SCALE))
        timeLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        bgView.addSubview(timeLabel)
        timeLabel.text = dataArr[section].exhaleAddDate
        return headBgView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(dataArr[section].exhaleNum)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SLungTestNumCell", for: indexPath) as! SLungTestNumCell
        let model = dataArr[indexPath.section]
        cell.dataNum = Int(model.list[indexPath.row])
        cell.testNumLabel.text = "第\(indexPath.row + 1)次测试"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(50*IPONE_SCALE)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(55*IPONE_SCALE)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = LungHistoryChatController()
        let model = dataArr[indexPath.section]
        vc.dateStr = model.exhaleAddDate
        vc.indexNum = Int(model.list[indexPath.row])
        vc.indexPath = indexPath.row
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
