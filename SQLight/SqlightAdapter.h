//
//  SqlightAdapter.h
//
//  Created by Jiajun.Gao on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SqlightDriver.h"

@interface SqlightAdapter : NSObject {
	NSString *databaseName;
	
	NSString *tableName;

	SqlightDriver *sqlightDrv;
}

+ (id)database:(NSString *)database;
+ (id)database:(NSString *)database AndTable:(NSString *)table;

- (SqlightResult*) selectFields:(NSArray *)fields ByCondition:(NSString *)sql Bind:(NSArray *)bind;

- (SqlightResult*) insertData:(NSDictionary *)data;

- (SqlightResult*) updateData:(NSDictionary *)data ByCondition:(NSString *)sql Bind:(NSArray *)bind;

- (SqlightResult*) deleteByCondition:(NSString *)sql Bind:(NSArray *)bind;

- (SqlightResult*) createTable:(NSString *)table Info:(NSArray *)info;

- (SqlightResult*) dropTable:(NSString *)table;

- (SqlightResult *)excuteSQL:(NSString *)aSQL bind:(NSArray *)aBind;

@property(nonatomic, strong) NSString *databaseName;
@property(nonatomic, strong) NSString *tableName;

@end
