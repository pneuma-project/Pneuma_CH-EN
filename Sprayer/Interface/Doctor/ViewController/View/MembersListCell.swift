//
//  MembersListCell.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/15.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class MembersListCell: UITableViewCell {
    
    var model:UserInfoModel = UserInfoModel() {
        didSet{
            nameLabel.text = model.name
            sexLabel.text = model.sex == 1 ? NSLocalizedString("male", comment: ""):NSLocalizedString("female", comment: "")
            phoneLabel.text = "phone:" + model.phone
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var currentBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp() {
        nameLabel.font = UIFont.systemFont(ofSize: CGFloat(16*IPONE_SCALE))
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.top.equalTo(10*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        
        sexLabel.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        sexLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.right).offset(20*IPONE_SCALE)
            make.top.equalTo(10*IPONE_SCALE)
            make.height.equalTo(14*IPONE_SCALE)
        }
        
        phoneLabel.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.top.equalTo(nameLabel.snp.bottom).offset(10*IPONE_SCALE)
            make.height.equalTo(14*IPONE_SCALE)
        }
        
        currentBtn.layer.cornerRadius = 5
        currentBtn.layer.masksToBounds = true
        currentBtn.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        currentBtn.layer.borderWidth = 1
        currentBtn.backgroundColor = RGBCOLOR(r: 0, g: 83, b: 181, alpha: 1)
        currentBtn.setTitleColor(.white, for: .normal)
        currentBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.equalTo(60*IPONE_SCALE)
            make.height.equalTo(30*IPONE_SCALE)
        }
        
        historyBtn.layer.cornerRadius = 5
        historyBtn.layer.masksToBounds = true
        historyBtn.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        historyBtn.layer.borderWidth = 1
        historyBtn.backgroundColor = RGBCOLOR(r: 0, g: 83, b: 181, alpha: 1)
        historyBtn.setTitleColor(.white, for: .normal)
        historyBtn.snp.makeConstraints { (make) in
            make.right.equalTo(currentBtn.snp.left).offset(-20*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.equalTo(60*IPONE_SCALE)
            make.height.equalTo(30*IPONE_SCALE)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(20*IPONE_SCALE)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @IBAction func historyAction(_ sender: Any) {
        let vc = LungHistoryCountController()
        vc.patientSsId = model.ssId
        UIViewController.getCurrentViewCtrl().navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func currentAction(_ sender: Any) {
        let vc = MembersLungTestController()
        vc.patientId = model.ssId
        UIViewController.getCurrentViewCtrl().navigationController?.pushViewController(vc, animated: true)
    }
}
