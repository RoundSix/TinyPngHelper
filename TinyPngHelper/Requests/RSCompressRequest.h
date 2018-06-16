//
//  RSCompressRequest.h
//  TinyPngHelper
//
//  Created by lumeng on 5/17/18.
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

#import "RSRequest.h"
#import "RSAPIDefinition.h"

@class NSImage;
@interface Input : NSObject

@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, copy) NSString *type;

@end

@interface Output : NSObject

@property (nonatomic, strong) NSNumber *size;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSNumber *width;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, assign) float ratio;
@property (nonatomic, copy) NSString *url;

@end

@interface RSCompressRequest : RSRequest <RSAPIDefinition>

@property (nonatomic, strong, readonly) Input *input;
@property (nonatomic, strong, readonly) Output *output;

RS_INIT_UNAVAILABLE

- (instancetype)initWithImage:(NSImage *)image;

@end
