FTSCoreDataSource
--------

FTSCoreDataSource is a data source for a `UITableView` that's backed by a Core Data model.  It removes much of the boilerplate involved in getting a `UITableView` setup with an `NSFetchedResultsController`.

## Usage

To use FTSCoreDataSource, simply add `FTSCoreDataSource.h` and `FTSCoreDataSource.m` to your project and call the designated initializer for `FTSCoreDataSource` in the view controller you wish you use it in.  An example might look like:

```objc
- (void)setupTableView
{
    TableViewCellConfigureBlock configureCell = ^(UITableViewCell *cell, MyModel *model) {
        cell.textLabel.text = model.someField;
    };

    FTSCoreDataSource *ds = [[FTSCoreDataSource alloc]
                                initWithManagedObjectContext:self.managedObjectContext
                                                   tableView:self.tableView
                                                  entityName:@"MyModel"
                                                     sortKey:@"someFieldToSortBy"
                                                   cacheName:nil
                                              cellIdentifier:@"MyModelCell"
                                          configureCellBlock:configureCell];
}
```

There is also an included example project that demonstrates how to set it up and use it.

## ARC
FTSCoreDataSource assumes you're using ARC.

## Credits

This was inspired by the article on [lighter view controllers](http://www.objc.io/issue-1/lighter-view-controllers.html) in Issue 1 of http://objc.io.

## License

MIT. See the LICENSE file for more info.
