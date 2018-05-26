//
//  NSString+Base64.m
//  TinyPngHelper
//
//  Created by lumeng on 5/17/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)

- (NSString *)encodedString {
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [stringData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
