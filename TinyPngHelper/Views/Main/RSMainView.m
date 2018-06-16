//
//  RSMainView.m
//  TinyPngHelper
//
//  Created by lumeng on 6/11/18.
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
