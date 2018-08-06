//
//  ArticleFloatRoundEntryAnimator.h
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//  博客地址:https://www.jianshu.com/u/6f76b136c31e

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ArticleFloatRoundEntryAnimator : NSObject
    
@property (assign, nonatomic) UINavigationControllerOperation operation;
@property (assign, nonatomic) CGPoint sourceCenter;
    
- (instancetype)initWithOperation:(UINavigationControllerOperation)operation sourceCenter:(CGPoint)sourceCenter;
    
@end
