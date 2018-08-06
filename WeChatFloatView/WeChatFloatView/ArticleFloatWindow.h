//
//  ArticleFloatWindow.h
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//  博客地址:https://www.jianshu.com/u/6f76b136c31e

#import <UIKit/UIKit.h>
#import "ArticleFloatRoundEntryView.h"
#import "ArticleFloatCollectView.h"
#import "BaseNavigationViewController.h"

typedef NS_ENUM(NSInteger,ArticleFloatWindowStatus) {
    ArticleFloatWindowStatusWindowHidden,
    ArticleFloatWindowStatusRoundEntryViewShowed,
    ArticleFloatWindowStatusRoundEntryViewHidden,
};

@interface ArticleFloatWindow : UIWindow 

@property (assign, nonatomic) ArticleFloatWindowStatus status;
@property (strong, nonatomic) ArticleFloatCollectView *collectView;
@property (strong, nonatomic) BaseNavigationViewController *naviController;
@property (strong, nonatomic) ArticleFloatRoundEntryView *roundEntryView;
+ (instancetype)shareInstance;
- (void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)gesture;
    
@end
