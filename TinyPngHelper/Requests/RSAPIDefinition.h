//
//  APIDefnition.h
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RSRequestMethod) {
    RSRequestMethod_POST,
    RSRequestMethod_GET,
    RSRequestMethod_BINARY
};

/**
 All of the api request should follow this protocol and The @see RSHttpManager will
 accept those api request who follow this protocol only.
 */
@protocol RSAPIDefinition

/**
 The suburl address below base url address.
 
 @discussion Our base server address is api.tinify.com

 @return Sub-url
 */
- (nonnull NSString *)url;

/**
 Request type that contains post and get. Binary method is belong to post actually and
 it is used to upload binary file only.

 @return Request type
 */
- (RSRequestMethod)method;

/**
 [0] is NSData of file
 [1] is Name of file
 [2] is FileName of file
 [3] is mimeType of file

 @return Array if have mimeBody, nil otherwise
 */
- (nullable NSArray *)mimeBodies;

/**
 Request requires https or not.

 @return YES of require https, NO otherwise
 */
- (BOOL)forceHttps;

/**
 Parse response object to model.
 
 @discussion Every different request should have their own parse method cuz the response
 parameter is different.

 @param responseObject Response object of single request
 */
- (void)parseResponse:(nonnull id)responseObject;

@end
