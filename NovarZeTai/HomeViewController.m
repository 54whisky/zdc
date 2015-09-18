//
//  HomeViewController.m
//  zetai
//
//  Created by Golden-Tech on 14-9-26.
//  Copyright (c) 2014年 golden-tech. All rights reserved.
//

#import "HomeViewController.h"
#import "ZTTabViewController.h"
#import "UIImageView+ForScrollView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

-(void)viewWillAppear:(BOOL)animated {
    // 设置icon及arrow图片样式
    [self.btn1Icon setImage:[UIImage imageNamed:@"homeIcon1_2.png"]];
    [self.btn1Arrow setImage:[UIImage imageNamed:@"homeArrow2.png"]];
    
    [self.btn2Icon setImage:[UIImage imageNamed:@"homeIcon2_2.png"]];
    [self.btn2Arrow setImage:[UIImage imageNamed:@"homeArrow2.png"]];
    
    [self.btn3Icon setImage:[UIImage imageNamed:@"homeIcon3_2.png"]];
    [self.btn3Arrow setImage:[UIImage imageNamed:@"homeArrow2.png"]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // qrCode ScrollView
    self.qrCodeScrollView.contentSize = CGSizeMake(256, 670);
    [self.qrCodeScrollView flashScrollIndicators];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置按钮选中样式
    UIColor *txtColor = [UIColor colorWithRed:54/255. green:75/255. blue:161/255. alpha:1.0];
    [self.calcuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.calcuBtn setTitleColor:txtColor forState:UIControlStateNormal];
    [self.calcuBtn setBackgroundImage:[UIImage imageNamed:@"homeBtn_selected.png"] forState:UIControlStateHighlighted];
    [self.calcuBtn setBackgroundImage:[UIImage imageNamed:@"homeBtn_normal.png"] forState:UIControlStateNormal];
    
    [self.descriBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.descriBtn setTitleColor:txtColor forState:UIControlStateNormal];
    [self.descriBtn setBackgroundImage:[UIImage imageNamed:@"homeBtn_selected.png"] forState:UIControlStateHighlighted];
    [self.descriBtn setBackgroundImage:[UIImage imageNamed:@"homeBtn_normal.png"] forState:UIControlStateNormal];
    
    [self.guideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.guideBtn setTitleColor:txtColor forState:UIControlStateNormal];
    [self.guideBtn setBackgroundImage:[UIImage imageNamed:@"homeBtn_selected.png"] forState:UIControlStateHighlighted];
    [self.guideBtn setBackgroundImage:[UIImage imageNamed:@"homeBtn_normal.png"] forState:UIControlStateNormal];
    
    // 设置隐私view样式
    self.okBtn.layer.cornerRadius = 5;
    self.agreeBtn.layer.cornerRadius = 5;
    self.disAgreeBtn.layer.cornerRadius = 5;
    self.yinsiTipView.layer.cornerRadius = 10;
    self.yinsiTipView.layer.masksToBounds = YES;
    self.yinsiScrollView.layer.borderWidth = 1;
    self.yinsiScrollView.layer.borderColor = [UIColor colorWithRed:187/255.f green:187/255.f blue:187/255.f alpha:1.0].CGColor;
    // 设置隐私声明内容
    NSString *path = [[NSBundle mainBundle]pathForResource:@"yinsi" ofType:@"html"];
    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    self.yinsiContent.text = htmlStr;
    self.yinsiContent.font = [UIFont systemFontOfSize:13];
    CGSize realSize = [self.yinsiContent optimumSize];
    self.yinsiScrollView.contentSize = realSize;
    self.yinsiScrollView.bounces = NO;
    self.yinsiContent.frame = CGRectMake(5, 0, realSize.width, realSize.height);
    
    // 查看是否同意条款声明
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isAgree = [userDefault boolForKey:@"ZDCCalculator"];
    if (!isAgree) {
        self.yinsiBtnView1.hidden = YES;
        self.yinsiBtnView0.hidden = NO;
        self.yinsiView.hidden = NO;
    } else {
        self.yinsiView.hidden = YES;
    }
    
    // 设置 qrCode ScrollView
    self.qrCodeScrollView.tag =  8369130; // 8369130;
    // [self.qrCodeScrollView flashScrollIndicators];
    
    // self.qrCodeScroolViewIndicator = [[JTSScrollIndicator alloc] initWithScrollView:self.qrCodeScrollView];
    // self.qrCodeScroolViewIndicator.backgroundColor = [UIColor blackColor];
    
    
}

#pragma mark - Scroll View Delegate
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.qrCodeScroolViewIndicator scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.qrCodeScroolViewIndicator scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.qrCodeScroolViewIndicator scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillScrollToTop:(UIScrollView *)scrollView {
    [self.qrCodeScroolViewIndicator scrollViewWillScrollToTop:scrollView];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self.qrCodeScroolViewIndicator scrollViewDidScrollToTop:scrollView];
}
*/

