//
//  HomeViewController.h
//  zetai
//
//  Created by Golden-Tech on 14-9-26.
//  Copyright (c) 2014年 golden-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *calcuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *btn1Icon;
@property (weak, nonatomic) IBOutlet UIImageView *btn1Arrow;
@property (weak, nonatomic) IBOutlet UIButton *descriBtn;
@property (weak, nonatomic) IBOutlet UIImageView *btn2Icon;
@property (weak, nonatomic) IBOutlet UIImageView *btn2Arrow;
@property (weak, nonatomic) IBOutlet UIButton *guideBtn;
@property (weak, nonatomic) IBOutlet UIImageView *btn3Icon;
@property (weak, nonatomic) IBOutlet UIImageView *btn3Arrow;

// 免责与隐私条款
@property (weak, nonatomic) IBOutlet UIView *yinsiView;
@property (weak, nonatomic) IBOutlet UIView *yinsiTipView;
@property (weak, nonatomic) IBOutlet UIScrollView *yinsiScrollView;
@property (weak, nonatomic) IBOutlet RTLabel *yinsiContent;
@property (weak, nonatomic) IBOutlet UIView *yinsiBtnView1;
@property (weak, nonatomic) IBOutlet UIView *yinsiBtnView0;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *disAgreeBtn;
// 二维码
@property (weak, nonatomic) IBOutlet UIView *qrCodeView;

@property (weak, nonatomic) IBOutlet UIScrollView *qrCodeScrollView;

// @property (strong, nonatomic) JTSScrollIndicator *qrCodeScroolViewIndicator;

- (IBAction)termsBtnClick;
- (IBAction)btnClick:(id)sender;
- (IBAction)btnTouchDown:(id)sender;
- (IBAction)btnTouchUpOutSide:(id)sender;
- (IBAction)qrCodeBtnClick;
- (IBAction)closeQRCodeBtnClick;
// 免责与隐私事件
- (IBAction)agreeBtnClick:(id)sender;
- (IBAction)disAgreeBtnClick;

@end
