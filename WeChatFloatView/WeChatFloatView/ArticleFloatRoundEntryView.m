//
//  ArticleFloatRoundEntryView.m
//  WeChatFloatView
//
//  Created by fashion on 2018/8/3.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

#import "ArticleFloatRoundEntryView.h"

@implementation ArticleFloatRoundEntryView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        self.userInteractionEnabled = true;
        [self addGestureRecognizer:sigleTap];
    }
    return self;
}
    
- (void)didTap:(UITapGestureRecognizer *)gesture{
    if (self.clickedCallback != nil) {
        self.clickedCallback();
    }
}
    
- (void)dealloc{
    NSLog(@"ArticleFloatRoundEntryView --dealloc");
    self.clickedCallback = nil;
}

@end
