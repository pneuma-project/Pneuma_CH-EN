//
//  LungHistoryChatController.swift
//  Sprayer
//
//  Created by fanglin on 2020/3/12.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit
import Toast_Swift

class LungHistoryChatController: BaseViewController,CustemBBI {

    var dateStr = ""  //点击时间是哪一天
    var indexNum = 1  //当次肺功能测试有多少组
    var indexPath = 0 //点击了是当天的第几次肺功能测试
    
    let headView:HistoryExhaleHeadView = HistoryExhaleHeadView.init(frame: CGRect.init(x: 0, y: 0, width: CGFloat(180*IPONE_SCALE), height: CGFloat(40*IPONE_SCALE)))
    
    var scrollView:UIScrollView!
    
    var numResultLabel:UILabel!
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
    
    //数据
    var exhaleTime = ""
    var exhaleDataStr = ""
    var medicineId = ""
    
    var listArr:[ExhaleDataModel] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setNavTitle(NSLocalizedString("Pulmonary Function Test", comment: ""))
        self.setHeadView()
        self.setInterface()
        self.requestDataBlock()
        self.setBlock()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWith(UIImage.init(named: "icon-back"), andTarget: self, andinfoStr: "first")
        self.requestData()
    }
   
    func bbIdidClick(withName infoStr: String!) {
        self.navigationController?.popViewController(animated: true)
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
        let maxNum = ceil(lastData)
        for i in 0...(Int(maxNum)*10) {
            thirdXNumArr.append(String.init(format: "%.1f", Double(i)*0.1))
        }
        self.setInterface()
    }
}

//数据回调
extension LungHistoryChatController {
    func requestData() {
        let startStr = String.init(format: "%@ 00:00:00", dateStr)
        let endStr = String.init(format: "%@ 23:59:59", dateStr)
        DeviceRequestObject.shared.requestGetNowExhaleData(addDate: startStr, endDate: endStr)
    }
    
    func requestDataBlock() {
        DeviceRequestObject.shared.requestGetNowExhaleDataSuc = {[weak self](dataList) in
            if let weakself = self {
                weakself.listArr = dataList[weakself.indexPath].list
                if weakself.listArr.count > 0 {
                    let exhaleDataArr = weakself.listArr[0].exhaleData.components(separatedBy: ",")
                    weakself.XNumSetting(dataArr: exhaleDataArr)
                }
            }
        }
    }
    
    func setBlock() {
        headView.titleClickActionBlock = {[weak self](index) in
            if let weakself = self {
                if index == 1 {
                    if weakself.listArr.count >= 1 {
                        let exhaleDataArr = weakself.listArr[0].exhaleData.components(separatedBy: ",")
                        weakself.XNumSetting(dataArr: exhaleDataArr)
                    }
                }else if index == 2 {
                    if weakself.listArr.count >= 2 {
                        let exhaleDataArr = weakself.listArr[1].exhaleData.components(separatedBy: ",")
                        weakself.XNumSetting(dataArr: exhaleDataArr)
                    }
                }else if index == 3 {
                    if weakself.listArr.count >= 3 {
                        let exhaleDataArr = weakself.listArr[2].exhaleData.components(separatedBy: ",")
                        weakself.XNumSetting(dataArr: exhaleDataArr)
                    }
                }
            }
        }
    }
}

/// 初始化界面
extension LungHistoryChatController {
    fileprivate func setHeadView() {
        headView.number = indexNum
        self.view.addSubview(headView)
        headView.snp.makeConstraints { (make) in
            make.left.equalTo(30*IPONE_SCALE)
            make.top.equalTo(NEWNAVHEIGHT + CGFloat(20*IPONE_SCALE))
            make.width.equalTo(240*IPONE_SCALE)
            make.height.equalTo(35*IPONE_SCALE)
        }
    }
    
    fileprivate func setInterface() {
        for view in self.view.subviews {
            if !view.isKind(of: HistoryExhaleHeadView.classForCoder()) {
               view.removeFromSuperview()
               view.snp.removeConstraints()
            }
        }

        numResultLabel = UILabel.init()
        numResultLabel.textColor = UIColor.black
        numResultLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(numResultLabel)
        numResultLabel.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT+CGFloat(70*IPONE_SCALE))
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(200*IPONE_SCALE)))
        scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize.init(width: 2*SCREEN_WIDTH, height: CGFloat(200*IPONE_SCALE))
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(numResultLabel.snp.bottom)
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
        countOneLabel.text = "1、最大用力肺活量(FEV)：\(FEVStr) L"
        countOneLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        countOneLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(countOneLabel)
        countOneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thirdChatView.snp.bottom).offset(20*IPONE_SCALE)
            make.left.equalTo(40*IPONE_SCALE)
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
        countTwoLabel.text = "2、第一秒最大呼氣量(FEV1)：\(FEV1Str) L"
        countTwoLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        countTwoLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(countTwoLabel)
        countTwoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countOneLabel.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(40*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
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
        countThreeLabel.text = "3、尖峰呼氣流速(PEF)：\(maxPEF) L/Min"
        countThreeLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        countThreeLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(countThreeLabel)
        countThreeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countTwoLabel.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(40*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
    }
}
