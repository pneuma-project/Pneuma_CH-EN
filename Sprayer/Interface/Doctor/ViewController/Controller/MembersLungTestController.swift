//
//  MembersLungTestController.swift
//  Sprayer
//
//  Created by fanglin on 2020/3/12.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit
import Toast_Swift

class MembersLungTestController: BaseViewController,CustemBBI {
    
    var patientId:Int32 = 0
    
    var scrollView:UIScrollView!
    
    var timeResultLabel:UILabel!
    var firstChatView:FLChartView!
    var secondChatView:FLChartView!
    var thirdChatView:FLCustomChartView!
    
    var countOneLabel:UILabel!
    var countTwoLabel:UILabel = UILabel.init()
    var countThreeLabel:UILabel = UILabel.init()
    
    //数据数组
    var dataList:[String] = []
    var xNumArr:[String] = []
    var thirdXNumArr:[String] = []
    var secondDataArr:[String] = []
    
    var timer:Timer?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setNavTitle(NSLocalizedString("patient_Lung_test", comment: ""))
        self.setHeadView()
        self.setInterface()
        self.requestDataBlock()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWith(UIImage.init(named: "icon-back"), andTarget: self, andinfoStr: "first")
        self.navigationItem.rightBarButtonItem = CustemNavItem.initWith(UIImage.init(named: "multiTalkTipsBannerIcon"), andTarget: self, andinfoStr: "call")
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.requestData), userInfo: nil, repeats: true)
        self.timer?.fireDate = Date.distantPast
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.fireDate = Date.distantFuture
    }
   
    func bbIdidClick(withName infoStr: String!) {
        if infoStr == "first" {
            self.navigationController?.popViewController(animated: true)
        }else if infoStr == "call" {
            if !SMainBoardObject.shared().isVideoChatExist {
                guard let tabbarCtrl = UIApplication.shared.keyWindow?.rootViewController as? SMainTabBarController else {
                    return
                }
                let vc = NTESVideoChatViewController.init(callee: "pn"+"\(self.patientId)")
                tabbarCtrl.resetSubViewController(vc: vc!)
                SVideoChatBoardObject.enterVideoChat()
            }
        }
    }
    
    func XNumSetting(dataArr:[String]) {
        dataList = []
        xNumArr = []
        thirdXNumArr = []
        secondDataArr = []
    
        //计算x轴的数值
        if dataArr.count%10 == 0{
            for i in 0...dataArr.count {
                xNumArr.append(String.init(format: "%.1f", Double(i)*0.05))
            }
        }else {
            let baseNum = (dataArr.count/10)+1
            for i in 0...(baseNum*10) {
                xNumArr.append(String.init(format: "%.1f", Double(i)*0.05))
            }
        }
        dataList = dataArr
        
        //计算thirdChatView 的数据
        var secondSum = 0.0
        for i in 0..<dataArr.count {
            guard let dataNum = Double(dataArr[i]) else {
                return
            }
            secondSum += dataNum
            secondDataArr.append(String.init(format: "%.3f", secondSum/1200))
        }
        //计算thirdChatView 的y轴坐标数值
        guard let lastDataStr = secondDataArr.last else {
            return
        }
        guard let lastData = Double(lastDataStr) else {
            return
        }
        let maxNum = ceil(lastData) + 2
        for i in 0...(Int(maxNum)*10) {
            thirdXNumArr.append(String.init(format: "%.1f", Double(i)*0.1))
        }
        self.setInterface()
    }
}

//数据回调
extension MembersLungTestController {
    @objc func requestData() {
        DoctorRequestObject.shared.requestGetTmpExhaleData(patientSsId: patientId)
    }
    
    func requestDataBlock() {
        DoctorRequestObject.shared.requestGetTmpExhaleDataSuc = {[weak self](model) in
            if let weakself = self {
                if model.exhaleData == weakself.dataList.joined(separator: ",") {
                    return
                }
                if model.exhaleData == "" {
                    weakself.dataList = []
                    weakself.xNumArr = []
                    weakself.thirdXNumArr = []
                    weakself.secondDataArr = []
                    weakself.setInterface()
                    weakself.timeResultLabel.text = ""
                }else {
                    let exhaleDataArr = model.exhaleData.components(separatedBy: ",")
                    weakself.XNumSetting(dataArr: exhaleDataArr)
                    weakself.settingTime(date: model.addDate)
                }
            }
        }
    }
    
