//
//  ZTTabViewController.m
//  NovarZeTai
//
//  Created by Golden-Tech on 14-9-26.
//  Copyright (c) 2014年 golden-tech. All rights reserved.
//

#import "ZTTabViewController.h"
#import "ZTGuideTableViewCell.h"
#import "SVProgressHUD.h"

// 滚动条每页显示的数值个数
#define SCROLLNUMS 9
// 滚动条每个数值的像素宽度
#define NUMWIDTH 32
// 年龄选择的最小值
#define AGEMIN 1
// 年龄选择的最大值
#define AGEMAX 140
// 血肌酐选择的最小值*10 单位mg/dl
#define CRMIN 1
// 血肌酐选择的最大值*10 单位mg/dl
#define CRMAX 40
// 血肌酐选择的最小值 单位umol/L
#define CRMIN1 10
// 血肌酐选择的最大值 单位umol/L
#define CRMAX1 350
// 体重选择的最小值
#define WTMIN 1
// 体重选择的最大值
#define WTMAX 200
// 择泰剂量的最小值*10
#define DOSEMIN 0
// 择泰剂量的最大值*10
#define DOSEMAX 100
// 浓缩液的最小值*10
#define CNTRTMIN 0
// 浓缩液的最大值*10
#define CNTRTMAX 100

@interface ZTTabViewController ()

@end

@implementation ZTTabViewController

- (void)viewWillAppear:(BOOL)animated {
    if (_type == 0) {
        [SVProgressHUD show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景渐变色
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.frame;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor whiteColor].CGColor,
                       (id)[UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0].CGColor,
                       nil];
    [self.view.layer insertSublayer:gradient atIndex:0];

    // 菜单初始化
    [self descriViewInit];
    [self calcuViewInit];
    [self guideViewInit];
    // 刷新按钮状态
    [self refreshBtnStatus];
}

#pragma mark- 产品说明
#pragma mark View初始化
- (void)descriViewInit {
    // 产品说明书数据初始化
    self.descriContentView.layer.cornerRadius = 10;
    self.descriContentView.layer.borderWidth = 1;
    self.descriContentView.layer.masksToBounds = YES;
    self.descriContentView.layer.borderColor = [UIColor colorWithRed:135/255.f green:135/255.f blue:135/255.f alpha:1.0].CGColor;
    
    // 产品说明外链
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(descriUrlClick)];
    [gestureRecognizer setNumberOfTouchesRequired:1];
    [self.descriUrlLabel addGestureRecognizer:gestureRecognizer];
    
    // 设置产品说明书说明内容
    NSString *path = [[NSBundle mainBundle]pathForResource:@"description" ofType:@"html"];
    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.descriLabel.text = htmlStr;
    self.descriLabel.font = [UIFont fontWithName:@"Avenir Next" size:12.5];
//    self.descriLabel.font = [UIFont systemFontOfSize:12.5];
    CGSize realSize = [self.descriLabel optimumSize];
    self.descriScrollView.contentSize = realSize;
    self.descriLabel.frame = CGRectMake(0, 0, realSize.width, realSize.height);
}

#pragma mark 产品说明外链点击事件
- (void)descriUrlClick {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.zometa.com.cn"]];
}

#pragma mark- 剂量计算器
#pragma mark View初始化
- (void)calcuViewInit {
    self.calcuInputView.hidden = NO;
    self.calcuResView.hidden = YES;

    // 设置代理
    self.ageScrollView.delegate = self;
    self.ageScrollView.decelerationRate = 0.4;
    self.scrScrollView.delegate = self;
    self.scrScrollView.decelerationRate = 0.4;
    self.wtScrollView.delegate = self;
    self.wtScrollView.decelerationRate = 0.4;
    
    // 设置字体斜体
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-10*(CGFloat)M_PI/180), 1, 0, 0);
    self.calcuTitle.transform = matrix;
    self.choseUnitTip.transform = matrix;
//    self.resAgeLabel.transform = matrix;
//    self.resScrLabel.transform = matrix;
//    self.resUnitLabel.transform = matrix;
//    self.resWtLabel.transform = matrix;
    self.peiyeBtn.titleLabel.transform = matrix;
    self.zhinanBtn.titleLabel.transform = matrix;
    self.zhinanLabel.transform = matrix;
    
    // 设置按钮圆角
    self.calcuBtn.layer.cornerRadius = 5;
    self.reCalcuBtn.layer.cornerRadius = 5;
    
    // 初始化数据
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(initCalcuData) userInfo:nil repeats:NO];
//    [self initCalcuData];
    // 设置配液及指南提示框内容
    [self setCalcuTips];
    
    // 状态初始化
    self.tipView.hidden = YES;
}

