//
//  sqlightDriver.m
//  sqlight
//
//  Created by Jiajun.Gao on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SqlightDriver.h"

@implementation SqlightDriver

- (id)initWithDatabase:(NSString *)database {
	if (self = [super init]) {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [[documentPaths objectAtIndex:0] stringByAppendingString:@"/MomDB/"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        databasePath = [documentsDir stringByAppendingPathComponent:database];
        
		[self checkAndCreateDatabase:database];
		if(SQLITE_OK == sqlite3_open([databasePath UTF8String], &dbHandler)) {
			return self;
		}
		else {
			return nil;
		}
	}
	return nil;
}

- (void)checkAndCreateDatabase:(NSString *)database {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(! [fileManager fileExistsAtPath:databasePath]) {
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:database];
		[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	}
}

- (SqlightResult*)querySql:(NSString *)sql Bind:(NSArray *)bind {
    SqlightResult* res = [[SqlightResult alloc] init];

	sqlite3_stmt *compiledStatement;

	const char *sqlStatement = [[NSString stringWithString:sql] UTF8String];
	res.code = sqlite3_prepare_v2(dbHandler, sqlStatement, -1, &compiledStatement, NULL);
	if(SQLITE_OK != res.code) {
		res.msg = [NSString stringWithUTF8String:sqlite3_errmsg(dbHandler)];
		return res;
	}

	if (nil != bind) {
		for (int i = 0; i < [bind count]; i ++) {
			sqlite3_bind_text(compiledStatement,
                              i + 1,
                              [[NSString stringWithFormat:@"%@", [bind objectAtIndex:i]] UTF8String],
                              -1,
                              SQLITE_TRANSIENT);
		}
	}
	while ((res.code = sqlite3_step(compiledStatement)) && SQLITE_DONE != res.code && SQLITE_ROW == res.code) {
		NSMutableArray *rowData = [[NSMutableArray alloc] init];

		int columnNum = sqlite3_column_count(compiledStatement);
		for (int i = 0; i < columnNum; i ++) {
			if (NULL != (char *)sqlite3_column_text(compiledStatement, i)) {
				[rowData addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)]];
			}
			else {
				[rowData addObject:@""];
			}
		}
		[res.data addObject:rowData];
	}

	sqlite3_reset(compiledStatement);

	return res;
}

- (SqlightResult*)querySql:(NSString *)sql {
	SqlightResult* res = [[SqlightResult alloc] init];
	
	sqlite3_stmt *compiledStatement;
	const char *sqlStatement = [[NSString stringWithString:sql] UTF8String];

	res.code = sqlite3_prepare_v2(dbHandler, sqlStatement, -1, &compiledStatement, NULL);
	if(SQLITE_OK != res.code) {
		res.msg = [NSString stringWithUTF8String:sqlite3_errmsg(dbHandler)];
		return res;
	}	

	while ((res.code = sqlite3_step(compiledStatement)) && SQLITE_DONE != res.code && SQLITE_ROW == res.code) {
		NSMutableArray *rowData = [[NSMutableArray alloc] init];
		
		int columnNum = sqlite3_column_count(compiledStatement);
		for (int i = 0; i < columnNum; i ++) {
			if (NULL != (char *)sqlite3_column_text(compiledStatement, i)) {
				[rowData addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, i)]];
			}
			else {
				[rowData addObject:@""];
			}
		}

		[res.data addObject:rowData];
	}
	
	sqlite3_reset(compiledStatement);
	
	return res;
}

@end
