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
                firstTipView.backgroundColor = .clear
                secondTipView.backgroundColor = .clear
                thirdTipView.backgroundColor = .clear
            }else if dataNum == 1 {
                firstTipView.backgroundColor = HEXCOLOR(h: 0x436EEE, alpha: 1)
                secondTipView.backgroundColor = .clear
                thirdTipView.backgroundColor = .clear
            }else if dataNum == 2 {
                firstTipView.backgroundColor = HEXCOLOR(h: 0x436EEE, alpha: 1)
                secondTipView.backgroundColor = HEXCOLOR(h: 0x436EEE, alpha: 1)
                thirdTipView.backgroundColor = .clear
            }else if dataNum == 3 {
                firstTipView.backgroundColor = HEXCOLOR(h: 0x436EEE, alpha: 1)
                secondTipView.backgroundColor = HEXCOLOR(h: 0x436EEE, alpha: 1)
                thirdTipView.backgroundColor = HEXCOLOR(h: 0x436EEE, alpha: 1)
            }
        }
    }

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var testNumLabel: UILabel!
    @IBOutlet weak var firstTipView: UIView!
    @IBOutlet weak var secondTipView: UIView!
    @IBOutlet weak var thirdTipView: UIView!
    
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
        secondTipView.layer.borderWidth = 1
        secondTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        secondTipView.snp.makeConstraints { (make) in
            make.top.equalTo(testNumLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(15*IPONE_SCALE)
        }
        
        firstTipView.backgroundColor = .clear
        firstTipView.layer.borderWidth = 1
        firstTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        firstTipView.snp.makeConstraints { (make) in
            make.top.equalTo(testNumLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.right.equalTo(secondTipView.snp.left).offset(-10*IPONE_SCALE)
            make.width.height.equalTo(15*IPONE_SCALE)
        }
        
        thirdTipView.backgroundColor = .clear
        thirdTipView.layer.borderWidth = 1
        thirdTipView.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        thirdTipView.snp.makeConstraints { (make) in
            make.top.equalTo(testNumLabel.snp.bottom).offset(5*IPONE_SCALE)
            make.left.equalTo(secondTipView.snp.right).offset(10*IPONE_SCALE)
            make.width.height.equalTo(15*IPONE_SCALE)
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
