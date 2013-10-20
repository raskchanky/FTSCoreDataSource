//
//  Person.h
//  iOS Example
//
//  Created by Josh Black on 10/19/13.
//  Copyright (c) 2013 Fat Toad Software, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, copy) NSString *name;

@end
