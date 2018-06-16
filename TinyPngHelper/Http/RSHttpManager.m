//
//  RSHttpManager.m
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

#import "RSHttpManager.h"
/****** Vendors ******/
#import <AFNetworking.h>
#import "NSString+Base64.h"

@implementation RSHttpManager

static NSString* baseServerAddress = @"api.tinify.com";

+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [AFHTTPSessionManager manager];
            instance.requestSerializer.timeoutInterval = 30.0f;
            instance.securityPolicy.allowInvalidCertificates = YES;
            instance.securityPolicy.validatesDomainName = NO;
        }
    });
    
    return instance;
}

#pragma mark - Public methods

+ (NSURLSessionTask *)postRequest:(RSRequest<RSAPIDefinition> *)request {
    return [self postRequest:request successBlock:nil rawFailedBlock:nil completionBlock:nil];
}

+ (NSURLSessionTask *)postRequest:(RSRequest<RSAPIDefinition> *)request
                     successBlock:(void (^)(void))successBlock
                   rawFailedBlock:(void (^)(RSError *))rawFailedBlock
                  completionBlock:(void (^)(void))completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", request.forceHttps ? @"https://" : @"http://", baseServerAddress, request.url];
    NSString *assembledApikey = [NSString stringWithFormat:@"api:%@", request.apiKey];
    NSString *base64Key = [assembledApikey encodedString];
    NSString *basicValue = [NSString stringWithFormat:@"Basic %@", base64Key];
    AFHTTPSessionManager *manager = [self sharedManager];
    
    switch (request.method) {
        case RSRequestMethod_POST:
            return [self handlePostWithManager:manager
                                           url:url
                                       request:request
                                  successBlock:successBlock
                                rawFailedBlock:rawFailedBlock
                               completionBlock:completionBlock];
            break;
        case RSRequestMethod_GET:
            return [self handleGetWithManager:manager
                                          url:url
                                      request:request
                                 successBlock:successBlock
                               rawFailedBlock:rawFailedBlock
                              completionBlock:completionBlock];
            break;
        case RSRequestMethod_BINARY:
            return [self handleBinaryWithManager:manager
                                             url:url
                                      authHeader:basicValue
                                         request:request
                                    successBlock:successBlock
                                  rawFailedBlock:rawFailedBlock
                                 completionBlock:completionBlock];
            break;
        default:
            break;
    }
}

+ (NSURLSessionTask *)downloadFromUrlString:(NSString *)urlString
                            destinationPath:(NSURL *)destination
                                   progress:(void (^)(NSProgress *))progressHandler
                             successHandler:(void (^)(void))successHandler
                              failedHandler:(void (^)(RSError *))failedHandler
{
    NSURL *url = [NSURL URLWithString:urlString];
    return [self downloadFromUrl:url
                 destinationPath:destination
                        progress:progressHandler
                  successHandler:successHandler
                   failedHandler:failedHandler];
}

+ (NSURLSessionTask *)downloadFromUrl:(NSURL *)url
                      destinationPath:(NSURL *)destination
                             progress:(void (^)(NSProgress *))progressHandler
                       successHandler:(void (^)(void))successHandler
                        failedHandler:(void (^)(RSError *))failedHandler
{
    AFHTTPSessionManager *manager = [self sharedManager];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressHandler) {
            progressHandler(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return destination;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failedHandler) {
                failedHandler([RSError initWithError:error]);
            }
        } else {
            if (successHandler) {
                successHandler();
            }
        }
    }];
    
    [downloadTask resume];
    return downloadTask;
}

#pragma mark - Internal

+ (NSURLSessionTask *)handlePostWithManager:(AFHTTPSessionManager *)manager
                                        url:(NSString *)url
                                    request:(RSRequest<RSAPIDefinition> *)request
                               successBlock:(void (^)(void))successBlock
                             rawFailedBlock:(void (^)(RSError *))rawFailedBlock
                            completionBlock:(void (^)(void))completionBlock
{
    return [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSArray *mimeBodies = request.mimeBodies;
        if (mimeBodies) {
            [formData appendPartWithFileData:mimeBodies[0]
                                        name:mimeBodies[1]
                                    fileName:mimeBodies[2]
                                    mimeType:mimeBodies[3]];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccessResponse:responseObject
                            request:request
                            success:successBlock
                          rawFailed:rawFailedBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFailedResponse:error rawFailed:rawFailedBlock];
    }];
}

+ (NSURLSessionTask *)handleBinaryWithManager:(AFHTTPSessionManager *)manager
                                          url:(NSString *)url
                                   authHeader:(NSString *)authHeader
                                      request:(RSRequest<RSAPIDefinition> *)request
                                 successBlock:(void (^)(void))successBlock
                               rawFailedBlock:(void (^)(RSError *))rawFailedBlock
                              completionBlock:(void (^)(void))completionBlock
{
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = [request mimeBodies].firstObject;
    [urlRequest setValue:authHeader forHTTPHeaderField:@"Authorization"];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:urlRequest
                                               uploadProgress:nil
                                             downloadProgress:nil
                                            completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
                                  {
                                      if (error) {
                                          [self handleFailedResponse:error rawFailed:rawFailedBlock];
                                      } else {
                                          [self handleSuccessResponse:responseObject
                                                              request:request
                                                              success:successBlock
                                                            rawFailed:rawFailedBlock];
                                      }
                                  }];
    [task resume];
    return task;
}

+ (NSURLSessionTask *)handleGetWithManager:(AFHTTPSessionManager *)manager
                                       url:(NSString *)url
                                   request:(RSRequest<RSAPIDefinition> *)request
                              successBlock:(void (^)(void))successBlock
                            rawFailedBlock:(void (^)(RSError *))rawFailedBlock
                           completionBlock:(void (^)(void))completionBlock
{
    return [manager GET:url
             parameters:nil
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
            {
                [self handleSuccessResponse:responseObject
                                    request:request
                                    success:successBlock
                                  rawFailed:rawFailedBlock];
            }
                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
            {
                [self handleFailedResponse:error rawFailed:rawFailedBlock];
            }];
}

+ (NSString *)assembleUrlWithRequest:(RSRequest<RSAPIDefinition> *)request {
    return [NSString stringWithFormat:@"%@%@/%@", request.forceHttps ? @"https://" : @"http://", baseServerAddress, request.url];
}

+ (void)handleSuccessResponse:(id _Nullable)responseObject
                      request:(RSRequest<RSAPIDefinition> *)request
                      success:(void (^)(void))success
                    rawFailed:(void (^)(RSError *))rawFailed
{
    if ([responseObject objectForKey:@"error"]) { // means error
        RSError *rsError = [RSError initWithJsonObject:responseObject];
        if (rawFailed) {
            rawFailed(rsError);
        }
    } else { // means success
        [request parseResponse:responseObject];
        if (success) {
            success();
        }
    }
}

+ (void)handleFailedResponse:(NSError *)error rawFailed:(void (^)(RSError *))rawFailed {
    RSError *rsError = [RSError initWithError:error];
    if (rawFailed) {
        rawFailed(rsError);
    }
}

@end