#pragma mark 设置配液及指南提示框内容
- (void)setCalcuTips {
    // 设置配液、指南弹出框样式及添加设置内容
    self.tipPeiYeView.layer.cornerRadius = 10;
    self.tipPeiYeView.layer.masksToBounds = YES;
    self.peiyeScrollView.layer.borderWidth = 1;
    self.peiyeScrollView.layer.borderColor = [UIColor colorWithRed:187/255.f green:187/255.f blue:187/255.f alpha:1.0].CGColor;
    NSArray *array = [NSArray arrayWithObjects:@{@"title":@"如何配液：",@"text":@"用5ml无菌注射用水将冻干粉溶解，抽取前溶解必须完全。形成的溶液应进一步用100ml的无钙输注溶液（0.9%氯化钠溶液或5%葡萄糖溶液）稀释。室温下，配制好的溶液的物理和化学性质在24小时内稳定。冻干粉经无菌溶解和稀释后，应立即使用。"}, @{@"title":@"如何输液：",@"text":@"如果先前保存于冰箱内，使用前应使溶液恢复到室温。从溶解、稀释、在2~8℃冰箱内存储至最后使用的全过程不应超过24小时。静脉输注时间不少于 15 分钟。本品不得与含钙或者其它二价阳离子的输注溶液（例如乳酸林格氏）配伍使用，应使用与其它药品分开的输液管进行单次静脉注。"}, @{@"title":@"注意事项：",@"text":@"1）唑来膦酸4mg粉剂和所需溶剂制备成的输注用溶液仅限于静脉给药。<br>2）推荐剂量为 4mg 。若骨转移患者已经出现了轻度至中肾功能 不全 症状（ CrCl =30 ~60ml/ min），建议按照以下剂量给予择泰®药物 ：CrCl>60ml/ min：4.0mg；CrCl 50~60ml/min：3.5mg；CrCl 40~49ml/min：3.3mg；CrCl 30 ~39ml/min：3.0mg。<br>3）患者应每天口服 500mg 钙和 400IU 维生素 D。 <br>4）对骨转移和多发性髓瘤患者，应每隔 3~4周给予本品。"}, nil];
    float deltaY = 5;
    for (int i=0; i<array.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(14, deltaY+7, 6, 6)];
        imgView.image = [UIImage imageNamed:@"tipIcon_0.png"];
        [self.peiyeScrollView addSubview:imgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, deltaY, 225, 20)];
        titleLabel.text = [array[i] objectForKey:@"title"];
        titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.peiyeScrollView addSubview:titleLabel];
        
        deltaY += 20;
        RTLabel *rtLabel = [[RTLabel alloc] init];
        rtLabel.frame = CGRectMake(30, deltaY, 227, 18);
        rtLabel.text = [array[i] objectForKey:@"text"];
        rtLabel.font = [UIFont fontWithName:@"Avenir Next" size:11.6];
//        rtLabel.font = [UIFont systemFontOfSize:11.6];
        CGSize size = [rtLabel optimumSize];
        rtLabel.frame = CGRectMake(30, deltaY, size.width, size.height);
        [self.peiyeScrollView addSubview:rtLabel];
        
        deltaY = deltaY + size.height + 18;
    }
    self.peiyeScrollView.contentSize = CGSizeMake(270, deltaY);
    
    // 设置指南内容
    self.tipZhiNanView.layer.cornerRadius = 10;
    self.tipZhiNanView.layer.masksToBounds = YES;
    self.zhinanContentView.layer.borderWidth = 1;
    self.zhinanContentView.layer.borderColor = [UIColor colorWithRed:187/255.f green:187/255.f blue:187/255.f alpha:1.0].CGColor;
}

