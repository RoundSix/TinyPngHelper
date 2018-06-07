//
//  NSData+RSImageType.m
//  TinyPngHelper
//
//  Created by User on 6/6/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "NSData+RSImageType.h"

@implementation NSData (RSImageType)

- (RSImageDataContentType)rs_contentTypeStr:(NSString **)dataContentTypeStr {
    if (self.length <= 0) {
        *dataContentTypeStr = nil;
        return RSImageDataContentTypeNone;
    }
    NSDictionary *imageContentTypMapDict = @{
                                             @"":@(RSImageDataContentTypeNone),
                                             @"image/jpeg": @(RSImageDataContentTypeJEPG),
                                             @"image/png": @(RSImageDataContentTypePNG),
                                             @"image/gif": @(RSImageDataContentTypeGIF),
                                             @"image/tiff": @(RSImageDataContentTypeTiff),
                                             @"image/webp": @(RSImageDataContentTypeWEBP),
                                             };
    (*dataContentTypeStr) = [self rs_contentTypeStr];
    if ((*dataContentTypeStr).length) {
        if ([imageContentTypMapDict.allKeys containsObject:(*dataContentTypeStr)]) {
            return (RSImageDataContentType)[imageContentTypMapDict[(*dataContentTypeStr)] integerValue];
        }else {
            return RSImageDataContentTypeNone;
        }
    }
    return RSImageDataContentTypeNone;
}

- (NSString *)rs_contentTypeStr {
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([self length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            
            return nil;
    }
    return nil;
}

@end
