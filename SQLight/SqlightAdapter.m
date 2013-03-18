//
//  sqlightAdapter.m
//  sqlight
//
//  Created by Jiajun.Gao on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SqlightAdapter.h"

@implementation SqlightAdapter

@synthesize databaseName;
@synthesize tableName;

- (id)initWithDatabase:(NSString *)database {
    self = [super init];
	if (self) {
		[self setDatabaseName:database];
		sqlightDrv = [[SqlightDriver alloc] initWithDatabase:databaseName];
	}
	return self;
}

- (id)initWithDatabase:(NSString *)database AndTable:(NSString *)table {
	self = [[SqlightAdapter alloc] initWithDatabase:database];
	if (self) {
		[self setTableName:table];
		SqlightResult* res = [self selectFields:[NSMutableArray arrayWithObjects:@"1", nil] ByCondition:@"" Bind:nil];
		if (SQLITE_ERROR == res.code) {
			return nil;
		}
		return self;
	}
	return nil;
}

- (SqlightResult *)excuteSQL:(NSString *)aSQL bind:(NSArray *)aBind {
    if (nil == aBind || 0 >= [aBind count]) {
        return [sqlightDrv querySql:aSQL];
    }
    else {
        return [sqlightDrv querySql:aSQL Bind:aBind];
    }
}

- (SqlightResult*)selectFields:(NSArray *)fields ByCondition:(NSString *)condition Bind:(NSArray *)bind {
	NSString *fieldsString = @"";
	for (int i = 0; i < [fields count]; i ++) {
		fieldsString = [fieldsString stringByAppendingString:[fields objectAtIndex:i]];
		fieldsString = [fieldsString stringByAppendingString:@","];
	}
	fieldsString = [fieldsString substringToIndex:[fieldsString length] - 1];
	NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldsString, tableName];
	if (condition && 0 < [condition length]) {
		sql = [sql stringByAppendingFormat:@" WHERE %@", condition];
	}

	return [self excuteSQL:sql bind:bind];
}

- (SqlightResult*)insertData:(NSDictionary *)data {
	NSArray *keys = [data allKeys];
	NSMutableArray *bind = [[NSMutableArray alloc] init];
	
	NSString *fields = @"";
	NSString *values = @"";
	
	for (NSString *key in keys) {
		fields = [fields stringByAppendingString:key];
		fields = [fields stringByAppendingString:@","];
		values = [values stringByAppendingString:@"?,"];
		
		[bind addObject:[data objectForKey:key]];
	}
	fields = [fields substringToIndex:[fields length] - 1];
	values = [values substringToIndex:[values length] - 1];
	
 	NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, fields, values];

    return [self excuteSQL:sql bind:bind];
}

- (SqlightResult*)updateData:(NSDictionary *)data ByCondition:(NSString *)condition Bind:(NSArray *)bind {
	NSArray *keys = [data allKeys];
	NSMutableArray *newBind = [[NSMutableArray alloc] init];
	NSString *fields = @"";
	
	for (NSString *key in keys) {
		fields = [fields stringByAppendingString:key];
		fields = [fields stringByAppendingString:@"=? ,"];
        [newBind addObject:[data objectForKey:key]];
	}
	fields = [fields substringToIndex:[fields length] - 1];
    [newBind addObjectsFromArray:bind];
	
 	NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@", tableName, fields];
    if (condition && 0 < [condition length]) {
		sql = [sql stringByAppendingFormat:@" WHERE %@", condition];
	}

	return [sqlightDrv querySql:sql Bind:newBind];
}

- (SqlightResult*)deleteByCondition:(NSString *)condition Bind:(NSMutableArray *)bind {
    
 	NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];

    if (condition && 0 < [condition length]) {
		sql = [sql stringByAppendingFormat:@" WHERE %@", condition];
	}

	return [self excuteSQL:sql bind:bind];
}

- (SqlightResult*)createTable:(NSString *)table Info:(NSArray *)info {
	NSString *fields = @"";
	for (NSString *key in info) {
		fields = [fields stringByAppendingString:key];
		fields = [fields stringByAppendingString:@","];
	}
	fields = [fields substringToIndex:[fields length] - 1];
	NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)", table, fields];
	return [sqlightDrv querySql:sql];
}

- (SqlightResult*)dropTable:(NSString *)table {
	NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@ ", table];

    return [self excuteSQL:sql bind:nil];
}

@end
