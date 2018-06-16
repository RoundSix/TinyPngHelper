//
//  RSGradientView.m
//  TinyPngHelper
//
//  Created by lumeng on 6/8/18.
//  Copyright © 2018 roundsix. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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
