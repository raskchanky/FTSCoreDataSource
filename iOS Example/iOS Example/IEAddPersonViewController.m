//
//  IEAddPersonViewController.m
//  iOS Example
//
//  Created by Josh Black on 10/19/13.
//  Copyright (c) 2013 Fat Toad Software, Inc. All rights reserved.
//

#import "IEAddPersonViewController.h"
#import "Person.h"

@interface IEAddPersonViewController ()
@property (weak, nonatomic) IBOutlet UITextField *personName;

- (IBAction)cancelClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;
@end

@implementation IEAddPersonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.personName becomeFirstResponder];
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveClicked:(id)sender {
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
    person.name = self.personName.text;

    NSError *error = nil;
    [self.managedObjectContext save:&error];

    if (error) {
        NSLog(@"Error saving context! %@", error);
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
