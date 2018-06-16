//
//  RSCompressTask.m
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

#import "RSCompressTask.h"
/****** Requests ******/
#import "RSCompressRequest.h"
#import "RSHttpManager.h"
/****** System ******/
#import <AppKit/AppKit.h>
/****** Utils ******/
#import "RSFileHelper.h"

#define kMaxTaskCount 3

@interface RSCompressTask ()

@property (nonatomic, strong) dispatch_queue_t operationQueue;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, copy) NSMutableArray<RSCompressTaskInfo *> *tasks;

@end

@implementation RSCompressTask

+ (instancetype)defaultTask {
    static RSCompressTask *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RSCompressTask alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _operationQueue = dispatch_queue_create("rs.queue.compress", DISPATCH_QUEUE_SERIAL);
        _semaphore = dispatch_semaphore_create(kMaxTaskCount);
        _tasks = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public methods

- (void)appendTasks:(NSArray<RSCompressTaskInfo *> *)taskInfos {
    for (RSCompressTaskInfo *task in taskInfos) {
        [self appendTask:task];
    }
}

- (void)appendTask:(RSCompressTaskInfo *)taskInfo {
    if ([_tasks containsObject:taskInfo]) {
        return;
    }
    
    [_tasks addObject:taskInfo];
    taskInfo.taskStatus = RSCompressTaskStatusWaiting;
    taskInfo.fileName = [RSFileHelper fileNameFromUrl:taskInfo.originFile];
    
    WEAKSELF
    dispatch_async(_operationQueue, ^{
        dispatch_semaphore_wait(weakSelf.semaphore, DISPATCH_TIME_FOREVER);
        
        NSImage *image = [[NSImage alloc] initByReferencingURL:taskInfo.originFile];
        RSCompressRequest *request = [[RSCompressRequest alloc] initWithImage:image];
        taskInfo.taskStatus = RSCompressTaskStatusUploading;
        taskInfo.requestTask = [RSHttpManager postRequest:request
                                             successBlock:^{
                                                 taskInfo.taskStatus = RSCompressTaskStatusDownloading;
                                                 if (weakSelf.delegate) {
                                                     [weakSelf.delegate compressTaskUpdate:taskInfo];
                                                 }
                                                 [weakSelf handleUploadSuccessWithInput:request.input
                                                                                 output:request.output
                                                                                   task:taskInfo];
                                             }
                                           rawFailedBlock:^(RSError *error) {
                                               [weakSelf handleFailedWithTask:taskInfo error:error];
                                           }
                                          completionBlock:nil];
    });
}

- (void)cancelTasks:(NSArray<RSCompressTaskInfo *> *)taskInfos {
    NSParameterAssert(taskInfos);
    
    for (RSCompressTaskInfo *taskInfo in taskInfos) {
        [self cancelTask:taskInfo];
    }
}

- (void)cancelTask:(RSCompressTaskInfo *)taskInfo {
    NSParameterAssert(taskInfo);
    
    NSURLSessionTask *request = taskInfo.requestTask;
    if (request && request.state == NSURLSessionTaskStateRunning) {
        [request cancel];
    }
    
    taskInfo.taskStatus = RSCompressTaskStatusCanceled;
    taskInfo.requestTask = nil;
    
    if (_delegate) {
        [_delegate compressTaskUpdate:taskInfo];
    }
    
    if ([_tasks containsObject:taskInfo]) {
        [_tasks removeObject:taskInfo];
    }
}

- (NSUInteger)taskCount {
    return _tasks.count;
}

#pragma mark - Internal

- (void)handleUploadSuccessWithInput:(Input *)input
                              output:(Output *)output
                                task:(RSCompressTaskInfo *)task
{
    task.resultSize = output.size.floatValue;
    task.compressRate = output.ratio;
    
    WEAKSELF
    task.requestTask = [RSHttpManager downloadFromUrlString:output.url
                                            destinationPath:task.outputFile
                                                   progress:^(NSProgress *progress) {
                                                       task.progress = progress;
                                                       if (weakSelf.delegate) {
                                                           [weakSelf.delegate compressTaskUpdate:task];
                                                       }
                                                   }
                                             successHandler:^{
                                                 [weakSelf handleSuccessWithTask:task];
                                             }
                                              failedHandler:^(RSError *error) {
                                                  [weakSelf handleFailedWithTask:task error:error];
                                              }];
}

- (void)handleSuccessWithTask:(RSCompressTaskInfo *)task {
    task.taskStatus = RSCompressTaskStatusComplete;
    if (_delegate) {
        [_delegate compressTaskUpdate:task];
    }
    [_tasks removeObject:task];
    dispatch_semaphore_signal(_semaphore);
}

- (void)handleFailedWithTask:(RSCompressTaskInfo *)task error:(RSError *)error {
    task.taskStatus = RSCompressTaskStatusError;
    task.errorMessage = error.message;
    
    if (_delegate) {
        [_delegate compressTaskUpdate:task];
    }
    [_tasks removeObject:task];
    dispatch_semaphore_signal(_semaphore);
}

@end
