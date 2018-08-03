//
//  ViewController.m
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController
    
    
- (IBAction)pushVC:(id)sender {
    
    TestViewController *vc = [[TestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:true animated:false];
}

@end
