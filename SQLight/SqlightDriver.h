//
//  SqlightDriver.h
//  sqlight
//
//  Created by Jiajun.Gao on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <sqlite3.h>
#import "SqlightResult.h"

@interface SqlightDriver : NSObject

- (id)initWithDatabase:(NSString *)database;

- (void)checkAndCreateDatabase:(NSString *)database;

- (SqlightResult*)querySql:(NSString *)sql Bind:(NSArray *)bind;

- (SqlightResult*)querySql:(NSString *)sql;

@end
