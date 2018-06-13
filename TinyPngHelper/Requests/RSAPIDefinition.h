//
//  APIDefnition.h
//  TinyPngHelper
//
//  Created by lumeng on 5/17/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RSRequestMethod) {
    RSRequestMethod_POST,
    RSRequestMethod_GET,
    RSRequestMethod_BINARY
};

@protocol RSAPIDefinition

- (nonnull NSString *)url;

- (RSRequestMethod)method;

/**
 [0] is NSData of file
 [1] is Name of file
 [2] is FileName of file
 [3] is mimeType of file

 @return Array if have mimeBody, nil otherwise
 */
- (nullable NSArray *)mimeBodies;

- (BOOL)forceHttps;

- (void)parseResponse:(id)responseObject;

@end
