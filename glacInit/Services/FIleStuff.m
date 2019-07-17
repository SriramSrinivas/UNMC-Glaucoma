//
//  FIleStuff.m
//  glacInit
//
//  Created by Lyle Reinholz on 7/15/19.
//  Copyright © 2019 Parshav Chauhan. All rights reserved.
//

//#import <BoxContentSDK/>

#import <Foundation/Foundation.h>
#import <BoxContentSDK/BoxContentSDK.h>
#import "FileStuff.h"
@import BoxContentSDK;

@implementation FileStuff

- (void) getFolderStuff: (BOXContentClient*)contentClient {
    //NSArray *items;
    //BOXContentClient *contentClient = [BOXContentClient defaultClient];
    
    NSString *localFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.csv"];
    BOXFileDownloadRequest *boxRequest = [contentClient fileDownloadRequestWithID:@"489481746578" toLocalFilePath:localFilePath];
    [boxRequest performRequestWithProgress:^(long long totalBytesTransferred, long long totalBytesExpectedToTransfer) {
        // Update a progress bar, etc.
    } completion:^(NSError *error) {
        // Download has completed. If it failed, error will contain reason (e.g. network connection)
    }];
    
    BOXFolderItemsRequest *folderItemsRequest = [contentClient folderItemsRequestWithID:@"0"];
    folderItemsRequest.requestAllItemFields = YES;
    folderItemsRequest.folderID = @"0";
    [folderItemsRequest performRequestWithCompletion:^(NSArray *items, NSError *error) {
        if (error == nil) {
            printf("error");
        }
        else {
            printf("success");
        }
        // If successful, items will be non-nil and contain the list of items; otherwise, error will be non-nil.
        printf("Success");
    }];
    //folderItemsRequest *truyagain =  [contentClient folder]

    //[folderItemsRequest array];
}


@end
