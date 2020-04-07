//
//  HistoryExhaleHeadView.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/3.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class HistoryExhaleHeadView: UIView {
    
    var number = 1 {
        didSet{
            if number == 1 {
                oneButton.isHidden = false
                twoButton.isHidden = true
                threeButton.isHidden = true
            }else if number == 2 {
                oneButton.isHidden = false
                twoButton.isHidden = false
                threeButton.isHidden = true
            }else if number == 3 {
                oneButton.isHidden = false
                twoButton.isHidden = false
                threeButton.isHidden = false
            }
        }
    }
    
    var index = 1 {
        didSet{
            if index == 1 {
                oneButton.setTitleColor(HEXCOLOR(h: 0x113576, alpha: 1), for: .normal)
                oneButton.backgroundColor = HEXCOLOR(h: 0x29D18D, alpha: 1)
                twoButton.setTitleColor(HEXCOLOR(h: 0x333333, alpha: 1), for: .normal)
                twoButton.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 1)
                threeButton.setTitleColor(HEXCOLOR(h: 0x333333, alpha: 1), for: .normal)
                threeButton.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 1)
            }else if index == 2 {
                twoButton.setTitleColor(HEXCOLOR(h: 0x113576, alpha: 1), for: .normal)
                twoButton.backgroundColor = HEXCOLOR(h: 0x29D18D, alpha: 1)
                oneButton.setTitleColor(HEXCOLOR(h: 0x333333, alpha: 1), for: .normal)
                oneButton.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 1)
                threeButton.setTitleColor(HEXCOLOR(h: 0x333333, alpha: 1), for: .normal)
                threeButton.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 1)
            }else if index == 3 {
                threeButton.setTitleColor(HEXCOLOR(h: 0x113576, alpha: 1), for: .normal)
                threeButton.backgroundColor = HEXCOLOR(h: 0x29D18D, alpha: 1)
                oneButton.setTitleColor(HEXCOLOR(h: 0x333333, alpha: 1), for: .normal)
                oneButton.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 1)
                twoButton.setTitleColor(HEXCOLOR(h: 0x333333, alpha: 1), for: .normal)
                twoButton.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 1)
            }
        }
    }
    
    let oneButton:UIButton = UIButton.init(type: .custom)
    let twoButton:UIButton = UIButton.init(type: .custom)
    let threeButton:UIButton = UIButton.init(type: .custom)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInterface() {
        oneButton.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        oneButton.layer.borderWidth = 1
        oneButton.setTitle("第一组", for: .normal)
        oneButton.setTitleColor(HEXCOLOR(h: 0x113576, alpha: 1), for: .normal)
        oneButton.backgroundColor = HEXCOLOR(h: 0x29D18D, alpha: 1)
        oneButton.tag = 401
        oneButton.addTarget(self, action: #selector(titleClickAction(sender:)), for: .touchUpInside)
        self.addSubview(oneButton)
        oneButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo((SCREEN_WIDTH-CGFloat(80*IPONE_SCALE))/3)
        }
        
        twoButton.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        twoButton.layer.borderWidth = 1
        twoButton.setTitle("第二组", for: .normal)
        twoButton.setTitleColor(HEXCOLOR(h: 0x333333, alpha: 1), for: .normal)
        twoButton.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 1)
        twoButton.tag = 402
        twoButton.addTarget(self, action: #selector(titleClickAction(sender:)), for: .touchUpInside)
        self.addSubview(twoButton)
        twoButton.snp.makeConstraints { (make) in
            make.left.equalTo(oneButton.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo((SCREEN_WIDTH-CGFloat(80*IPONE_SCALE))/3)
        }
        
        threeButton.layer.borderColor = HEXCOLOR(h: 0x333333, alpha: 1).cgColor
        threeButton.layer.borderWidth = 1
        threeButton.setTitle("第二组", for: .normal)
        threeButton.setTitleColor(HEXCOLOR(h: 0x333333, alpha: 1), for: .normal)
        threeButton.backgroundColor = HEXCOLOR(h: 0xffffff, alpha: 1)
        threeButton.tag = 403
        threeButton.addTarget(self, action: #selector(titleClickAction(sender:)), for: .touchUpInside)
        self.addSubview(threeButton)
        threeButton.snp.makeConstraints { (make) in
            make.left.equalTo(twoButton.snp.right)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo((SCREEN_WIDTH-CGFloat(80*IPONE_SCALE))/3)
        }
    }
    
    var titleClickActionBlock:((_ index:Int)->())?
    @objc func titleClickAction(sender:UIButton) {
        switch sender.tag {
        case 401:
            index = 1
        case 402:
            index = 2
        case 403:
            index = 3
        default:
            Dprint("error")
        }
        if let block = titleClickActionBlock {
            block(index)
        }
    }
}