    func settingTime(date:Int64) {
        let timeStr = DisplayUtils.getTimeStamp(to: "YYYY-MM-dd HH:mm:ss", andTime: String.init(format: "%lld", date/1000))
        guard let time = timeStr else {
            return
        }
        timeResultLabel.text = time
    }
}

/// 初始化界面
extension MembersLungTestController {
    fileprivate func setHeadView() {
        timeResultLabel = UILabel.init()
        timeResultLabel.textColor = UIColor.black
        timeResultLabel.font = UIFont.systemFont(ofSize: CGFloat(16*IPONE_SCALE))
        self.view.addSubview(timeResultLabel)
        timeResultLabel.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT+CGFloat(20*IPONE_SCALE))
            make.left.equalTo(20*IPONE_SCALE)
            make.height.equalTo(16*IPONE_SCALE)
        }
    }
    
    fileprivate func setInterface() {
        for view in self.view.subviews {
            if !view.isKind(of: timeResultLabel.classForCoder) {
               view.removeFromSuperview()
               view.snp.removeConstraints()
            }
        }
        
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(200*IPONE_SCALE)))
        scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize.init(width: 2*SCREEN_WIDTH, height: CGFloat(200*IPONE_SCALE))
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT+CGFloat(56*IPONE_SCALE))
            make.height.equalTo(200*IPONE_SCALE)
        }
        
        var yNumArr:[String] = []
        for i in (0...7).reversed() {
            yNumArr.append(String.init(format: "%d", i*100))
        }
        firstChatView = FLChartView.init(frame: CGRect.init(x: CGFloat(10*IPONE_SCALE), y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(200*IPONE_SCALE)))
        firstChatView.backgroundColor = .clear
        firstChatView.titleOfXStr = "Sec"
        firstChatView.titleOfYStr = "SLM(L/min)"
        firstChatView.leftDataArr = dataList
        firstChatView.dataArrOfY = yNumArr
        if xNumArr.count == 0 {
            firstChatView.dataArrOfX = ["0","0.05","0.1","0.15","0.2","0.25","0.3","0.35","0.4","0.45","0.5","0.55","0.6","0.65","0.7","0.75","0.8","0.85","0.9","0.95","1.0","1.05","1.1","1.15","1.2","1.25","1.3","1.35","1.4","1.45","1.5","1.55","1.6","1.65","1.7","1.75","1.8","1.85","1.9","1.95","2.0","2.05","2.1","2.15","2.2","2.25","2.3","2.35","2.4","2.45","2.5","2.55","2.6","2.65","2.7","2.75","2.8","2.85","2.9","2.95","3.0"]//拿到X轴坐标
        }else {
            firstChatView.dataArrOfX = xNumArr
        }
        scrollView.addSubview(firstChatView)
        
        var secondYNumArr:[String] = []
        for i in (0...6).reversed() {
            secondYNumArr.append(String.init(format: "%d", i*2))
        }
        secondChatView = FLChartView.init(frame: CGRect.init(x: SCREEN_WIDTH+CGFloat(10*IPONE_SCALE), y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(200*IPONE_SCALE)))
        secondChatView.backgroundColor = .clear
        secondChatView.titleOfXStr = "Sec"
        secondChatView.titleOfYStr = "L"
        secondChatView.leftDataArr = secondDataArr
        secondChatView.dataArrOfY = secondYNumArr
        if xNumArr.count == 0 {
            secondChatView.dataArrOfX = ["0","0.05","0.1","0.15","0.2","0.25","0.3","0.35","0.4","0.45","0.5","0.55","0.6","0.65","0.7","0.75","0.8","0.85","0.9","0.95","1.0","1.05","1.1","1.15","1.2","1.25","1.3","1.35","1.4","1.45","1.5","1.55","1.6","1.65","1.7","1.75","1.8","1.85","1.9","1.95","2.0","2.05","2.1","2.15","2.2","2.25","2.3","2.35","2.4","2.45","2.5","2.55","2.6","2.65","2.7","2.75","2.8","2.85","2.9","2.95","3.0"]//拿到X轴坐标
        }else {
            secondChatView.dataArrOfX = xNumArr
        }
        scrollView.addSubview(secondChatView)
        
        thirdChatView = FLCustomChartView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(200*IPONE_SCALE)))
        thirdChatView.backgroundColor = .clear
        thirdChatView.titleOfXStr = "L"
        thirdChatView.titleOfYStr = "SLM(L/min)"
        thirdChatView.yDataArr = dataList
        thirdChatView.xDataArr = secondDataArr
        thirdChatView.dataArrOfY = yNumArr
        if thirdXNumArr.count == 0 {
            thirdChatView.dataArrOfX = ["0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0","1.1","1.2","1.3","1.4","1.5","1.6","1.7","1.8","1.9","2.0","2.1","2.2","2.3","2.4","2.5","2.6","2.7","2.8","2.9","3.0","3.1","3.2","3.3","3.4","3.5","3.6","3.7","3.8","3.9","4.0","4.1","4.2","4.3","4.4","4.5","4.6","4.7","4.8","4.9","5.0"]//拿到X轴坐标
        }else {
            thirdChatView.dataArrOfX = thirdXNumArr
        }
        self.view.addSubview(thirdChatView)
        thirdChatView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.equalTo(10*IPONE_SCALE)
            make.right.equalTo(-10*IPONE_SCALE)
            make.height.equalTo(200*IPONE_SCALE)
        }
        
        var FEVStr = 0.0
        if secondDataArr.count>0 {
            guard let maxNum = Double(secondDataArr[secondDataArr.count-1]) else {
                return
            }
            FEVStr = maxNum
        }else {
            FEVStr = 0.0
        }
        countOneLabel = UILabel.init()
        countOneLabel.text = String.init(format: NSLocalizedString("fev", comment: ""), FEVStr)
        countOneLabel.textColor = RGBCOLOR(r: 16, g: 101, b: 182, alpha: 1)
        countOneLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(countOneLabel)
        countOneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thirdChatView.snp.bottom).offset(20*IPONE_SCALE)
            make.left.equalTo(20*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        
        var FEV1Str = 0.0
        if secondDataArr.count > 0{
            if secondDataArr.count > 20 {
                guard let maxNum = Double(secondDataArr[19]) else {
                    return
                }
                FEV1Str = maxNum
            }else {
                guard let maxNum = Double(secondDataArr[secondDataArr.count-1]) else {
                    return
                }
                FEV1Str = maxNum
            }
        }
        countTwoLabel = UILabel.init()
        countTwoLabel.text = String.init(format: NSLocalizedString("fev1", comment: ""), FEV1Str)
        countTwoLabel.textColor = RGBCOLOR(r: 16, g: 101, b: 182, alpha: 1)
        countTwoLabel.font = UIFont.systemFont(ofSize: 14)
        countTwoLabel.numberOfLines = 0
        self.view.addSubview(countTwoLabel)
        countTwoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countOneLabel.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
//            make.height.equalTo(15*IPONE_SCALE)
        }
        
        var maxPEF = 0.0
        if dataList.count > 0 {
            guard var maxPEFNum = Double(dataList[0]) else {
                return
            }
            for value in dataList {
                guard let doubleValue = Double(value) else {
                    return
                }
                if maxPEFNum < doubleValue {
                    maxPEFNum = doubleValue
                }
            }
            maxPEF = maxPEFNum
        }else {
            maxPEF = 0.0
        }
        countThreeLabel = UILabel.init()
        countThreeLabel.text = String.init(format: NSLocalizedString("pef", comment: ""), maxPEF)
        countThreeLabel.textColor = RGBCOLOR(r: 16, g: 101, b: 182, alpha: 1)
        countThreeLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(countThreeLabel)
        countThreeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countTwoLabel.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(20*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
    }
}
