//
//  NSMutableData+LGAppendingData.h
//  HTTPSocket
//
//  Created by yy on 2019/2/18.
//  Copyright © 2019年 1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableData (LGAppendingData)

- (void)appendData:(NSData *)data type:(int)type;

@end

NS_ASSUME_NONNULL_END
