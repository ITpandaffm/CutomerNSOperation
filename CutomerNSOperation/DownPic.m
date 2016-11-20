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
@property (nonatomic, strong)NSMutableDictionary *filesInTmpDict;
@property (nonatomic, strong)NSString *fileStrPath;

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
        NSLog(@"在内存缓存里找到了下载过的痕迹！ 直接返回！");
        UIImage *image = self.downloadDict[strURL];
        [self.delegate downloadOperation:self didFinishDownloadPic:image];
        return;
    }
    //判断之前是否下载过（在文件缓存里面找）
    if ([self judgeImageExist:strURL])
    {
        NSLog(@"在文件缓存里找到了下载过的痕迹！ 返回啦~！");
        NSData *picData = [[NSData alloc] initWithBase64EncodedString:self.filesInTmpDict[strURL] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:picData];
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
        
        //照片存到内存缓存
        [self.downloadDict setObject:image forKey:strURL];
        
        
        //把图片转化成字符串
        NSData *picData = UIImageJPEGRepresentation(image, 1.0f);
        NSString *picStr = [picData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [self.filesInTmpDict setObject:picStr forKey:strURL];
        [self.filesInTmpDict writeToFile:self.fileStrPath atomically:YES];
    }
    
}

//在内存缓存里面查找
- (BOOL)judgeKeyExist:(NSString *)key
{
    return [[self.downloadDict allKeys] containsObject:key];
    
}

//在文件缓存存储里面查找
- (BOOL)judgeImageExist:(NSString *)imageURL
{
    return [[self.filesInTmpDict allKeys] containsObject:imageURL];
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

- (NSMutableDictionary *)filesInTmpDict
{
    if (!_filesInTmpDict)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:self.fileStrPath];
        if (dict)
        {
            _filesInTmpDict = [NSDictionary dictionaryWithDictionary:dict];
            NSLog(@"%@",[_filesInTmpDict allKeys]);
        } else
        {
            _filesInTmpDict = [NSMutableDictionary dictionary];

        }
    }
    return _filesInTmpDict;
}

- (NSString *)fileStrPath
{
    if (!_fileStrPath)
    {
        //照片存到文件缓存
        NSString *strPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
         _fileStrPath = [strPath stringByAppendingPathComponent:@"/pics.plist"];
    }
    return _fileStrPath;
}

@end
