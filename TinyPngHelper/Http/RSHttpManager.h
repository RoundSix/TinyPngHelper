//
//  RSHttpManager.h
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
#import "RSError.h"
#import "RSRequest.h"
#import "RSAPIDefinition.h"

@interface RSHttpManager : NSObject

/**
 <#Description#>

 @param request <#request description#>
 @return <#return value description#>
 */
+ (NSURLSessionTask *)postRequest:(RSRequest<RSAPIDefinition> *)request;

+ (NSURLSessionTask *)postRequest:(RSRequest<RSAPIDefinition> *)request
                     successBlock:(void (^)(void))successBlock
                   rawFailedBlock:(void (^)(RSError *error))rawFailedBlock
                  completionBlock:(void (^)(void))completionBlock;

+ (NSURLSessionTask *)downloadFromUrlString:(NSString *)urlString
                            destinationPath:(NSURL *)destination
                                   progress:(void (^)(NSProgress *progress))progressHandler
                             successHandler:(void (^)(void))successHandler
                              failedHandler:(void (^)(RSError *error))failedHandler;

+ (NSURLSessionTask *)downloadFromUrl:(NSURL *)url
                      destinationPath:(NSURL *)destination
                             progress:(void (^)(NSProgress *progress))progressHandler
                       successHandler:(void (^)(void))successHandler
                        failedHandler:(void (^)(RSError *error))failedHandler;

@end