#pragma mark 按钮按下事件
- (IBAction)btnTouchDown:(id)sender {
    // 按钮按下修改icon及arrow样式
    if ([sender tag] == 0) {
        [self.btn1Icon setImage:[UIImage imageNamed:@"homeIcon1_1.png"]];
        [self.btn1Arrow setImage:[UIImage imageNamed:@"homeArrow1.png"]];
    } else if ([sender tag] == 1) {
        [self.btn2Icon setImage:[UIImage imageNamed:@"homeIcon2_1.png"]];
        [self.btn2Arrow setImage:[UIImage imageNamed:@"homeArrow1.png"]];
    } else {
        [self.btn3Icon setImage:[UIImage imageNamed:@"homeIcon3_1.png"]];
        [self.btn3Arrow setImage:[UIImage imageNamed:@"homeArrow1.png"]];
    }
}

#pragma mark 按钮点击事件
- (IBAction)btnClick:(id)sender {
    // 按钮按下恢复icon及arrow样式
    if ([sender tag] == 0) {
        [self.btn1Icon setImage:[UIImage imageNamed:@"homeIcon1_2.png"]];
        [self.btn1Arrow setImage:[UIImage imageNamed:@"homeArrow2.png"]];
    } else if ([sender tag] == 1) {
        [self.btn2Icon setImage:[UIImage imageNamed:@"homeIcon2_2.png"]];
        [self.btn2Arrow setImage:[UIImage imageNamed:@"homeArrow2.png"]];
    } else {
        [self.btn3Icon setImage:[UIImage imageNamed:@"homeIcon3_2.png"]];
        [self.btn3Arrow setImage:[UIImage imageNamed:@"homeArrow2.png"]];
    }
}

- (IBAction)btnTouchUpOutSide:(id)sender {
    // 恢复icon及arrow样式
    if ([sender tag] == 0) {
        [self.btn1Icon setImage:[UIImage imageNamed:@"homeIcon1_2.png"]];
        [self.btn1Arrow setImage:[UIImage imageNamed:@"homeArrow2.png"]];
    } else if ([sender tag] == 1) {
        [self.btn2Icon setImage:[UIImage imageNamed:@"homeIcon2_2.png"]];
        [self.btn2Arrow setImage:[UIImage imageNamed:@"homeArrow2.png"]];
    } else {
        [self.btn3Icon setImage:[UIImage imageNamed:@"homeIcon3_2.png"]];
        [self.btn3Arrow setImage:[UIImage imageNamed:@"homeArrow2.png"]];
    }
}

#pragma mark 显示二维码
- (IBAction)qrCodeBtnClick {
    self.qrCodeView.hidden = NO;
    // [self.qrCodeScrollView flashScrollIndicators];
    
    // CGFloat width = self.qrCodeScrollView.frame.size.width;
    // CGFloat height = self.qrCodeScrollView.frame.size.height;
    // CGFloat newPosition = self.qrCodeScrollView.contentOffset.x+width;
    
    CGRect toVisible = CGRectMake(0, 0,
                                  self.qrCodeScrollView.frame.size.width,
                                  self.qrCodeScrollView.frame.size.height);
    
    [self.qrCodeScrollView scrollRectToVisible:toVisible animated:NO];
    
    // [self.qrCodeScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
 
    
}

#pragma mark 关闭二维码
- (IBAction)closeQRCodeBtnClick {
    self.qrCodeView.hidden = YES;
}

#pragma mark 隐私声明
- (IBAction)termsBtnClick {
    self.yinsiBtnView1.hidden = NO;
    self.yinsiBtnView0.hidden = YES;
    self.yinsiView.hidden = NO;
}

#pragma mark 同意、确定
- (IBAction)agreeBtnClick:(id)sender {
    if ([sender tag] == 0) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:YES forKey:@"ZDCCalculator"];
        [userDefault synchronize];
    }
    
    self.yinsiView.hidden = YES;
}

#pragma mark 不同意退出程序
- (IBAction)disAgreeBtnClick {
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

-(void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ZTTabViewController *tbVC = segue.destinationViewController;
    tbVC.type = [sender tag];
}
@end
