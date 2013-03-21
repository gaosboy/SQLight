SQLight
=======

SQLite封装，让SQLite操作简单的就像NSUserDefaults一样.

使用方法
=============
import SQLight的头文件 Sqlite.h

```
#import "Sqlite.h"
```

SQLight是对iOS SDK中提供的SQLite组件的一个封装。通过构造方法可以活的一个数据库或者某数据表的操作句柄（一个适配器实例），通过句柄可以对数据库进行各种操作。并以SqlightResult对象的方式返回结果，其中包括 code（sqlite默认的状态码 101表示正确完成）、msg（错误信息）和data（查询时的结果集）。

活的数据表句柄

```
SqlightAdapter *sqlight = [SqlightAdapter database:dbName AndTable:tbName];
if (nil == sqlight) { // 数据表不存在，初始化失败。创建表。
    sqlight = [SqlightAdapter database:dbName];
    [sqlight createTable:tbName Info:[NSMutableArray arrayWithObjects:
                                      @"id INTEGER PRIMARY KEY ASC",
                                      @"type INTEGER",
                                      @"style INTEGER",
                                      @"content",
                                      @"created INTEGER",
                                      nil]];
  
    sqlight.tableName = tbName;
}
```

插入数据

```
SqlightAdapter *sqlightB = [SqlightAdapter database:dbName AndTable:tbName];
SqlightResult *result = [sqlightB insertData:[NSDictionary dictionaryWithObjectsAndKeys:
                                             @"1",                  @"type",
                                             @"2",                  @"style",
                                             @"This is a Demo.",    @"content",
                                             nil]];
```

查询数据

```
SqlightAdapter *sqlightC = [SqlightAdapter database:dbName AndTable:tbName];
SqlightResult *queryResult = [sqlightC selectFields:[NSArray arrayWithObjects:@"id", @"type", @"style", @"content", nil]
                                       ByCondition:@""
                                              Bind:nil];
```

更新数据

```
SqlightAdapter *sqlightD = [SqlightAdapter database:dbName AndTable:tbName];
SqlightResult *updateResult = [sqlightD updateData:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   @"1",                  @"type",
                                                   @"20",                 @"style",
                                                   @"This is a Demo.",    @"content",
                                                   nil]
                                      ByCondition:@"type=?"
                                             Bind:[NSArray arrayWithObjects:@"1", nil]];
```

除此之外，开发者还可以通过 excuteSQL: bind: 方法直接执行SQL语句，获取SqlightResult。

具体使用方法可参考工程中的Demo
