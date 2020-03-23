//
//  HeadSelectView.swift
//  Sprayer
//
//  Created by fanglin on 2020/3/2.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

/*
 *  吸雾和呼气头部选择视图
 */
class HeadSelectView: UIView {
    
    var titleBtnActionBlock:((_ index:Int)->())?
    
    var curIndex:Int = 0 {
        didSet{
            if oldValue == curIndex {
                return
            }
            if curIndex == 0 {
                leftBtn.setTitleColor(.white, for: .normal)
                leftBtn.layer.borderColor = HEXCOLOR(h: 0xffffff, alpha: 1).cgColor
                leftBtn.backgroundColor = HEXCOLOR(h: 0x8A2BE2, alpha: 1)
                rightBtn.setTitleColor(HEXCOLOR(h: 0x8A2BE2, alpha: 1), for: .normal)
                rightBtn.layer.borderColor = HEXCOLOR(h: 0xffffff, alpha: 1).cgColor
                rightBtn.backgroundColor = .white
            }else if curIndex == 1 {
                rightBtn.setTitleColor(.white, for: .normal)
                rightBtn.layer.borderColor = HEXCOLOR(h: 0xffffff, alpha: 1).cgColor
                rightBtn.backgroundColor = HEXCOLOR(h: 0x8A2BE2, alpha: 1)
                leftBtn.setTitleColor(HEXCOLOR(h: 0x8A2BE2, alpha: 1), for: .normal)
                leftBtn.layer.borderColor = HEXCOLOR(h: 0xffffff, alpha: 1).cgColor
                leftBtn.backgroundColor = .white
            }
        }
    }
    
    var leftBtn:UIButton = UIButton.init(type: .custom)
    var rightBtn:UIButton = UIButton.init(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect.init(x: 0, y: 0, width: CGFloat(140*IPONE_SCALE), height: CGFloat(30*IPONE_SCALE))
        self.setInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 初始化
extension HeadSelectView {
    func setInterface() {
        leftBtn.setTitle("吸雾", for: .normal)
        leftBtn.setTitleColor(.white, for: .normal)
        leftBtn.layer.borderColor = HEXCOLOR(h: 0xffffff, alpha: 1).cgColor
        leftBtn.backgroundColor = HEXCOLOR(h: 0x8A2BE2, alpha: 1)
        leftBtn.layer.borderWidth = 2
        leftBtn.layer.masksToBounds = true
        leftBtn.corner(byRoundingCorners: [.topLeft,.bottomLeft], radii: 5, rect: CGRect.init(x: 0, y: 0, width: CGFloat(70*IPONE_SCALE), height: CGFloat(30*IPONE_SCALE)))
        leftBtn.tag = 101
        leftBtn.addTarget(self, action: #selector(titleBtnAction(sender:)), for: .touchUpInside)
        self.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(70*IPONE_SCALE)
            make.height.equalTo(30*IPONE_SCALE)
            make.right.equalTo(-70*IPONE_SCALE)
        }
        
        rightBtn.setTitle("呼气", for: .normal)
        rightBtn.setTitleColor(HEXCOLOR(h: 0x8A2BE2, alpha: 1), for: .normal)
        rightBtn.layer.borderColor = HEXCOLOR(h: 0xffffff, alpha: 1).cgColor
        rightBtn.backgroundColor = .white
        rightBtn.layer.borderWidth = 2
        rightBtn.layer.masksToBounds = true
        rightBtn.corner(byRoundingCorners: [.topRight,.bottomRight], radii: 5, rect: CGRect.init(x: 0, y: 0, width: CGFloat(70*IPONE_SCALE), height: CGFloat(30*IPONE_SCALE)))
        rightBtn.tag = 102
        rightBtn.addTarget(self, action: #selector(titleBtnAction(sender:)), for: .touchUpInside)
        self.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.left.equalTo(70*IPONE_SCALE)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(70*IPONE_SCALE)
            make.height.equalTo(30*IPONE_SCALE)
        }
    }
    
    @objc func titleBtnAction(sender:UIButton) {
        let tag = sender.tag
        switch tag {
        case 101:
            Dprint("点击吸雾按钮")
            curIndex = 0
        case 102:
            Dprint("点击呼气按钮")
            curIndex = 1
        default:
            Dprint("error")
        }
        if let block = titleBtnActionBlock {
            block(curIndex)
        }
    }
}
