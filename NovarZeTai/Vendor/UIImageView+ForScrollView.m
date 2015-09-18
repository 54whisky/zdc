//
//  UIImageView+ForScrollView.m
//  择泰计算器
//
//  Created by dai yun on 15/3/5.
//  Copyright (c) 2015年 golden-tech. All rights reserved.
//

#import "UIImageView+ForScrollView.h"

#define noDisableVerticalScrollTag  8369130
#define noDisableHorizontalScrollTag 836914

@implementation UIImageView (ForScrollView)

- (void) setAlpha:(CGFloat)alpha {
    
    @try{
        // NSLog(@"tag: %ld", (long)self.superview.tag);
        if (self.superview.tag == noDisableVerticalScrollTag) {
            if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin) {
                if (self.frame.size.width < 10 && self.frame.size.height > self.frame.size.width) {
                    UIScrollView *sc = (UIScrollView*)self.superview;
                    if (sc.frame.size.height < sc.contentSize.height) {
                        return;
                    }
                }
            }
        }
       [super setAlpha:alpha];
    }
    @catch (NSException *e){
        NSLog(@"error: %@", e);
    }
    
//    if (self.superview.tag == noDisableHorizontalScrollTag) {
//        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleTopMargin) {
//            if (self.frame.size.height < 10 && self.frame.size.height < self.frame.size.width) {
//                UIScrollView *sc = (UIScrollView*)self.superview;
//                if (sc.frame.size.width < sc.contentSize.width) {
//                    return;
//                }
//            }
//        }
//    }

   
}



@end
