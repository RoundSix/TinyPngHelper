//
//  RSFileHelper.m
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

#import "RSFileHelper.h"

#define kDefaultOutputFolderName @"rs_tinypng_output"

@implementation RSFileHelper

+ (NSURL *)getDefaultOutputPath {
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray<NSURL *> *desktopUrls = [filemanager URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask];
    NSURL *path = nil;
    
    if (desktopUrls.count > 0) {
        path = desktopUrls[0];
        path = [path URLByAppendingPathComponent:kDefaultOutputFolderName isDirectory:YES];
    }
    
    if (![filemanager fileExistsAtPath:path.path]) {
        NSError *error;
        [filemanager createDirectoryAtURL:path
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:&error];
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
