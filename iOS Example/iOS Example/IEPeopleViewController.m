//
//  IEPeopleViewController.m
//  iOS Example
//
//  Created by Josh Black on 10/19/13.
//  Copyright (c) 2013 Fat Toad Software, Inc. All rights reserved.
//

#import "IEPeopleViewController.h"
#import "IEAppDelegate.h"
#import "FTSCoreDataSource.h"
#import "Person.h"
#import "IEAddPersonViewController.h"

@interface IEPeopleViewController ()
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) FTSCoreDataSource *dataSource;

- (IBAction)sortClicked:(id)sender;
@end

@implementation IEPeopleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    IEAppDelegate *appDelegate = (IEAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    [self setupTableView];
}

- (void)setupTableView
{
    TableViewCellConfigureBlock configureCell = ^(UITableViewCell *cell, Person *person) {
        cell.textLabel.text = person.name;
    };

    self.dataSource = [[FTSCoreDataSource alloc] initWithManagedObjectContext:self.managedObjectContext
                                                                    tableView:self.tableView
                                                                   entityName:@"Person"
                                                                      sortKey:@"name"
                                                                    cacheName:nil
                                                               cellIdentifier:@"PersonCell"
                                                           configureCellBlock:configureCell];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addPerson"]) {
        IEAddPersonViewController *controller = (IEAddPersonViewController *)segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
    }
}

- (IBAction)sortClicked:(id)sender {
    self.dataSource.sortAscending = !self.dataSource.sortAscending;
}

@end
