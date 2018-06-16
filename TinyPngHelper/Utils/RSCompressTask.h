//
//  RSCompressTask.h
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

#import <Foundation/Foundation.h>
#import "RSCompressTaskInfo.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RSCompressTaskDelegate <NSObject>

- (void)compressTaskUpdate:(RSCompressTaskInfo *)task;

@end

@interface RSCompressTask : NSObject

@property (nonatomic, weak) id<RSCompressTaskDelegate> delegate;

+ (instancetype)defaultTask;

- (void)appendTasks:(NSArray<RSCompressTaskInfo *> *)taskInfos;

- (void)appendTask:(RSCompressTaskInfo *)taskInfo;

/**
 Cancel an array of tasks.
 This operation will remove those tasks from executing/waiting tasks cache.

 @param taskInfos Array of task that to be canceled.
 */
- (void)cancelTasks:(NSArray<RSCompressTaskInfo *> *)taskInfos;

/**
 Cancel a task.

 @param taskInfo Task which will be canceled.
 */
- (void)cancelTask:(RSCompressTaskInfo *)taskInfo;

/**
 Current task count that contains all the executing tasks and waiting tasks.

 @return Total task count
 */
- (NSUInteger)taskCount;

@end

NS_ASSUME_NONNULL_END
