//
//  FTSCoreDataSource.m
//
//  Created by Josh Black on 10/18/13.
//  Copyright (c) 2013 Fat Toad Software, Inc. All rights reserved.
//

#import "FTSCoreDataSource.h"

@interface FTSCoreDataSource()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *entityName;
@property (nonatomic, copy) NSString *sortKey;
@property (nonatomic, copy) NSString *cacheName;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation FTSCoreDataSource

#pragma mark Initializers

- (id)init
{
    return nil;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
                         tableView:(UITableView *)tableView
                        entityName:(NSString *)entityName
                           sortKey:(NSString *)sortKey
                         cacheName:(NSString *)cacheName
                    cellIdentifier:(NSString *)cellIdentifier
                configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
{
    self = [super init];

    if (self) {
        self.managedObjectContext = managedObjectContext;
        self.tableView = tableView;
        self.entityName = entityName;
        self.sortKey = sortKey;
        self.cacheName = cacheName;
        self.cellIdentifier = cellIdentifier;
        self.configureCellBlock = configureCellBlock;
        self.sortAscending = YES;
        self.fetchedResultsController = [self setupFetchedResultsController];
    }

    [self addObserver:self forKeyPath:@"sortAscending" options:NSKeyValueObservingOptionNew context:NULL];
    [self performFetch];

    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"sortAscending"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"sortAscending"]) {
        [self assignSortDescriptorsToFetchRequest:self.fetchedResultsController.fetchRequest];
        [self performFetch];
        [self.tableView reloadData];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Fetched results controller
- (NSFetchedResultsController *)setupFetchedResultsController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
    [self assignSortDescriptorsToFetchRequest:fetchRequest];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:self.cacheName];

    fetchedResultsController.delegate = self;
    return fetchedResultsController;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];

    id item = [self objectAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteObjectAtIndexPath:indexPath];
    }
}

#pragma mark NSFetchedResultsController delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate: {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            id item = [self objectAtIndexPath:indexPath];
            self.configureCellBlock(cell, item);
            break;
        }

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

#pragma mark - Private methods

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
    [self.managedObjectContext deleteObject:[self objectAtIndexPath:indexPath]];

    NSError *error = nil;
    [self.managedObjectContext save:&error];

    if (error) {
        NSLog(@"Deletion of object at index path %@ failed! %@", indexPath, error);
    }
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)assignSortDescriptorsToFetchRequest:(NSFetchRequest *)fetchRequest {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:self.sortKey ascending:self.sortAscending];
    fetchRequest.sortDescriptors = @[sortDescriptor];
}

- (void)performFetch {
    NSError *error = nil;
	[self.fetchedResultsController performFetch:&error];

    if (error) {
        NSLog(@"Fetch failed! %@", error);
    }
}

@end
