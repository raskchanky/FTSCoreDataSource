//
//  FTSCoreDataSource.h
//
//  Created by Josh Black on 10/18/13.
//  Copyright (c) 2013 Fat Toad Software, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

@interface FTSCoreDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic) BOOL sortAscending;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                         tableView:(UITableView *)tableView
                        entityName:(NSString *)entityName
                           sortKey:(NSString *)sortKey
                         cacheName:(NSString *)cacheName
                    cellIdentifier:(NSString *)cellIdentifier
                configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
@end
