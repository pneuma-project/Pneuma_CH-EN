//
//  CRHangView.swift
//  Sheng
//
//  Created by fanglin on 2019/8/4.
//  Copyright © 2019年 fanglin. All rights reserved.
//

/**
 * @brief: 悬浮关闭视图
 */

import UIKit
import SwiftyJSON

class CRHangView: UIView {

    // MARK: - private property
    private let bgImg = UIImageView.init()  //背景图片
    private let avatarImageV = UIImageView.init()       //头像
    private let titleL = UILabel.init()                 //标题
    private let closeBtn = UIButton.init(type: .custom)     //关闭按钮
    private var beginPoint = CGPoint.zero       //拖动手势的开始位置
    
    // MARK: - SYSTEM
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        
        bgImg.image = UIImage.init(named: "CR_hangBg")
        self.addSubview(bgImg)
        bgImg.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        avatarImageV.image = UIImage.init(named: "multiTalkTipsBannerIcon")
        avatarImageV.layer.masksToBounds = true
        avatarImageV.layer.cornerRadius = CGFloat(42*IPONE_SCALE)/2.0
        self.addSubview(avatarImageV)
        avatarImageV.snp.makeConstraints { (make) in
            make.left.equalTo(10*IPONE_SCALE)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(42*IPONE_SCALE)
        }
        
        self.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-2*IPONE_SCALE)
            make.width.height.equalTo(45*IPONE_SCALE)
        }
        
        titleL.text = NSLocalizedString("calling", comment: "")
        titleL.font = UIFont.systemFont(ofSize: CGFloat(13*IPONE_SCALE))
        titleL.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        self.addSubview(titleL)
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageV.snp.right).offset(6*IPONE_SCALE)
            make.right.equalTo(closeBtn.snp.left).offset(5)
            make.top.bottom.equalToSuperview()
        }
        
        //移动手势
        let panG = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureAction(sender:)))
        self.addGestureRecognizer(panG)
        
        //点击手势
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction))
        self.addGestureRecognizer(tapG)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.closeChatRoom()
    }
    
    // MARK: - PUBLIC
    // 关闭按钮方法
    @objc func closeBtnAction() {
        SVideoChatBoardObject.quitVideoChat(closeType: 0)
        self.closeChatRoom()
        
    }
    // MARK: - PRIVATE
    // 拖动手势
    @objc private func panGestureAction(sender:UIPanGestureRecognizer){
        if let senderV = sender.view{
            if sender.state == .began {  //手势开始
                beginPoint.x = senderV.center.x
                beginPoint.y = senderV.center.y
            }else if sender.state == .changed {  //手势改变
                var transPoint = sender.translation(in: sender.view)
                transPoint.x += beginPoint.x
                transPoint.y += beginPoint.y
                senderV.center = transPoint
            }else if sender.state == .ended || sender.state == .cancelled{  //手势结束
                let leftRight:CGFloat = ISIPHONE6p ? 12:10
                let width:CGFloat = senderV.frame.size.width
                let height:CGFloat = senderV.frame.size.height
                var centerX = senderV.center.x
                var centerY = senderV.center.y
                
                if  centerX < SCREEN_WIDTH/2.0 {
                    centerX = leftRight + width/2.0
                }else {
                    centerX = SCREEN_WIDTH - leftRight - width/2.0
                }
                if centerY < 20.0 + height/2.0 {
                    centerY = 20.0 + height/2.0
                }else if centerY > SCREEN_HEIGHT - height/2.0 - 20.0{
                    centerY = SCREEN_HEIGHT - height/2.0 - 20.0
                }
                UIView.animate(withDuration: 0.1, animations: {
                    sender.view?.center = CGPoint(x:centerX, y:centerY)
                })
            }
        }
    }
    
    // 点击手势
    @objc private func tapGestureAction(){
        SVideoChatBoardObject.enterVideoChat()
    }
    
    private func closeChatRoom() { //退出聊天室
        SVideoChatBoardObject.destroy()   //销毁管理对象
    }
}
