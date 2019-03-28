//
//  NSMutableData+LGAppendingData.m
//  HTTPSocket
//
//  Created by yy on 2019/2/18.
//  Copyright © 2019年 1. All rights reserved.
//

#import "NSMutableData+LGAppendingData.h"
#import <GCDAsyncSocket.h>

@implementation NSMutableData (LGAppendingData)

- (void)appendData:(NSData *)content type:(int)type{
    [self appendData:[self totalLengthData:(int) content.length]];
    [self appendData:[self typeIDWithData:type]];
    [self appendData:content];
    [self appendData:[GCDAsyncSocket CRLFData]];
    
    
}

- (NSData *)totalLengthData:(int)contentLength{
    unsigned int totalLength = 4 + 4 + contentLength + 2;
    NSData * totalLengthData = [NSData dataWithBytes:&totalLength length:4];
    
    return totalLengthData;
}
- (NSData *)typeIDWithData:(int)type{
     unsigned int typeID = type;
    return  [NSData dataWithBytes:&typeID length:4];
}
@end
