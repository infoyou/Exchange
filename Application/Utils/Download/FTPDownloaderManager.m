//
//  FTPDownloader.m
//  Project
//
//  Created by Yfeng__ on 13-11-9.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "FTPDownloaderManager.h"
#import "FTPHelper.h"
#import "KLFTPHelper.h"
#import "KLFTPAccount.h"
#import "KLFTPTransferItem.h"
#import "KLFTPTransfer.h"
#import "FileUtils.h"
#import "CommonMethod.h"


@interface FTPDownloaderManager() <FTPHelperDelegate,KLFTPTransferDelegate>

@end

@implementation FTPDownloaderManager


//id condLock = [[NSConditionLock alloc] initWithCondition:NO_DATA]
static FTPDownloaderManager *instance = nil;

+ (FTPDownloaderManager *)instance {
    
    @synchronized(self) {
        if(instance == nil) {
            instance = [[super allocWithZone:NULL] init];
            [instance initData];
        }
    }
    
    return instance;
}

-(void)dealloc
{
    [_listenerArray release];
    [_defaultFTPAccount release];
    [_defaultFTPAccount release];
    [_downloadInfoDict release];
    [super dealloc];
}

- (void)initData
{
    _listenerArray = [[NSMutableArray alloc] init];
   _transferListDict = [[NSMutableDictionary alloc] init];
    _defaultFTPAccount = [[KLFTPAccount alloc] init];
    _downloadInfoDict = [[NSMutableDictionary alloc] init];
}

#pragma mark -- listener

- (void)registerListener:(id)listener
{
    @synchronized(self) {
        for (id lis in self.listenerArray) {
            if (lis == listener) {
                return;
            }
        }
        
        [self.listenerArray addObject:listener];
    }
}

- (void)unRegisterListener:(id)listener
{
    @synchronized(self) {
        for (id lis in _listenerArray) {
            if (lis == listener) {
                [self.listenerArray removeObject:listener];
                break;
            }
        }
    }
}

- (NSURL *)localFileURLForRemoteFileName:(NSString *)fileName {
    
    @synchronized(self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString * urlStr = [[paths lastObject] stringByAppendingPathComponent:fileName];
        return [NSURL fileURLWithPath:urlStr];
    }
}

-(KLFTPTransferItem *)getTransferItem:(DownloadInfo *)downloadInfo
{
    @synchronized(self) {
        NSString *downloadURLStr = [downloadInfo.downloadPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL * ftpDownloadURL = [NSURL URLWithString:downloadURLStr];
        NSURL *  localUrl = [NSURL fileURLWithPath:downloadInfo.localPath];// [self localFileURLForRemoteFileName:[ftpDownloadURL lastPathComponent]];
        DLog(@"%@",[downloadInfo.localPath stringByDeletingLastPathComponent]);
        [FileUtils mkdir:[downloadInfo.localPath stringByDeletingLastPathComponent]];
        
        KLFTPTransferItem * downloadItem = [[[KLFTPTransferItem alloc] init] autorelease];
        [downloadItem setSrcURL:ftpDownloadURL];
        [downloadItem setDestURL:localUrl];
        [downloadItem setFileSize:172534528];
        
        if (!downloadInfo.userName || !downloadInfo.password) {
            [downloadItem setAccount:[FTPDownloaderManager instance].defaultFTPAccount];
        }else {
            KLFTPAccount * account = [[[KLFTPAccount alloc] init] autorelease];
            [account setUserName:downloadInfo.userName];
            [account setPassword:downloadInfo.password];
            
            [downloadItem setAccount:account];
        }
        
        return downloadItem;
    }
}

-(KLFTPTransfer *)getTransferByItem:(KLFTPTransferItem *)transferItem
{
    @synchronized(self) {
        KLFTPTransfer *itemTransfer = [KLFTPTransfer transferWithItem:transferItem];
        [itemTransfer setTransferItem:transferItem];
        [itemTransfer setDelegate:self];
        
        return itemTransfer;
    }
}

- (KLFTPTransfer *)getTransferByDownloadInfo:(DownloadInfo *)downloadInfo
{
    @synchronized(self) {
        KLFTPTransfer *transfer = [self.transferListDict objectForKey:downloadInfo.uniqueKey];
        if (!transfer) {
            KLFTPTransferItem *item = [self getTransferItem:downloadInfo];
            transfer =   [instance getTransferByItem: item];
            
            if (transfer)
            {
                
                [self.transferListDict setObject:transfer forKey:downloadInfo.uniqueKey];
                [self.downloadInfoDict setObject:downloadInfo forKey:downloadInfo.uniqueKey];
            }
        }
        
        return transfer;
    }
}

- (DownloadInfo *)getDownloadInfoByUniqueKey:(NSString *)uniqueKey
{
    @synchronized(self) {
        return [self.downloadInfoDict objectForKey:uniqueKey];
    }
}

- (NSMutableDictionary *)getAllDownloadingChapter
{
    return self.downloadInfoDict;
}

-(BOOL)isDownloading:(KLFTPTransfer *)transfer
{
    
}

//当传输状态发生改变时(开始，暂停，停止，完成...)的代理方法
- (void)klFTPTransfer:(KLFTPTransfer *)transfer transferStateDidChangedForItem:(KLFTPTransferItem *)item error:(NSError *)error
{
    @synchronized(self) {
        DLog(@"%d", item.transferState);
        
        //        if (item.transferState == KLFTPTransferStateFinished) {
        //            [self.transferListDict removeObjectForKey:@""];
        //        }
        
        for (id lis in _listenerArray) {
            [lis klFTPTransfer:transfer transferStateDidChangedForItem:item error:error];
        }
    }
}

//传输进度发生改变时的回调
- (void)klFTPTransfer:(KLFTPTransfer *)transfer progressChangedForItem:(KLFTPTransferItem *)item
{
    @synchronized(self) {
        CGFloat percent = item.finishedSize/(CGFloat)item.fileSize;
        NSString * des = [NSString stringWithFormat:@"%@",item.itemName];
        DLog(@"%@:%.4f", des, percent);
        
        
        for (id lis in _listenerArray) {
            [lis klFTPTransfer:transfer progressChangedForItem:item];
        }
    }
}
@end
