//
//  RSBaseViewController.h
//  TinyPngHelper
//
//  Created by lumeng on 6/11/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSBaseViewController : NSViewController

- (void)base_attachView:(NSView *)contentView;

- (void)base_detachView;

@end

NS_ASSUME_NONNULL_END
