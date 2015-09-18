//
//  ZTTabViewController.h
//  NovarZeTai
//
//  Created by Golden-Tech on 14-9-26.
//  Copyright (c) 2014年 golden-tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface ZTTabViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, RTLabelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// 产品说明书
@property (weak, nonatomic) IBOutlet UIView *descriView;
@property (weak, nonatomic) IBOutlet UIView *descriContentView;
@property (weak, nonatomic) IBOutlet RTLabel *descriLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *descriScrollView;
@property (weak, nonatomic) IBOutlet UILabel *descriUrlLabel;

// 剂量计算器
@property (weak, nonatomic) IBOutlet UIView *calcuView;
@property (weak, nonatomic) IBOutlet UIButton *peiyeBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhinanBtn;
@property (weak, nonatomic) IBOutlet UILabel *calcuTitle;
@property (weak, nonatomic) IBOutlet UITextView *calcuText;
@property (weak, nonatomic) IBOutlet UIImageView *textTipImg0;
@property (weak, nonatomic) IBOutlet UIImageView *textTipImg1;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIView *tipPeiYeView;
@property (weak, nonatomic) IBOutlet UIView *tipZhiNanView;
@property (weak, nonatomic) IBOutlet UIScrollView *peiyeScrollView;
@property (weak, nonatomic) IBOutlet UIView *zhinanContentView;
@property (weak, nonatomic) IBOutlet UILabel *zhinanLabel;
// 输入view
@property (weak, nonatomic) IBOutlet UIView *calcuInputView;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIImageView *numArrow;
@property (weak, nonatomic) IBOutlet UILabel *choseUnitTip;
@property (weak, nonatomic) IBOutlet UIButton *unitBtn0;
@property (weak, nonatomic) IBOutlet UIButton *unitBtn1;
@property (weak, nonatomic) IBOutlet UILabel *inputWtTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *ageScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *wtScrollView;
@property (weak, nonatomic) IBOutlet UIButton *calcuBtn;
// 计算结果view
@property (weak, nonatomic) IBOutlet UIView *calcuResView;
@property (weak, nonatomic) IBOutlet UILabel *resSexTitle;
@property (weak, nonatomic) IBOutlet UILabel *resWtTitle;
@property (weak, nonatomic) IBOutlet UILabel *resAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *resScrLabel;
@property (weak, nonatomic) IBOutlet UILabel *resUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *resWtLabel;
@property (weak, nonatomic) IBOutlet UILabel *ccrNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *doseTitle;
@property (weak, nonatomic) IBOutlet UILabel *doseNum;
@property (weak, nonatomic) IBOutlet UILabel *cntrtTitle;
@property (weak, nonatomic) IBOutlet UILabel *cntrtNum;
@property (weak, nonatomic) IBOutlet UIButton *reCalcuBtn;

// 指南推荐
@property (weak, nonatomic) IBOutlet UIView *guideView;
@property (weak, nonatomic) IBOutlet UITableView *guideTabView;
@property (strong, nonatomic) RTLabel *guideRtLabel;

// tab bar的类型 0-计算器 1-产品说明书 2-指南推荐
@property int type;

// 血清肌酐单位 0-mg/dl 1-umol/L
@property int unitType;
// 性别是否男性 YES-男性 NO-女性
@property BOOL isMan;
// 年龄
@property int ageValue;
// 血清肌酐*10
@property int scrValue;
// 体重
@property int wtValue;
// 上次年龄滑动条的位置
@property float lastAgeScrollViewX;
// 上次肌酐滑动条的位置
@property float lastScrScrollViewX;
// 上次体重滑动条的位置
@property float lastWtScrollViewX;
// 滑动方向，向左滑动YES、向右NO
@property BOOL scrollTOLeft;

// 指南推荐内容
@property (strong, nonatomic) NSArray *guideDicsArray;
@property int guideIdx;

- (IBAction)tabBtnClick:(id)sender;
- (IBAction)backHomeClick;
// 计算器view事件
- (IBAction)sexBtnClick:(id)sender;
- (IBAction)unitBtnClick:(id)sender;
- (IBAction)calcuBtnClick;
- (IBAction)reCalcuBtnClick;
- (IBAction)tipBtnClick:(id)sender;
- (IBAction)tipViewCloseBtnClick:(id)sender;

@end
