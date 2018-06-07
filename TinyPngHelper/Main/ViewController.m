//
//  ViewController.m
//  TinyPngHelper
//
//  Created by lumeng on 5/17/18.
//  Copyright © 2018 roundsix. All rights reserved.
//

#import "ViewController.h"
#import "RSHttpManager.h"
#import "RSCompressRequest.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RSCompressRequest *request = [[RSCompressRequest alloc] initWithImage:[NSImage imageNamed:@"launchImage-Protrait~iPad"]];
    [RSHttpManager postRequest:request successBlock:^{
        
    } rawFailedBlock:^(RSError *error) {
        
    } completionBlock:^{
        
    }];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    
}



@end
