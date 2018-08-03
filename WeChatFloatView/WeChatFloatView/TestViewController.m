//
//  TestViewController.m
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = self.view.bounds.size.width;
    UIView *naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 64)];
    naviBar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:naviBar];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 20, width, 44);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"文章详情";
    [naviBar addSubview:label];
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 20, 44, 44);
    [btn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:btn];
    
    self.view.backgroundColor = [UIColor greenColor];

}
- (void)dealloc{
    NSLog(@"dealloc -TestViewController");
}

- (void)backVC {
    [self.navigationController popViewControllerAnimated:true];
}

@end
