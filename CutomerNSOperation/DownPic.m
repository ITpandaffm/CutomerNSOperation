//
//  DownPic.m
//  CutomerNSOperation
//
//  Created by ffm on 16/11/20.
//  Copyright © 2016年 ITPanda. All rights reserved.
//

#import "DownPic.h"

@interface DownPic ()

@property (nonatomic, strong)NSOperationQueue *queue;
@property (nonatomic, strong)NSMutableDictionary *downloadDict;
@end

@implementation DownPic


- (instancetype)initWithDelegate:(id<downloadImageDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
    }
    return self;
}

- (void)downloadPic:(NSString *)strURL
{
    //判断之前是否有下载过
    if ([self judgeKeyExist:strURL])
    {
        NSLog(@"之前已经下载过啦！ 直接返回！");
        UIImage *image = self.downloadDict[strURL];
        [self.delegate downloadOperation:self didFinishDownloadPic:image];
        return;
    }
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadPicByURL:) object:strURL];
    [self.queue setMaxConcurrentOperationCount:self.maxThreadConcurrentCount];
    
    [self.queue addOperation:operation];
}

- (void)downloadPics:(NSArray<NSString *> *)strURLArray
{
    for (NSString *strURL in strURLArray)
    {
        [self downloadPic:strURL];
    }
}

- (void)downloadPicByURL:(NSString *)strURL
{
    NSURL *url = [NSURL URLWithString:strURL];
    NSData *data  = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    if (self.completeBlock)
    {
        self.completeBlock(image);
    }
    if ([self.delegate respondsToSelector:@selector(downloadOperation:didFinishDownloadPic:)])
    {
        NSLog(@"%@", [NSThread currentThread]);
        [self.delegate downloadOperation:self didFinishDownloadPic:image];
        [self.downloadDict setObject:image forKey:strURL];
    }
    
}

- (BOOL)judgeKeyExist:(NSString *)key
{
    NSLog(@"%@",[self.downloadDict allKeys]);
    return [[self.downloadDict allKeys] containsObject:key];
    
}
#pragma mark 懒加载
- (NSOperationQueue *)queue
{
    if (!_queue)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSMutableDictionary *)downloadDict
{
    if (!_downloadDict)
    {
        _downloadDict = [NSMutableDictionary dictionary];
    }
    return _downloadDict;
}

@end
