//
//  RSGradientView.h
//  TinyPngHelper
//
//  Created by lumeng on 6/8/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RSGradientViewConfig : NSObject

@property (nonatomic, copy) NSArray<NSColor *> *gradientColors;
@property (nonatomic, assign) CGFloat locations;
@property (nonatomic, assign) CGFloat angle;

@end

#import <AppKit/AppKit.h>

@interface RSGradientView : NSView

- (instancetype)initWithConfig:(RSGradientViewConfig *)config;

@end
