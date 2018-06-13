//
//  RSCompressRequest.m
//  TinyPngHelper
//
//  Created by lumeng on 5/17/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "RSCompressRequest.h"
#import <AppKit/AppKit.h>
#import "NSData+RSImageType.h"

@implementation Input
@end

@implementation Output
@end

@interface RSCompressRequest()

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong, nullable) NSData *fileData;

@end

@implementation RSCompressRequest

- (instancetype)initWithImage:(NSImage *)image {
    if (self = [super init]) {
        @autoreleasepool {
            NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
            _fileData = [imageRep representationUsingType:NSBitmapImageFileTypePNG properties:@{NSImageInterlaced : @YES}];
        }
    }
    return self;
}

- (NSString *)url {
    return @"shrink";
}

- (RSRequestMethod)method {
    return RSRequestMethod_BINARY;
}

- (BOOL)forceHttps {
    return YES;
}

- (NSArray *)mimeBodies {
    NSArray *tempArray;
    if (_fileData) {
        //TODO: 文件名称可配置
        _fileName = @"file";
        NSString *imageContentTypeStr = nil;
        NSArray *fileStrsArray = @[
                                   @"",
                                   @".jpg",
                                   @".png",
                                   @".gif",
                                   @".tiff",
                                   @".webp",
                                   ];
        RSImageDataContentType imageDataContentType = [_fileData rs_contentTypeStr:&imageContentTypeStr];
        NSString *fileStr = [_fileName stringByAppendingString:fileStrsArray[imageDataContentType]];
        if (imageContentTypeStr == nil) {
            imageContentTypeStr = @"";
        }
        tempArray = @[_fileData, @"file", fileStr, imageContentTypeStr];
    }
    return tempArray;
}

- (void)parseResponse:(id)responseObject {
    id input = [responseObject objectForKey:@"input"];
    id output = [responseObject objectForKey:@"output"];
    
    _input = [Input new];
    _input.size = [input objectForKey:@"size"];
    _input.type = [input objectForKey:@"type"];
    
    _output = [Output new];
    _output.size = [output objectForKey:@"size"];
    _output.type = [output objectForKey:@"type"];
    _output.width = [output objectForKey:@"width"];
    _output.height = [output objectForKey:@"height"];
    _output.ratio = [[output objectForKey:@"ratio"] floatValue];
    _output.url = [output objectForKey:@"url"];
}
@end
