//
//  RSMainView.h
//  TinyPngHelper
//
//  Created by lumeng on 6/11/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RSDragContainer;

NS_ASSUME_NONNULL_BEGIN

@interface RSMainView : NSView

@property (nonatomic, strong) RSDragContainer *dragContainer;

@end

NS_ASSUME_NONNULL_END
