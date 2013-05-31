//
//  sqlightAdapter.m
//  sqlight
//
//  Created by Jiajun.Gao on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SqlightAdapter.h"

@interface SqlightAdapter ()

@property (nonatomic, strong)   NSString        *databaseName;
@property (strong, nonatomic)   SqlightDriver   *sqlightDrv;

@end

@implementation SqlightAdapter

@synthesize databaseName        = _databaseName;
@synthesize tableName           = _tableName;
@synthesize sqlightDrv          = _sqlightDrv;

#pragma mark - Public

- (SqlightResult *)excuteSQL:(NSString *)aSQL bind:(NSArray *)aBind {
    if (nil == aBind || 0 >= [aBind count]) {
        return [self.sqlightDrv querySql:aSQL];
    }
    else {
        return [self.sqlightDrv querySql:aSQL Bind:aBind];
    }
}

- (SqlightResult*)selectFields:(NSArray *)fields ByCondition:(NSString *)condition Bind:(NSArray *)bind {
	NSString *fieldsString = @"";
	for (int i = 0; i < [fields count]; i ++) {
		fieldsString = [fieldsString stringByAppendingString:[fields objectAtIndex:i]];
		fieldsString = [fieldsString stringByAppendingString:@","];
	}
	fieldsString = [fieldsString substringToIndex:[fieldsString length] - 1];
	NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldsString, self.tableName];
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
	
 	NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", self.tableName, fields, values];

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
	
 	NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@", self.tableName, fields];
    if (condition && 0 < [condition length]) {
		sql = [sql stringByAppendingFormat:@" WHERE %@", condition];
	}

	return [self.sqlightDrv querySql:sql Bind:newBind];
}

- (SqlightResult*)deleteByCondition:(NSString *)condition Bind:(NSMutableArray *)bind {
    
 	NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", self.tableName];

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
	return [self.sqlightDrv querySql:sql];
}

- (SqlightResult*)dropTable:(NSString *)table {
	NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@ ", table];

    return [self excuteSQL:sql bind:nil];
}

- (id)initWithDatabase:(NSString *)database {
    self = [super init];
	if (self) {
        self.databaseName = database;
		self.sqlightDrv = [[SqlightDriver alloc] initWithDatabase:database];
	}
	return self;
}

- (id)initWithDatabase:(NSString *)database AndTable:(NSString *)table {
	self = [[SqlightAdapter alloc] initWithDatabase:database];
	if (self) {
        self.tableName = table;
		SqlightResult* res = [self selectFields:[NSMutableArray arrayWithObjects:@"1", nil] ByCondition:@"" Bind:nil];
        if (SQLITE_DONE != res.code) {
			return nil;
		}
	}
	return self;
}

#pragma mark - Static

+ (id)database:(NSString *)database
{
    static dispatch_once_t once_token;
    static NSMutableDictionary *handlePool;
    dispatch_once(&once_token, ^{
        handlePool = [[NSMutableDictionary alloc] init];
    });
    
    if ([[handlePool allKeys] containsObject:database] && [handlePool objectForKey:database]) {
    }
    else {
        SqlightAdapter *obj = [[SqlightAdapter alloc] initWithDatabase:database];
        [handlePool setValue:obj forKey:database];
    }
    return [handlePool objectForKey:database];
}

+ (id)database:(NSString *)database AndTable:(NSString *)table
{
    static dispatch_once_t once_token;
    static NSMutableDictionary *handlePool;
    dispatch_once(&once_token, ^{
        handlePool = [[NSMutableDictionary alloc] init];
    });
    
    NSString *token = [database stringByAppendingPathExtension:table];
    if (! [[handlePool allKeys] containsObject:token] || nil == [handlePool objectForKey:token]) {
        SqlightAdapter *obj = [[SqlightAdapter alloc] initWithDatabase:database];
        [obj setTableName:table];
        SqlightResult* res = [obj selectFields:[NSMutableArray arrayWithObjects:@"1", nil]
                                                               ByCondition:@"" Bind:nil];
        if (SQLITE_DONE == res.code) {
            [handlePool setValue:obj forKey:token];
        }
        else {
            return nil;
        }
    }
    return [handlePool objectForKey:token];
}

@end
