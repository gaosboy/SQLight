//
//  SqlightResult.m
//  Mogujie4iPhone
//
//  Created by wei huang on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SqlightResult.h"

@implementation SqlightResult

@synthesize code;
@synthesize msg;
@synthesize data;

- (id)init
{
    self = [super init];
    if (self) {
        data=[[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
