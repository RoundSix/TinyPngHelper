//
//  RSCompressTaskTests.m
//  TinyPngHelperTests
//
//  Created by lumeng on 6/18/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RSCompressTask.h"
#import "RSFileHelper.h"

@interface RSCompressTaskTests : XCTestCase <RSCompressTaskDelegate>

@property (nonatomic, strong) XCTestExpectation *appendExpectation;

@end

@implementation RSCompressTaskTests

- (void)setUp {
    [RSCompressTask defaultTask].delegate = self;
}

- (void)tearDown {
    [RSCompressTask defaultTask].delegate = nil;
}

- (void)testAppendTask {
    NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"%@#$%^&*" withExtension:@"jpg"];
    
    RSCompressTaskInfo *taskInfo = [[RSCompressTaskInfo alloc] init];
    taskInfo.originFile = imageUrl;
    taskInfo.originSize = [RSFileHelper getFileSizeWithFileUrl:imageUrl];
    taskInfo.fileName = [RSFileHelper fileNameFromUrl:imageUrl];
    taskInfo.outputFile = [[RSFileHelper getDefaultOutputPath] URLByAppendingPathComponent:taskInfo.fileName];
    
    _appendExpectation = [self expectationWithDescription:@"Request should succeed"];
    [[RSCompressTask defaultTask] appendTask:taskInfo];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
    XCTAssertTrue(taskInfo.taskStatus == RSCompressTaskStatusCompleted);
    XCTAssertNil(taskInfo.errorMessage);
}

- (void)compressTaskUpdate:(RSCompressTaskInfo *)task {
    if (task.taskStatus == RSCompressTaskStatusCompleted) {
        [_appendExpectation fulfill];
    }
}

@end
