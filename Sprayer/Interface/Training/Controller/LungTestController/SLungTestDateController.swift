//
//  SLungTestDateController.swift
//  Sprayer
//
//  Created by fanglin on 2020/3/12.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit
import Toast_Swift

class SLungTestDateController: BaseViewController,CustemBBI {

    var scrollView:UIScrollView!
    
    var numResultLabel:UILabel!
    var firstChatView:FLChartView!
    var secondChatView:FLChartView!
    var thirdChatView:FLCustomChartView!
    
    var countOneLabel:UILabel!
    var countTwoLabel:UILabel = UILabel.init()
    var countThreeLabel:UILabel = UILabel.init()
    
    var startTestBtn:UIButton!
    
    //数据数组
    var dataList:[String] = []
    var xNumArr:[String] = []
    var thirdXNumArr:[String] = []
    var secondDataArr:[String] = []
    
    //数据
    var exhaleTime = ""
    var exhaleDataStr = ""
    var medicineId = ""
    
    //当次测试的组数
    var testGroupNum:Int = 0
    //当前是测试第几次
    var testNum:Int = 0
    
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setNavTitle(String.init(format: NSLocalizedString("test_time_group", comment: ""), testNum+1,testGroupNum+1))
        self.setScrollView()
        self.setInterface()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.writeStartDataAction), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWith(UIImage.init(named: "icon-back"), andTarget: self, andinfoStr: "first")
        self.navigationItem.rightBarButtonItem = CustemNavItem.initWith(UIImage.init(named: "multiTalkTipsBannerIcon"), andTarget: self, andinfoStr: "call")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshExhaleData), name: NSNotification.Name(rawValue: "refreshExhaleData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectAction), name: NSNotification.Name(rawValue: PeripheralDidConnect), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(connectSucceedAction), name: NSNotification.Name(rawValue: BlueConnectSucceed), object: nil)
    }
    
    @objc func disconnectAction() {
        if timer != nil {
            timer?.fireDate = Date.distantFuture
        }
    }
    
    @objc func connectSucceedAction() {
        if timer != nil {
            timer?.fireDate = Date.distantPast
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshExhaleData"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: PeripheralDidConnect), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: BlueConnectSucceed), object: nil)
    }
    
    func bbIdidClick(withName infoStr: String!) {
        if infoStr == "first" {
            if dataList.count == 0 {
                if timer != nil {
                    timer!.invalidate()
                    timer = nil
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopLungTrain"), object: nil, userInfo: nil)
                self.writeStopDataAction()
                self.navigationController?.popViewController(animated: true)
            }else {
                let alertVC = UIAlertController.alertAlert(title: "", message: NSLocalizedString("Do you want to save test results", comment: ""), okTitle: NSLocalizedString("Save", comment: ""), okComplete: {
                    //加载动画
                    self.view.makeToastActivity(.center)
                    guard let exhaleDataSum = Double(self.secondDataArr[self.secondDataArr.count-1]) else {
                        return
                    }
                    DeviceRequestObject.shared.requestSaveExhaleData(medicineId: self.medicineId, exhaleData: self.exhaleDataStr, exhaleDataSum: exhaleDataSum, addDate: self.exhaleTime) { [weak self](code) in
                        if let weakself = self {
                            //隐藏加载动画
                            weakself.view.hideToastActivity()
                            if code == "200" {
                                if weakself.timer != nil {
                                    weakself.timer!.invalidate()
                                    weakself.timer = nil
                                }
                                LCProgressHUD.showSuccessText(NSLocalizedString("Upload success", comment: ""))
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopLungTrain"), object: nil, userInfo: nil)
                                weakself.writeStopDataAction()
                                weakself.navigationController?.popViewController(animated: true)
                            }else {
                                LCProgressHUD.showSuccessText(NSLocalizedString("Upload failed", comment: ""))
                            }
                        }
                    }
                }, cancelTitle: NSLocalizedString("Return", comment: "")) {
                    if self.timer != nil {
                        self.timer!.invalidate()
                        self.timer = nil
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopLungTrain"), object: nil, userInfo: nil)
                    self.writeStopDataAction()
                    self.navigationController?.popViewController(animated: true)
                }
                self.present(alertVC, animated: true, completion: nil)
            }
        }else if infoStr == "call" {
            if !SMainBoardObject.shared().isVideoChatExist {
                guard let tabbarCtrl = UIApplication.shared.keyWindow?.rootViewController as? SMainTabBarController else {
                    return
                }
                let vc = NTESVideoChatViewController.init(callee: "pn"+"\(DoctorBoardObject.shared().doctorSsId)")
                tabbarCtrl.resetSubViewController(vc: vc!)
                SVideoChatBoardObject.enterVideoChat()
            }
        }
    }
    
    @objc func refreshExhaleData(obj: Notification) {
        let objDict:[String:Any] = obj.object as! [String : Any]
        exhaleDataStr = objDict["exhaleData"] as! String
        medicineId = objDict["medicineId"] as! String
        exhaleTime = objDict["exhaleTime"] as! String
        let exhaleDataArr = exhaleDataStr.components(separatedBy: ",")
        self.XNumSetting(dataArr: exhaleDataArr)
    }
    
    func XNumSetting(dataArr:[String]) {
        dataList = []
        xNumArr = []
        thirdXNumArr = []
        secondDataArr = []
        
        //计算x轴的数值
        let baseNum = (dataArr.count/OneSecondData)+2
        for i in 0...(baseNum*OneSecondData) {
            xNumArr.append(String.init(format: "%.3f", Double(i)*Double(1.0/Double(OneSecondData))))
        }
        dataList = dataArr
        
        //计算thirdChatView 的数据
        var secondSum = 0.0
        for i in 0..<dataArr.count {
            guard let dataNum = Double(dataArr[i]) else {
                return
            }
            secondSum += dataNum
            secondDataArr.append(String.init(format: "%.3f", secondSum/60000*26))
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
        //加锁
        objc_sync_enter(self)
        self.setInterface()
        objc_sync_exit(self)
        
        self.saveTmpData()
    }
    
    func saveTmpData() {
        guard let exhaleDataSum = Double(self.secondDataArr[self.secondDataArr.count-1]) else {
            return
        }
        DoctorRequestObject.shared.requestSaveTmpExhaleData(medicineId: self.medicineId, exhaleData: self.exhaleDataStr, exhaleDataSum: exhaleDataSum, addDate: self.exhaleTime)
    }
}

extension SLungTestDateController {
    @objc func writeStartDataAction() {
        let time = DisplayUtils.getNowTimestamp()
        let timeData = FLDrawDataTool.long(toNSData: time)
        BlueWriteData.startLungFunctionTrain(timeData)
    }
    
    @objc func writeStopDataAction() {
        let time = DisplayUtils.getNowTimestamp()
        let timeData = FLDrawDataTool.long(toNSData: time)
        BlueWriteData.stopLungFunctionTrain(timeData)
    }
}

/// 初始化界面
extension SLungTestDateController {
    
    func setScrollView() {
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(200*IPONE_SCALE)))
        scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize.init(width: 2*SCREEN_WIDTH, height: CGFloat(200*IPONE_SCALE))
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(NEWNAVHEIGHT+CGFloat(10*IPONE_SCALE)+18)
            make.height.equalTo(200*IPONE_SCALE)
        }
    }
    
    fileprivate func setInterface() {
        for view in self.view.subviews {
            if !(view.isKind(of: UIScrollView.classForCoder())) {
                view.removeFromSuperview()
            }
        }
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        self.setNavTitle(String.init(format: NSLocalizedString("test_time_group", comment: ""), testNum+1,testGroupNum+1))

        numResultLabel = UILabel.init()
        numResultLabel.textColor = UIColor.black
        numResultLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(numResultLabel)
        numResultLabel.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT+CGFloat(10*IPONE_SCALE))
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
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
            var defaultNumArr1:[String] = []
            for i in 0...(3*OneSecondData) {
                defaultNumArr1.append(String.init(format: "%.3f", Double(i)*Double(1.0/Double(OneSecondData))))
            }
            firstChatView.dataArrOfX = defaultNumArr1//拿到X轴坐标
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
            var defaultNumArr2:[String] = []
            for i in 0...(3*OneSecondData) {
                defaultNumArr2.append(String.init(format: "%.3f", Double(i)*Double(1.0/Double(OneSecondData))))
            }
            secondChatView.dataArrOfX = defaultNumArr2//拿到X轴坐标
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
            make.top.equalTo(thirdChatView.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(20*IPONE_SCALE)
            make.right.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(14*IPONE_SCALE)
        }
        
        var FEV1Str = 0.0
        if secondDataArr.count > 0{
            if secondDataArr.count > OneSecondData {
                guard let maxNum = Double(secondDataArr[OneSecondData-1]) else {
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
//            make.height.equalTo(14*IPONE_SCALE)
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
            make.right.equalTo(-20*IPONE_SCALE)
            make.height.equalTo(14*IPONE_SCALE)
        }
        
        startTestBtn = UIButton.init(type: .custom)
        startTestBtn.setTitleColor(.white, for: .normal)
        startTestBtn.backgroundColor = RGBCOLOR(r: 16, g: 101, b: 182, alpha: 1)
        startTestBtn.layer.cornerRadius = 7
        startTestBtn.layer.masksToBounds = true
        startTestBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startTestBtn.addTarget(self, action: #selector(startTestBtnAction(sender:)), for: .touchUpInside)
        self.view.addSubview(startTestBtn)
        startTestBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-(CGFloat(20*IPONE_SCALE)+IPHONEX_BH))
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        numResultLabel.text = String.init(format: NSLocalizedString("time_test_result", comment: ""), testGroupNum+1)
        if testGroupNum == 2 {
            startTestBtn.setTitle(NSLocalizedString("finish_testing", comment: ""), for: .normal)
        }else {
            startTestBtn.setTitle(String.init(format: NSLocalizedString("start_testing_time", comment: ""), testGroupNum+2), for: .normal)
        }
    }
}

extension SLungTestDateController {
    @objc func startTestBtnAction(sender:UIButton) {
        if dataList.count == 0 {
            LCProgressHUD.showSuccessText(NSLocalizedString("finish_first", comment: ""))
            return
        }
        if testGroupNum == 0 {
            let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Save or not", comment: ""), message: String.init(format: NSLocalizedString("save_time", comment: ""), testGroupNum+1), okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Test Again", comment: "")) {
                guard let exhaleDataSum = Double(self.secondDataArr[self.secondDataArr.count-1]) else {
                    return
                }
                DeviceRequestObject.shared.requestSaveExhaleData(medicineId: self.medicineId, exhaleData: self.exhaleDataStr, exhaleDataSum: exhaleDataSum, addDate: self.exhaleTime) { [weak self](code) in
                    if let weakself = self {
                        //隐藏加载动画
                        weakself.view.hideToastActivity()
                        if code == "200" {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload success", comment: ""))
                            weakself.dataList = []
                            weakself.xNumArr = []
                            weakself.thirdXNumArr = []
                            weakself.secondDataArr = []
                            weakself.testGroupNum += 1
                            weakself.setInterface()
                        }else {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload failed", comment: ""))
                        }
                    }
                }
            }
            self.present(alertVC, animated: true, completion: nil)
        }else if testGroupNum == 1 {
            let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Save or not", comment: ""), message: String.init(format: NSLocalizedString("save_time", comment: ""), testGroupNum+1), okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Test Again", comment: "")) {
                guard let exhaleDataSum = Double(self.secondDataArr[self.secondDataArr.count-1]) else {
                    return
                }
                DeviceRequestObject.shared.requestSaveExhaleData(medicineId: self.medicineId, exhaleData: self.exhaleDataStr, exhaleDataSum: exhaleDataSum, addDate: self.exhaleTime) { [weak self](code) in
                    if let weakself = self {
                        //隐藏加载动画
                        weakself.view.hideToastActivity()
                        if code == "200" {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload success", comment: ""))
                            weakself.dataList = []
                            weakself.xNumArr = []
                            weakself.thirdXNumArr = []
                            weakself.secondDataArr = []
                            weakself.testGroupNum += 1
                            weakself.setInterface()
                        }else {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload failed", comment: ""))
                        }
                    }
                }
            }
            self.present(alertVC, animated: true, completion: nil)
        }else if testGroupNum == 2 {
            let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Save or not", comment: ""), message: String.init(format: NSLocalizedString("save_time", comment: ""), testGroupNum+1), okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Test Again", comment: "")) {
                guard let exhaleDataSum = Double(self.secondDataArr[self.secondDataArr.count-1]) else {
                    return
                }
                DeviceRequestObject.shared.requestSaveExhaleData(medicineId: self.medicineId, exhaleData: self.exhaleDataStr, exhaleDataSum: exhaleDataSum, addDate: self.exhaleTime) { [weak self](code) in
                    if let weakself = self {
                        //隐藏加载动画
                        weakself.view.hideToastActivity()
                        if code == "200" {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload success", comment: ""))
                            weakself.writeStopDataAction()
                            weakself.navigationController?.popViewController(animated: true)
                        }else {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload failed", comment: ""))
                        }
                    }
                }
            }
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