#pragma mark 切换性别页面数据
- (void)setCalcuViewForSex {
    [self.sexBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"sex_%d.png", (_isMan?0:1)]] forState:UIControlStateNormal];
    
    // 剂量单位选择btn
    [self.unitBtn0 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_%d.png", (_unitType==0)?(_isMan?0:1):2]] forState:UIControlStateNormal];
    [self.unitBtn1 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_%d.png", (_unitType==1)?(_isMan?0:1):2]] forState:UIControlStateNormal];

    UIColor *blueColor = [UIColor colorWithRed:23/255.f green:20/255.f blue:117/255.f alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:226/255.f green:55/255.f blue:63/255.f alpha:1.0];
    UIColor *grayColor = [UIColor colorWithRed:116/255. green:116/255. blue:116/255. alpha:1.0];

    self.calcuTitle.textColor = (_isMan ? blueColor : redColor);
    self.calcuText.textColor = (_isMan ? blueColor : redColor);
    self.resAgeLabel.textColor = grayColor;//(_isMan ? redColor : blueColor);
    self.resScrLabel.textColor = grayColor;//(_isMan ? redColor : blueColor);
    self.resUnitLabel.textColor = grayColor;//(_isMan ? redColor : blueColor);
    self.resWtLabel.textColor = grayColor;//(_isMan ? redColor : blueColor);
    self.ccrNumLabel.textColor = (_isMan ? blueColor : redColor);
    self.calcuBtn.backgroundColor = (_isMan ? blueColor : redColor);
    self.reCalcuBtn.backgroundColor = (_isMan ? blueColor : redColor);
    self.textTipImg0.image = [UIImage imageNamed:(_isMan?@"tipIcon_0.png":@"tipIcon_1.png")];
    self.textTipImg1.image = [UIImage imageNamed:(_isMan?@"tipIcon_0.png":@"tipIcon_1.png")];
    self.inputWtTitle.text = (_isMan ? @"男性体重(kg)" : @"女性体重(kg)");
    self.resSexTitle.text = (_isMan ? @"男性" : @"女性");
    self.resWtTitle.text = (_isMan ? @"男性体重(kg)" : @"女性体重(kg)");
    self.numArrow.image = [UIImage imageNamed:(_isMan?@"numArrow_1.png":@"numArrow_0.png")];
    
    if (_isMan) {
        self.doseNum.backgroundColor = [UIColor colorWithRed:111/255.f green:110/255.f blue:147/255.f alpha:1.0];
    } else {
        self.doseNum.backgroundColor = [UIColor colorWithRed:250/255.f green:124/255.f blue:103/255.f alpha:1.0];
    }
    
    // 切换滚动条选中数值字体的颜色
    int ageIdx = self.ageScrollView.contentOffset.x/NUMWIDTH+((SCROLLNUMS-1)/2);
    UILabel *ageLabel = (UILabel*)[self.ageScrollView subviews][ageIdx];
    ageLabel.textColor = (_isMan ? redColor : blueColor);
    int scrIdx = self.scrScrollView.contentOffset.x/NUMWIDTH+((SCROLLNUMS-1)/2);
    UILabel *scrLabel = (UILabel*)[self.scrScrollView subviews][scrIdx];
    scrLabel.textColor = (_isMan ? redColor : blueColor);
    int wtIdx = self.wtScrollView.contentOffset.x/NUMWIDTH+((SCROLLNUMS-1)/2);
    UILabel *wtLabel = (UILabel*)[self.wtScrollView subviews][wtIdx];
    wtLabel.textColor = (_isMan ? redColor : blueColor);
}

#pragma mark 初始化数据
- (void)initCalcuData {
    // 剂量计算器数据初始化
    self.isMan = YES;
    self.unitType = 0;
    self.ageValue = 50;
    self.scrValue = 16;
    self.wtValue = 65;
    
    // 添加年龄数值
    [self addDataFor:0];
    // 添加血清肌酐数值
    [self addDataFor:1];
    // 添加体重数值
    [self addDataFor:3];
    
    // 设置性别颜色
    [self setCalcuViewForSex];
    
    [SVProgressHUD dismiss];
}

#pragma mark 添加滑动条数据 type:0-年龄 1-肌酐(单位mg/dl) 2-肌酐(单位umol/L) 3-体重
-(void)addDataFor:(int) type {
    UIScrollView *scrollView = (type==0?self.ageScrollView:(type==3?self.wtScrollView:self.scrScrollView));
    int value = (type==0?_ageValue:(type==3?_wtValue:_scrValue));
    int min = (type==0?AGEMIN:(type==3?WTMIN:(type==1?CRMIN:CRMIN1)));
    int max = (type==0?AGEMAX:(type==3?WTMAX:(type==1?CRMAX:CRMAX1)));
    
    // 循环添加3次数据，便于滚动条循环滚动
    for (int i=0; i<3; i++) {
        for (int j=min; j<=max; j++) {
            UILabel* label = [[UILabel alloc] init];
            label.frame = CGRectMake((j-min)*NUMWIDTH+((max-min+1)*NUMWIDTH*i), 0, NUMWIDTH, scrollView.bounds.size.height);
            // 设置显示数据
            if (type == 1) {
                [label setText:[NSString stringWithFormat:@"%0.1f", j/10.0]];
            } else {
                [label setText:[NSString stringWithFormat:@"%d", j]];
            }
            
            // 设置字体样式
            [label setFont:[UIFont systemFontOfSize:12.0]];
            [label setTextColor:[UIColor blackColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [scrollView addSubview:label];
        }
        
        // 设置选中数据字体样式
        NSArray *arry = [scrollView subviews];
        UILabel *selectLabel = arry[value-min+i*(max-min+1)];
        [selectLabel setFont:[UIFont systemFontOfSize:19.2]];
        if (_isMan) {
            selectLabel.textColor = [UIColor colorWithRed:226/255.f green:55/255.f blue:63/255.f alpha:1.0];
        } else {
            selectLabel.textColor = [UIColor colorWithRed:23/255.f green:20/255.f blue:117/255.f alpha:1.0];
        }
    }
    
    // 设置滑动条内容大小及位置
    [scrollView setContentSize:CGSizeMake((max-min+1)*NUMWIDTH*3, scrollView.bounds.size.height)];
    [scrollView setContentOffset:CGPointMake((value-((SCROLLNUMS-1)/2)-min)*NUMWIDTH+(max-min+1)*NUMWIDTH, 0)];
    
    if (type == 0) {
        _lastAgeScrollViewX = scrollView.contentOffset.x;
    } else if (type == 3) {
        _lastWtScrollViewX = scrollView.contentOffset.x;
    } else {
        _lastScrScrollViewX = scrollView.contentOffset.x;
    }
}

#pragma mark 性别切换按钮事件
- (IBAction)sexBtnClick:(id)sender {
    self.isMan = !self.isMan;
    [self setCalcuViewForSex];
}

#pragma mark 血清肌酐单位切换
- (IBAction)unitBtnClick:(id)sender {
    if (_unitType == [sender tag])
        return;
    
    _unitType = [sender tag];
    [SVProgressHUD show];
    
    _scrScrollView.delegate = nil;
    [self.unitBtn0 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_%d.png", (_unitType==0)?(_isMan?0:1):2]] forState:UIControlStateNormal];
    [self.unitBtn1 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_%d.png", (_unitType==1)?(_isMan?0:1):2]] forState:UIControlStateNormal];
    
    for (UIView *view in [_scrScrollView subviews])
        [view removeFromSuperview];
    
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeUnit) userInfo:nil repeats:NO];
}

-(void)changeUnit {
    if (_unitType == 0) {
        _scrValue = 16;
        [self addDataFor:1];
    } else {
        _scrValue = 142;
        [self addDataFor:2];
    }
    _scrScrollView.delegate = self;
    [SVProgressHUD dismiss];
}

#pragma mark 计算按钮点击事件
- (IBAction)calcuBtnClick {
    self.calcuInputView.hidden = YES;
    self.calcuResView.hidden = NO;
    
    self.resAgeLabel.text = [NSString stringWithFormat:@"%d", _ageValue];
    self.resWtLabel.text = [NSString stringWithFormat:@"%d", _wtValue];
    
    int ccr = 0;
    if (_unitType == 0) {
        self.resScrLabel.text = [NSString stringWithFormat:@"%.1f", (_scrValue/10.0)];
        self.resUnitLabel.text = @"mg/dl";
        // 计算肌酐清除率
        ccr = (int)floorf((((140-_ageValue)*_wtValue)/(72*_scrValue/10.0))*(_isMan?1.0:0.85));
    } else {
        self.resScrLabel.text = [NSString stringWithFormat:@"%d", _scrValue];
        self.resUnitLabel.text = @"umol/L";
        ccr = (int)floorf((((140-_ageValue)*_wtValue)/(72*_scrValue*0.01131))*(_isMan?1.0:0.85));
    }
    self.ccrNumLabel.text = [NSString stringWithFormat:@"%d", ccr];
    
    // 计算择泰剂量及浓缩液的值
    if (ccr < 30) {
        self.doseNum.text = @"禁用";
        self.cntrtNum.text = @"禁用";
    } else if (ccr < 40) {
        self.doseNum.text = @"3.0";
        self.cntrtNum.text = @"3.8";
    } else if (ccr < 50) {
        self.doseNum.text = @"3.3";
        self.cntrtNum.text = @"4.1";
    } else if (ccr < 60) {
        self.doseNum.text = @"3.5";
        self.cntrtNum.text = @"4.4";
    } else {
        self.doseNum.text = @"4.0";
        self.cntrtNum.text = @"5.0";
    }
}

#pragma mark 重新计算按钮点击事件
- (IBAction)reCalcuBtnClick {
    self.calcuInputView.hidden = NO;
    self.calcuResView.hidden = YES;
    
    // 剂量计算器数据初始化
//    self.isMan = YES;
    self.ageValue = 50;
    self.scrValue = 16;
    self.wtValue = 65;
    
    // 重置年龄scrollView
    self.ageScrollView.contentOffset = CGPointMake((_ageValue-((SCROLLNUMS-1)/2)-AGEMIN)*NUMWIDTH+(AGEMAX-AGEMIN+1)*NUMWIDTH, 0);
    _lastAgeScrollViewX = _ageScrollView.contentOffset.x;
    
    // 重置肌酐scrollView
    if (_unitType == 1) {
        self.unitType = 0;
        
        for (UIView *view in [_scrScrollView subviews])
            [view removeFromSuperview];
        
        [self addDataFor:1];
    }
    self.scrScrollView.contentOffset = CGPointMake((_scrValue-((SCROLLNUMS-1)/2)-CRMIN)*NUMWIDTH+(CRMAX-CRMIN+1)*NUMWIDTH, 0);
    _lastScrScrollViewX = _scrScrollView.contentOffset.x;
    
    // 重置体重scrollView
    self.wtScrollView.contentOffset = CGPointMake((_wtValue-((SCROLLNUMS-1)/2)-WTMIN)*NUMWIDTH+(WTMAX-WTMIN+1)*NUMWIDTH, 0);
    _lastWtScrollViewX = _wtScrollView.contentOffset.x;
    
    [self setCalcuViewForSex];
}

#pragma mark 配液、指南按钮点击事件
- (IBAction)tipBtnClick:(id)sender {
    self.tipView.hidden = NO;
    
    if ([sender tag] == 0) {
        self.tipPeiYeView.hidden = NO;
        self.tipZhiNanView.hidden = YES;
    } else {
        self.tipPeiYeView.hidden = YES;
        self.tipZhiNanView.hidden = NO;
    }
}

#pragma mark 配液、指南关闭按钮点击事件
- (IBAction)tipViewCloseBtnClick:(id)sender {
    self.tipView.hidden = YES;
}

#pragma mark- 数据滚动处理
#pragma mark 判断滚动条滚动方向
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 防止其他的scrollView或者tableView的事件触发调用此函数
    if ((scrollView != self.ageScrollView) && (scrollView != self.scrScrollView) && (scrollView != self.wtScrollView)) {
        return;
    }
    
    //Selected index's color changed.
    float newX= scrollView.contentOffset.x;
    
    if (scrollView == self.ageScrollView) {
        [self scrollViewScrolled:self.ageScrollView withNums:(AGEMAX-AGEMIN+1) forNewX:newX andOldX:&_lastAgeScrollViewX];
    } else if (scrollView == self.scrScrollView) {
        int max = (_unitType==0?CRMAX:CRMAX1);
        int min = (_unitType==0?CRMIN:CRMIN1);
        
        [self scrollViewScrolled:self.scrScrollView withNums:(max-min+1) forNewX:newX andOldX:&_lastScrScrollViewX];
    } else if (scrollView == self.wtScrollView) {
        [self scrollViewScrolled:self.wtScrollView withNums:(WTMAX-WTMIN+1) forNewX:newX andOldX:&_lastWtScrollViewX];
    }
    
    [self setStyleForScrollView:scrollView atOffsetX:newX];
}

#pragma mark 滚动事件处理公共函数
-(void)scrollViewScrolled:(UIScrollView*)scrollView withNums:(int)nums forNewX:(float)newX andOldX:(float*)oldX {
    if (newX != *oldX ) {
        //Left-YES,Right-NO
        if (newX > *oldX) {
            // 标志为向左滑动
            self.scrollTOLeft = YES;
            
            // 如果第三栏的数据开始显示，X值向前移动一栏宽度
            if (newX > (nums*NUMWIDTH*2 - scrollView.bounds.size.width)) {
                newX -= nums*NUMWIDTH;
            }
        }else if(newX < *oldX){
            // 标志为向右滑动
            self.scrollTOLeft = NO;
            
            // 如果第二栏的数据开始看不到（即当前显示数据全部是第一栏数据时），X值向后移动一栏宽度
            if (newX < nums*NUMWIDTH - scrollView.bounds.size.width) {
                newX += nums*NUMWIDTH;
            }
        }
        *oldX = newX;
        scrollView.contentOffset = CGPointMake(newX, 0);
    }
}

#pragma mark 滑动样式变幻
-(void)setStyleForScrollView:(UIScrollView *)scrollView atOffsetX:(CGFloat)offX {
    // 获取X偏移量整数值
    int X = [NSNumber numberWithFloat:offX].intValue;
    
    NSArray *views = [scrollView subviews];
    for (int i = 0; i<SCROLLNUMS; i++) {
        UILabel *label = views[(X+NUMWIDTH/2)/NUMWIDTH+i];
        if (i == (SCROLLNUMS-1)/2) {
            [label setFont:[UIFont systemFontOfSize:19.2]];
            if (_isMan) {
                label.textColor = [UIColor colorWithRed:226/255.f green:55/255.f blue:63/255.f alpha:1.0];
            } else {
                label.textColor = [UIColor colorWithRed:23/255.f green:20/255.f blue:117/255.f alpha:1.0];
            }
        } else {
            [label setTextColor:[UIColor blackColor]];
            [label setFont:[UIFont systemFontOfSize:12.0]];
        }
    }
}

#pragma mark 模块滑动效果
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 防止其他的scrollView或者tableView的事件触发调用此函数
    if ((scrollView != self.ageScrollView) && (scrollView != self.scrScrollView) && (scrollView != self.wtScrollView)) {
        return;
    }
    
    [self scrollViewScrolled:scrollView];
}

#pragma mark 模块拖动效果
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 防止其他的scrollView或者tableView的事件触发调用此函数
    if ((scrollView != self.ageScrollView) && (scrollView != self.scrScrollView) && (scrollView != self.wtScrollView)) {
        return;
    }
    
    if (!decelerate) {
        // 如果手指离开屏幕不会继续滑动则不会触发scrollViewDidEndDecelerating事件，所以需要对屏幕滑动位置进行判断，更新数据
        [self scrollViewScrolled:scrollView];
    }
}

