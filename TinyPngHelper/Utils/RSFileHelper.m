//
//  RSFileHelper.m
//  TinyPngHelper
//
//  Created by lumeng on 6/12/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "RSFileHelper.h"

#define kDefaultOutputFolderName @"rs_tinypng_output"

@implementation RSFileHelper

+ (NSURL *)getDefaultOutputPath {
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray<NSURL *> *desktopUrls = [filemanager URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask];
    NSURL *path = nil;
    
    if (desktopUrls.count > 0) {
        path = desktopUrls[0];
        path = [path URLByAppendingPathComponent:kDefaultOutputFolderName isDirectory:YES];
    }
    
    if (![filemanager fileExistsAtPath:path.path]) {
        NSError *error;
        [filemanager createDirectoryAtURL:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return path;
}

+ (NSString *)fileNameFromUrl:(NSURL *)url {
    NSParameterAssert(url);
    
    return url.lastPathComponent;
}

+ (float)getFileSizeWithFileUrl:(NSURL *)url {
    NSParameterAssert(url);
    
    NSError *error;
    NSDictionary<NSFileAttributeKey, id> *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:&error];
    if (error) {
        return 0;
    }
    return ((NSNumber *)attributes[NSFileSize]).floatValue;
}

@end
