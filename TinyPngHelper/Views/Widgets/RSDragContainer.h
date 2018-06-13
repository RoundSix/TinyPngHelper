//
//  RSDragContainer.h
//  TinyPngHelper
//
//  Created by lumeng on 6/11/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RSDragContainerDelegate <NSObject>

- (void)draggingEntered;

- (void)draggingExist;

- (void)draggingFileAccept:(NSArray<NSURL *> *)fileUrls;

@end

@interface RSDragContainer : NSView

@property (nonatomic, weak) id<RSDragContainerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