#pragma mark 模块滑动效果
-(void)scrollViewScrolled:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    
    int offsetX = [NSNumber numberWithFloat:offset.x].intValue;
    int addNum = (SCROLLNUMS-1)/2;
    
    if (offsetX % NUMWIDTH != 0) {
        CGPoint cp = CGPointMake((offsetX/NUMWIDTH+(_scrollTOLeft?1:0))*NUMWIDTH, 0);
        [scrollView setContentOffset:cp animated:YES];
        // 如果是继续滚动的话，根据滚动方向修正数值
        addNum += (_scrollTOLeft?1:0);
    }
    
    // 更新参数值
    if (scrollView == self.ageScrollView) {
        self.ageValue = (int)scrollView.contentOffset.x/NUMWIDTH+AGEMIN+addNum;
        if (self.ageValue > AGEMAX) {
            self.ageValue = self.ageValue - AGEMAX + AGEMIN - 1;
        } else if (self.ageValue < AGEMIN) {
            self.ageValue = self.ageValue - AGEMIN + AGEMAX + 1;
        }
        NSLog(@"new ageValue is %d", self.ageValue);
    } else if (scrollView == self.scrScrollView) {
        int max = (_unitType==0?CRMAX:CRMAX1);
        int min = (_unitType==0?CRMIN:CRMIN1);
        
        self.scrValue = (int)scrollView.contentOffset.x/NUMWIDTH+min+addNum;
        if (self.scrValue > max) {
            self.scrValue = self.scrValue - max + min - 1;
        } else if (self.scrValue < min) {
            self.scrValue = self.scrValue - min + max + 1;
        }
        NSLog(@"new ScrValue is %d", self.scrValue);
    } else if (scrollView == self.wtScrollView) {
        self.wtValue = (int)scrollView.contentOffset.x/NUMWIDTH+WTMIN+addNum;
        if (self.wtValue > WTMAX) {
            self.wtValue = self.wtValue - WTMAX + WTMIN - 1;
        } else if (self.wtValue < WTMIN) {
            self.wtValue = self.wtValue - WTMIN + WTMAX + 1;
        }
        NSLog(@"new WtValue is %d", self.wtValue);
    }
}

