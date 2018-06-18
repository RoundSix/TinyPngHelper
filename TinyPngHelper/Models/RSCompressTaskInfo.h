//
//  RSCompressTaskInfo.h
//  TinyPngHelper
//
//  Created by lumeng on 6/12/18.
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

typedef NS_ENUM(NSInteger, RSCompressTaskStatus) {
    RSCompressTaskStatusInitial = 0,
    RSCompressTaskStatusWaiting,
    RSCompressTaskStatusUploading,
    RSCompressTaskStatusDownloading,
    RSCompressTaskStatusCompleted,
    RSCompressTaskStatusCanceled,
    RSCompressTaskStatusError
};

@interface RSCompressTaskInfo : NSObject

/**
 Local file url.
 */
@property (nonatomic, strong) NSURL *originFile;

/**
 Output file url.
 */
@property (nonatomic, strong) NSURL *outputFile;

/**
 Name of compressed file.
 */
@property (nonatomic, copy) NSString *fileName;

/**
 Status of task.
 */
@property (nonatomic, assign) RSCompressTaskStatus taskStatus;

/**
 Task progress.
 */
@property (nonatomic, strong) NSProgress *progress;

/**
 Tasks's error message.
 
 @discussion The message will be nil except taskStatus is RSCompressTaskStatusError.
 */
@property (nonatomic, strong) NSString *errorMessage;

/**
 File size before compress.
 */
@property (nonatomic, assign) float originSize;

/**
 File size after compress.
 */
@property (nonatomic, assign) float resultSize;

/**
 The compress rate of file size.
 */
@property (nonatomic, assign) float compressRate;

@property (nonatomic, strong) NSURLSessionTask *requestTask;

@end
