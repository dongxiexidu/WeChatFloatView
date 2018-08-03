//
//  ArticleFloatWindow.h
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleFloatRoundEntryView.h"
#import "ArticleFloatCollectView.h"
#import "BaseNavigationViewController.h"

typedef NS_ENUM(NSInteger,ArticleFloatWindowStatus) {
    ArticleFloatWindowStatusWindowHidden,
    ArticleFloatWindowStatusRoundEntryViewShowed,
    ArticleFloatWindowStatusRoundEntryViewHidden,
};

@interface ArticleFloatWindow : UIWindow <NSCopying,NSMutableCopying>

@property (assign, nonatomic) ArticleFloatWindowStatus status;
@property (strong, nonatomic) ArticleFloatCollectView *collectView;
@property (strong, nonatomic) BaseNavigationViewController *naviController;
@property (strong, nonatomic) ArticleFloatRoundEntryView *roundEntryView;
+ (instancetype)shareInstance;
- (void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)gesture;
    
@end
