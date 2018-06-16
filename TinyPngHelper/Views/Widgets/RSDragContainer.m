//
//  RSDragContainer.m
//  TinyPngHelper
//
//  Created by lumeng on 6/11/18.
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

#import "RSDragContainer.h"

@interface RSDragContainer() {
    NSArray *acceptTypes;
}

@end

@implementation RSDragContainer

- (instancetype)init {
    self = [super init];
    if (self) {
        acceptTypes = [NSArray arrayWithObjects:@"png", @"jpg", @"jpeg", nil];
        NSMutableArray<NSPasteboardType> *draggedTypes = [NSMutableArray array];
        
        if (@available(macOS 10.13, *)) {
            [draggedTypes addObject:NSPasteboardTypeFileURL];
        } else {
            [draggedTypes addObject:(NSString *)kUTTypeFileURL];
        }
        [draggedTypes addObject:(NSString *)kUTTypeItem];
        
        [self registerForDraggedTypes:draggedTypes];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    self.layer.backgroundColor = RSColorFromRGBA(0xffffff, 0.2).CGColor;
    
    if (_delegate) {
        [_delegate draggingEntered];
    }
    
    BOOL accessableFiles = [self haveAccessableFiles:sender];
    if (accessableFiles) {
        return NSDragOperationGeneric;
    }
    
    return NSDragOperationNone;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    self.layer.backgroundColor = RSColorFromRGBA(0xffffff, 0).CGColor;
    
    if (_delegate) {
        [_delegate draggingExist];
    }
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    self.layer.backgroundColor = RSColorFromRGBA(0xffffff, 0).CGColor;
    
    return YES;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    if (_delegate) {
        NSMutableArray<NSURL *> *fileUrls = [NSMutableArray array];
        NSArray *board = [sender.draggingPasteboard propertyListForType:NSFilenamesPboardType];
        for (NSString *path in board) {
            NSURL *url = [NSURL fileURLWithPath:path];
            NSString *fileExtension = url.pathExtension.lowercaseString;
            if ([acceptTypes containsObject:fileExtension]) {
                [fileUrls addObject:url];
            }
        }
        
        [_delegate draggingFileAccept:fileUrls];
    }
    
    return YES;
}

- (BOOL)haveAccessableFiles:(id<NSDraggingInfo>)sender {
    NSArray *board = [sender.draggingPasteboard propertyListForType:NSFilenamesPboardType];
    for (NSString *path in board) {
        NSURL *url = [NSURL fileURLWithPath:path];
        NSString *fileExtension = url.pathExtension.lowercaseString;
        if ([acceptTypes containsObject:fileExtension]) {
            return YES;
        }
    }
    return NO;
}

@end
