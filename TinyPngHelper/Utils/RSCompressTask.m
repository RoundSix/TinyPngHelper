//
//  RSCompressTask.m
//  TinyPngHelper
//
//  Created by lumeng on 6/11/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "RSCompressTask.h"
/****** Requests ******/
#import "RSCompressRequest.h"
#import "RSHttpManager.h"
/****** System ******/
#import <AppKit/AppKit.h>
/****** Utils ******/
#import "RSFileHelper.h"
#import "GCDMacro.h"

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
        _semaphore = dispatch_semaphore_create(1);
        _tasks = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public methods

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
        
        [RSHttpManager postRequest:request
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

#pragma mark - Internal

- (void)handleUploadSuccessWithInput:(Input *)input
                              output:(Output *)output
                                task:(RSCompressTaskInfo *)task
{
    task.resultSize = output.size.floatValue;
    task.compressRate = output.ratio;
    
    WEAKSELF
    [RSHttpManager downloadFromUrlString:output.url
                         destinationPath:task.outputFile
                                progress:^(NSProgress *progress) {
                                    task.progress = progress;
                                    if (weakSelf.delegate) {
                                        [weakSelf.delegate compressTaskUpdate:task];
                                    }
                                }
                          successHandler:^{
                              task.taskStatus = RSCompressTaskStatusComplete;
                              if (weakSelf.delegate) {
                                  [weakSelf.delegate compressTaskUpdate:task];
                              }
                              dispatch_semaphore_signal(weakSelf.semaphore);
                          }
                           failedHandler:^(RSError *error) {
                               [weakSelf handleFailedWithTask:task error:error];
                           }];
}

- (void)handleFailedWithTask:(RSCompressTaskInfo *)task error:(RSError *)error {
    task.taskStatus = RSCompressTaskStatusError;
    task.errorMessage = error.message;
    
    if (_delegate) {
        [_delegate compressTaskUpdate:task];
    }
    
    dispatch_semaphore_signal(_semaphore);
}

@end
