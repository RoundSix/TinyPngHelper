//
//  RSMainView.m
//  TinyPngHelper
//
//  Created by lumeng on 6/11/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "RSMainView.h"
/****** Widgets ******/
#import "RSGradientView.h"
#import "RSDragContainer.h"
/****** Vendors ******/
#import <Masonry.h>

@implementation RSMainView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - Initialize

- (void)initialize {
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeFileURL, nil]];
    [self initBackgroundView];
    [self initDragContainer];
}

- (void)initBackgroundView {
    RSGradientViewConfig *gradientViewConfig = [[RSGradientViewConfig alloc] init];
    gradientViewConfig.angle = 45.0f;
    gradientViewConfig.gradientColors = [NSArray arrayWithObjects:RSColorFromRGB(0x096E68), RSColorFromRGB(0x2C9891), nil];
    RSGradientView *gradientView = [[RSGradientView alloc] initWithConfig:gradientViewConfig];
    [self addSubview:gradientView];
    [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)initDragContainer {
    _dragContainer = [[RSDragContainer alloc] init];
    [self addSubview:_dragContainer];
    [_dragContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
