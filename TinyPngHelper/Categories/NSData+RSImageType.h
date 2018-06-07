//
//  NSData+RSImageType.h
//  TinyPngHelper
//
//  Created by User on 6/6/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RSImageDataContentType) {
    RSImageDataContentTypeNone,
    RSImageDataContentTypeJEPG,
    RSImageDataContentTypePNG,
    RSImageDataContentTypeGIF,
    RSImageDataContentTypeTiff,
    RSImageDataContentTypeWEBP,
};

@interface NSData (RSImageType)

- (RSImageDataContentType)rs_contentTypeStr:(NSString **)dataContentTypeStr;

@end