#pragma mark- 指南推荐
#pragma mark View初始化
- (void)guideViewInit {
    self.guideDicsArray = [NSArray arrayWithObjects:@{@"title":@"恶性肿瘤骨转移及骨相关疾病临床诊疗专家共识（2014版） ", @"text":@"双膦酸盐的应用强调早期、规律、长期治疗。<br>一旦确诊恶性肿瘤骨转移，即建议开始双膦酸盐治疗。<br>无骨痛等临床症状、但已确诊骨转移的患者，仍然建议常规使用双膦酸盐治疗。<br>唑来膦酸与帕米磷酸的对比研究结果显示，唑来膦酸在多种恶性肿瘤骨转移患者中降低SRE的疗效优于或相当于后者。<br><br>[1]中国抗癌协会癌症康复与姑息治疗专业委员会（CRPC），中国抗癌协会临床肿瘤学协作专业委员会（CSCO）主编．恶性肿瘤骨转移及骨相关疾病临床诊疗专家共识（2014版）[M]．北京：北京大学医学出版社，2014.9，ISBN 978-7-5659-0934-4：1-158．<br><br>"}, @{@"title":@"ESMO关于肿瘤患者骨健康的临床实践指南", @"text":@"通过包括骨靶向治疗，如双膦酸盐或地诺单抗的使用在内的多学科优化管理骨转移患者， 可能改变很多晚期肿瘤患者的病程，使骨并发症发生率有较大的降低，并减轻骨痛，改善生活质量。<br>无论是否有症状，均推荐唑来膦酸或地诺单抗用于乳腺癌骨转移患者。<br>无论是否有症状，均推荐唑来膦酸或地诺单抗用于激素抵抗型前列腺癌骨转移患者。<br>推荐唑来膦酸或地诺单抗用于晚期肺癌、肾细胞癌和其他实体肿瘤骨转移患者。<br><br>详细内容 <a href='http://www.esmo.org/Guidelines/Supportive-Care/Bone-Health-in-Cancer-Patients'><font color='blue'>点击这里</font></a><br><font size=11>(您将进入一个独立于诺华公司的第三方网站。)</font><br><br>"}, @{@"title":@"国际专家小组推荐的双膦酸盐应用于实体肿瘤患者的指南", @"text":@"基于有效性数据，专家小组推荐使用含氮的双膦酸盐，用于转移性骨疾病的乳腺癌患者。<br>对于肺癌患者，应基于患者的体力状况和预期生存期的评估考虑使用唑来膦酸。<br>对于激素抵抗型前列腺癌患者，基于临床证据，唑来膦酸是双膦酸盐中的现有选择，可降低骨骼并发症的发生，缓解患者的疼痛。<br>既然SRE的风险是持续的，专家小组推荐，即使患者经历了骨相关事件，仍可根据已有的支持数据，根据个体风险评估2年以上的双膦酸盐持续治疗。<br><br>详细内容 <a href='http://annonc.oxfordjournals.org/content/early/2007/09/28/annonc.mdm442'><font color='blue'>点击这里</font></a><br><font size=11>(您将进入一个独立于诺华公司的第三方网站。)</font><br><br>"}, @{@"title":@"国际骨髓瘤协作组对多发性骨髓瘤相关骨病的推荐", @"text":@"无论影像学上是否有溶骨性病变，均应考虑在所有多发性骨髓瘤患者的一线抗骨髓瘤治疗中使用双膦酸盐。静脉输注唑来膦酸或帕米膦酸均被推荐用于预防多发性骨髓瘤患者的骨相关事件。在新诊断的多发性骨髓瘤患者中，唑来膦酸优于氯屈膦酸。唑来膦酸或帕米膦酸应持续应用，并应在疾病复发后重新使用。<br>【该指南推荐基于国际临床数据的汇总，其内容对比唑来膦酸(择泰®)：目前获批适应症（用于治疗实体肿瘤骨转移患者和多发性骨髓瘤患者的骨骼损害以及恶性肿瘤引起的高钙血症） 更强调早期应用。适应症外应用应基于医生对于患者的综合评估】<br><br>详细内容 <a href='http://jco.ascopubs.org/content/31/18/2347.full.pdf+html?sid=6572ec83-cd39-4caa-8d15-5504cc67e86a'><font color='blue'>点击这里</font></a><br><font size=11>(您将进入一个独立于诺华公司的第三方网站。)</font>"}, nil];
    
    self.guideTabView.delegate = self;
    self.guideTabView.dataSource = self;
    self.guideRtLabel = [[RTLabel alloc] init];
    self.guideIdx = -1;
    
    UILabel *numLab = [[UILabel alloc] initWithFrame:CGRectMake(162, 22, 10, 10)];
    numLab.text = @"1";
    numLab.font = [UIFont systemFontOfSize:10];
    numLab.textColor = [UIColor colorWithRed:27/255.f green:18/255.f blue:105/255.f alpha:1.0];
    [self.guideTabView addSubview:numLab];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_guideDicsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (row == _guideIdx) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        UILabel *grayLabel = [[UILabel alloc] init];
        grayLabel.frame = CGRectMake(0, 0, 320, 1);
        grayLabel.backgroundColor = [UIColor colorWithRed:188/255.f green:187/255.f blue:193/255.f alpha:1.0];
        [cell.contentView addSubview:grayLabel];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(23, 19, 5, 5);
        imgView.image = [UIImage imageNamed:@"tipIcon_0.png"];
        [cell.contentView addSubview:imgView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(36, 2, 240, 40);
        titleLabel.text = [_guideDicsArray[[indexPath row]] objectForKey:@"title"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithRed:27/255.f green:18/255.f blue:105/255.f alpha:1.0];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *arrowImgView = [[UIImageView alloc] init];
        arrowImgView.frame = CGRectMake(291, 18, 12, 7);
        arrowImgView.image = [UIImage imageNamed:@"zt_arrow_up.png"];
        [cell.contentView addSubview:arrowImgView];
        
        [cell.contentView addSubview:self.guideRtLabel];
        cell.frame = CGRectMake(0, 0, 320, self.guideRtLabel.bounds.size.height+44+20);
        return cell;
    } else {
        static NSString *cellIdentifier = @"ZTGuideTableViewCell";
        ZTGuideTableViewCell *cell = (ZTGuideTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            UINib *nib = [UINib nibWithNibName:@"ZTGuideTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
        cell.titleLabel.text = [_guideDicsArray[row] objectForKey:@"title"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == _guideIdx) {
        self.guideRtLabel.frame = CGRectMake(36, 44, 250, 20);
        self.guideRtLabel.text = [_guideDicsArray[[indexPath row]] objectForKey:@"text"];
        self.guideRtLabel.font = [UIFont fontWithName:@"Avenir Next" size:12.5];
//        self.guideRtLabel.font = [UIFont systemFontOfSize:12.5];
        CGSize realSize = [self.guideRtLabel optimumSize];
        self.guideRtLabel.frame = CGRectMake(36, 44, realSize.width, realSize.height);
        self.guideRtLabel.delegate = self;
        
        return realSize.height+44+20;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] != self.guideIdx) {
        self.guideIdx = [indexPath row];
    } else {
        self.guideIdx = -1;
    }
    [self.guideTabView reloadData];
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url {
    if (rtLabel == self.guideRtLabel) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark- 公共处理
- (void)refreshBtnStatus {
    for (int i=0; i<3; i++) {
        UIButton *btn = (UIButton*)[self.view viewWithTag:10+i];
        
        if (_type == i) {
            [btn setBackgroundImage:[UIImage imageNamed:@"tabBar_focus.png"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"miniIcon%d_2.png", i]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:54/255.f green:75/255.f blue:161/255.f alpha:1.0] forState:UIControlStateNormal];
        } else {
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"miniIcon%d_1.png", i]] forState:UIControlStateNormal];
        }
    }
    
    if (_type == 0) {
        self.calcuView.hidden = NO;
        self.descriView.hidden = YES;
        self.guideView.hidden = YES;
        self.titleLabel.text = @"剂量计算器";
    } else if (_type == 1) {
        self.descriView.hidden = NO;
        self.calcuView.hidden = YES;
        self.guideView.hidden = YES;
        self.titleLabel.text = @"产品说明书";
    } else {
        self.guideView.hidden = NO;
        self.calcuView.hidden = YES;
        self.descriView.hidden = YES;
        self.titleLabel.text = @"指南推荐";
    }
}

- (IBAction)tabBtnClick:(id)sender {
    int idx = [sender tag] - 10;
    
    if (_type == idx)
        return;
    
    _type = idx;
    if ((_type == 2) && (_guideIdx != -1)) {
        // 切换到指南推荐，默认打开第一个
        _guideIdx = -1;
        [self.guideTabView reloadData];
    }
    
    [self refreshBtnStatus];
}

- (IBAction)backHomeClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    self.ageScrollView.delegate = nil;
    self.scrScrollView.delegate = nil;
    self.wtScrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
