//
//  SLungTestNumCell.swift
//  Sprayer
//
//  Created by FangLin on 2020/3/28.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class SLungTestNumCell: UITableViewCell {
    
    var dataNum:Int = 0 {
        didSet{
            if dataNum == 0 {
                firstTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
                firstSelView.isHidden = true
                secondTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
                secondSelView.isHidden = true
                thirdTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
                thirdSelView.isHidden = true
            }else if dataNum == 1 {
                firstTipView.layer.borderColor = HEXCOLOR(h: 0xFF7F00, alpha: 1).cgColor
                firstSelView.isHidden = false
                secondTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
                secondSelView.isHidden = true
                thirdTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
                thirdSelView.isHidden = true
            }else if dataNum == 2 {
                firstTipView.layer.borderColor = HEXCOLOR(h: 0xFF7F00, alpha: 1).cgColor
                firstSelView.isHidden = false
                secondTipView.layer.borderColor = HEXCOLOR(h: 0xFF7F00, alpha: 1).cgColor
                secondSelView.isHidden = false
                thirdTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
                thirdSelView.isHidden = true
            }else if dataNum == 3 {
                firstTipView.layer.borderColor = HEXCOLOR(h: 0xFF7F00, alpha: 1).cgColor
                firstSelView.isHidden = false
                secondTipView.layer.borderColor = HEXCOLOR(h: 0xFF7F00, alpha: 1).cgColor
                secondSelView.isHidden = false
                thirdTipView.layer.borderColor = HEXCOLOR(h: 0xFF7F00, alpha: 1).cgColor
                thirdSelView.isHidden = false
            }
        }
    }

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var testNumLabel: UILabel!
    @IBOutlet weak var firstTipView: UIView!
    @IBOutlet weak var firstSelView: UIView!
    @IBOutlet weak var secondTipView: UIView!
    @IBOutlet weak var secondSelView: UIView!
    @IBOutlet weak var thirdTipView: UIView!
    @IBOutlet weak var thirdSelView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }
    
    fileprivate func setUp() {
        bgView.backgroundColor = HEXCOLOR(h: 0x29D18D, alpha: 1)
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = HEXCOLOR(h: 0x113576, alpha: 1).cgColor
        bgView.isUserInteractionEnabled = false
        bgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(5*IPONE_SCALE)
            make.bottom.equalTo(-5*IPONE_SCALE)
        }
        
        testNumLabel.textColor = HEXCOLOR(h: 0x113576, alpha: 1)
        testNumLabel.font = UIFont.systemFont(ofSize: CGFloat(14*IPONE_SCALE))
        testNumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(5*IPONE_SCALE)
            make.height.equalTo(14*IPONE_SCALE)
            make.centerX.equalToSuperview()
        }
        
        secondTipView.backgroundColor = .clear
        secondTipView.layer.cornerRadius = CGFloat(18*IPONE_SCALE)/2
        secondTipView.layer.masksToBounds = true
        secondTipView.layer.borderWidth = 2
        secondTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        secondTipView.snp.makeConstraints { (make) in
            make.top.equalTo(testNumLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(18*IPONE_SCALE)
        }
        secondSelView.backgroundColor = HEXCOLOR(h: 0xFF7F00, alpha: 1)
        secondSelView.layer.cornerRadius = CGFloat(4*IPONE_SCALE)
        secondSelView.layer.masksToBounds = true
        secondSelView.isHidden = true
        secondSelView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(9*IPONE_SCALE)
        }
        
        firstTipView.backgroundColor = .clear
        firstTipView.layer.cornerRadius = CGFloat(18*IPONE_SCALE)/2
        firstTipView.layer.masksToBounds = true
        firstTipView.layer.borderWidth = 2
        firstTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        firstTipView.snp.makeConstraints { (make) in
            make.top.equalTo(testNumLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.right.equalTo(secondTipView.snp.left).offset(-10*IPONE_SCALE)
            make.width.height.equalTo(18*IPONE_SCALE)
        }
        firstSelView.backgroundColor = HEXCOLOR(h: 0xFF7F00, alpha: 1)
        firstSelView.layer.cornerRadius = CGFloat(4*IPONE_SCALE)
        firstSelView.layer.masksToBounds = true
        firstSelView.isHidden = true
        firstSelView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(9*IPONE_SCALE)
        }
        
        thirdTipView.layer.cornerRadius = CGFloat(18*IPONE_SCALE)/2
        thirdTipView.layer.masksToBounds = true
        thirdTipView.backgroundColor = .clear
        thirdTipView.layer.borderWidth = 2
        thirdTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        thirdTipView.snp.makeConstraints { (make) in
            make.top.equalTo(testNumLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.left.equalTo(secondTipView.snp.right).offset(10*IPONE_SCALE)
            make.width.height.equalTo(18*IPONE_SCALE)
        }
        thirdSelView.backgroundColor = HEXCOLOR(h: 0xFF7F00, alpha: 1)
        thirdSelView.layer.cornerRadius = CGFloat(4*IPONE_SCALE)
        thirdSelView.layer.masksToBounds = true
        thirdSelView.isHidden = true
        thirdSelView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(9*IPONE_SCALE)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
