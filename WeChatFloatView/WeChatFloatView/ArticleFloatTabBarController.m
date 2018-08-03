//
//  ArticleFloatTabBarController.m
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

#import "ArticleFloatTabBarController.h"
#import "ArticleFloatWindow.h"

@interface ArticleFloatTabBarController ()<UITabBarControllerDelegate>

@end

@implementation ArticleFloatTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.delegate = self;
}

// MARK: UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        BaseNavigationViewController *nav = (BaseNavigationViewController *)viewController;
        ArticleFloatWindow.shareInstance.naviController = nav;
    }
    
}


@end
