//
//  DownPic.h
//  CutomerNSOperation
//
//  Created by ffm on 16/11/20.
//  Copyright © 2016年 ITPanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^CompleteBlock)(UIImage *);

@protocol downloadImageDelegate <NSObject>

- (void)downloadOperation:(NSOperation *)operation didFinishDownloadPic:(UIImage *)image;

@end

@interface DownPic : NSOperation


@property (nonatomic, weak) id<downloadImageDelegate> delegate;

@property (nonatomic, assign) NSInteger maxThreadConcurrentCount;
@property (nonatomic, copy) CompleteBlock completeBlock;

- (instancetype)initWithDelegate:(id<downloadImageDelegate> )delegate;

- (void)downloadPic:(NSString *)strURL;
- (void)downloadPics:(NSArray<NSString *> *)strURLArray;

@end
