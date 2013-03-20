//
//  SqlightResult.m
//  Mogujie4iPhone
//
//  Created by wei huang on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SqlightResult.h"

@interface SqlightResult ()

@end

@implementation SqlightResult

@synthesize code        = _code;
@synthesize msg         = _msg;
@synthesize data        = _data;

- (id)init
{
    self = [super init];
    if (self) {
        self.data=[[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
