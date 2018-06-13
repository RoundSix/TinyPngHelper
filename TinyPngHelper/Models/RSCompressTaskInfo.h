//
//  RSCompressTaskInfo.h
//  TinyPngHelper
//
//  Created by lumeng on 6/12/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RSCompressTaskStatus) {
    RSCompressTaskStatusInitial = 0,
    RSCompressTaskStatusWaiting,
    RSCompressTaskStatusUploading,
    RSCompressTaskStatusDownloading,
    RSCompressTaskStatusComplete,
    RSCompressTaskStatusError
};

@interface RSCompressTaskInfo : NSObject

@property (nonatomic, strong) NSURL *originFile;
@property (nonatomic, strong) NSURL *outputFile;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) RSCompressTaskStatus taskStatus;
@property (nonatomic, strong) NSProgress *progress;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) float originSize;
@property (nonatomic, assign) float resultSize;
@property (nonatomic, assign) float compressRate;

@end
