//
//  RSBaseViewController.m
//  TinyPngHelper
//
//  Created by lumeng on 6/11/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "RSBaseViewController.h"
/****** Vendors ******/
#import <Masonry.h>

@implementation RSBaseViewController

- (void)base_attachView:(NSView *)contentView {
    NSParameterAssert(contentView);
    
    [self base_detachView];
    
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)base_detachView {
    if (self.view.subviews.count >= 1) {
        for (NSView *subview in self.view.subviews) {
            [subview removeFromSuperview];
        }
    }
}

@end
