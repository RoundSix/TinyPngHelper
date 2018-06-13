//
//  RSCompressTask.h
//  TinyPngHelper
//
//  Created by lumeng on 6/11/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSCompressTaskInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RSCompressTaskDelegate <NSObject>

- (void)compressTaskUpdate:(RSCompressTaskInfo *)task;

@end

@interface RSCompressTask : NSObject

@property (nonatomic, weak) id<RSCompressTaskDelegate> delegate;

+ (instancetype)defaultTask;

- (void)appendTask:(RSCompressTaskInfo *)taskInfo;

@end

NS_ASSUME_NONNULL_END
