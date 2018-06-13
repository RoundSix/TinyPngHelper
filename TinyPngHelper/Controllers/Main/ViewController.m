//
//  ViewController.m
//  TinyPngHelper
//
//  Created by lumeng on 5/17/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "ViewController.h"
/****** Vendors ******/
#import <Masonry.h>
/****** Utils ******/
#import "RSCompressTask.h"
#import "RSFileHelper.h"
/****** Views ******/
#import "RSMainView.h"
#import "RSDragContainer.h"
/****** Http ******/
#import "RSError.h"

@interface ViewController () <RSDragContainerDelegate, RSCompressTaskDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RSMainView *mainView = [[RSMainView alloc] init];
    [self base_attachView:mainView];
    mainView.dragContainer.delegate = self;
    
    [RSCompressTask defaultTask].delegate = self;
    
//    RSCompressRequest *request = [[RSCompressRequest alloc] initWithImage:[NSImage imageNamed:@"launchImage-Protrait~iPad"]];
//    [RSHttpManager postRequest:request
//                  successBlock:^{
//                  }
//                rawFailedBlock:^(RSError *error) {
//                    NSLog(@"[aizuoye ios] rawFailedBlock %@", error.description);
//                }
//               completionBlock:^{
//                   NSLog(@"[aizuoye ios] completionBlock");
//               }];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark - RSDragContainer Delegate

- (void)draggingEntered {
}

- (void)draggingExist {
}

- (void)draggingFileAccept:(NSArray<NSURL *> *)fileUrls {
    NSURL *url = fileUrls[0];
    RSCompressTaskInfo *taskInfo = [RSCompressTaskInfo new];
    taskInfo.originFile = url;
    taskInfo.originSize = [RSFileHelper getFileSizeWithFileUrl:url];
    taskInfo.fileName = [RSFileHelper fileNameFromUrl:url];
    
    [[RSCompressTask defaultTask] appendTask:taskInfo];
}

#pragma mark - RSCompressTask Delegate

- (void)compressTaskUpdate:(RSCompressTaskInfo *)task {
    
}

@end
