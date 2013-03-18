//
//  SqlightDriver.h
//  sqlight
//
//  Created by Jiajun.Gao on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <sqlite3.h>
#import "SqlightResult.h"

@interface SqlightDriver : NSObject {
	NSString *databasePath; // path of the database file
	sqlite3 *dbHandler; // database handler
}

- (id)initWithDatabase:(NSString *)database;

- (void)checkAndCreateDatabase:(NSString *)database;

- (SqlightResult*)querySql:(NSString *)sql Bind:(NSArray *)bind;

- (SqlightResult*)querySql:(NSString *)sql;

@end
