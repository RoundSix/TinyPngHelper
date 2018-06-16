//
//  RSFileHelperTests.m
//  TinyPngHelperTests
//
//  Created by lumeng on 6/16/18.
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

#import <XCTest/XCTest.h>

#import "RSFileHelper.h"

@interface RSFileHelperTests : XCTestCase

@property (nonatomic, strong) NSURL *imageUrl;

@end

@implementation RSFileHelperTests

- (void)setUp {
    _imageUrl = [[NSBundle mainBundle] URLForResource:@"%@#$%^&*" withExtension:@"jpg"];
}

- (void)tearDown {
    _imageUrl = nil;
}

- (void)testFileNameFromUrl {
    NSString *fileName = [RSFileHelper fileNameFromUrl:_imageUrl];
    XCTAssertTrue([fileName isEqualToString:@"%@#$%^&*.jpg"]);
}

- (void)testGetFileSizeWithFileUrl {
    float fileSize = [RSFileHelper getFileSizeWithFileUrl:_imageUrl];
    XCTAssertTrue(fileSize == 134014.0);
    
    NSURL *empty = [NSURL URLWithString:@"do-not-exists"];
    float emptyFileSize = [RSFileHelper getFileSizeWithFileUrl:empty];
    XCTAssertTrue(emptyFileSize == 0);
}

@end
