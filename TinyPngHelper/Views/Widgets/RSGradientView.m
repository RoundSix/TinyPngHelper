//
//  RSGradientView.m
//  TinyPngHelper
//
//  Created by lumeng on 6/8/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "RSGradientView.h"
#import <Quartz/Quartz.h>

@implementation RSGradientViewConfig

@end

@interface RSGradientView()

@property (nonatomic, strong) RSGradientViewConfig *config;

@property (nonatomic, strong) NSGradient *gradient;

@end

@implementation RSGradientView

- (instancetype)initWithConfig:(RSGradientViewConfig *)config {
    if (self = [super init]) {
        _config = config;
        [self initialize];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    NSArray<NSColor *> *gradientColors = nil;
    
    if (_config && _config.gradientColors) {
        gradientColors = _config.gradientColors;
    } else {
        gradientColors = [NSArray arrayWithObjects:RSColorFromRGB(0x000000), RSColorFromRGB(0xffffff), nil];
    }
    
    _gradient = [[NSGradient alloc] initWithColors:gradientColors];
}

- (void)drawRect:(NSRect)dirtyRect {
    [_gradient drawInRect:self.bounds angle:_config.angle];
}

@end
