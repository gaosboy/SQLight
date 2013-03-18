//
//  Sqlite.h
//  sqlight
//
//  Created by Jiajun.Gao on 6/23/10.
//
//		SqlightAdapter *sqlight = [[Sqlight alloc] initWithDatabase:@"test_database" AndTable:@"test_tb"];
//
//		if (nil == sqlight) {
//			sqlight = [[Sqlight alloc] initWithDatabase:@"test_database"];
//			
//			[sqlight createTable:@"test_tb" Info:[NSArray arrayWithObjects:@"f1", @"f2", nil]];
//			sqlight.tableName = @"test_tb";
//		}
//
//		[sqlight insertData:[NSDictionary dictionaryWithObjectsAndKeys:
//							 @"value1", @"f1",
//							 @"value2", @"f2",
//							 nil]];
//
//		// this is a wrong condition, there is no f0 field.
//		sqlight_result_t res = [sqlight selectFields:[NSArray arrayWithObjects:@"f1, f2", nil]
//											ByCondition:@"f0=?"
//												   Bind:[NSArray arrayWithObjects:@"value1", nil]]; 
//
//		NSLog(@"%d -- %@ -- %@", res.code, res.msg, res.data); // will out put 1 -- no such column: f0 -- ()
//
//		res = [sqlight selectFields:[NSArray arrayWithObjects:@"f1, f2", nil]
//										ByCondition:@"f1=?"
//												Bind:[NSArray arrayWithObjects:@"value1", nil]]; 
//
//		NSLog(@"%d -- %@", res.code, res.data); // will out put 101 -- ( value1, value2 )
//
//		[sqlight updateData:[NSDictionary dictionaryWithObjectsAndKeys:@"value_new", @"f1", nil]
//				ByCondition:@"f1=?"
//					   Bind:[NSArray arrayWithObjects:@"value1", nil]];
//
//		res = [sqlight selectFields:[NSArray arrayWithObjects:@"f1, f2", nil]
//										ByCondition:@"f1=?"
//													Bind:[NSArray arrayWithObjects:@"value1", nil]]; 
//
//		NSLog(@"%d -- %@", res.code, res.data); // will out put 101 -- ()
//

#import "SqlightAdapter.h"
