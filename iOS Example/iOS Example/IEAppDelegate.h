//
//  IEAppDelegate.h
//  iOS Example
//
//  Created by Josh Black on 10/19/13.
//  Copyright (c) 2013 Fat Toad Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
