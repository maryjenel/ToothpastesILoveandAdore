//
//  ViewController.m
//  ToothpastesILoveandAdore
//
//  Created by Mary Jenel Myers on 1/22/15.
//  Copyright (c) 2015 Mary Jenel Myers. All rights reserved.
//

#import "AdoredToothPastesViewController.h"
#import "ToothpastesTableViewController.h"
#define kDateKey @"dateSaved"

@interface AdoredToothPastesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property NSMutableArray *adoredToothpastes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AdoredToothPastesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self load];
    if (!self.adoredToothpastes)
    {
        self.adoredToothpastes = [NSMutableArray new];
    }

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.adoredToothpastes.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToothpasteCell"];
    cell.textLabel.text = [self.adoredToothpastes objectAtIndex:indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{

    NSDate *currentDate = [[NSUserDefaults standardUserDefaults] objectForKey:kDateKey];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSString *dateString = [NSString stringWithFormat:@"Last Saved %@",[formatter stringFromDate:currentDate]];
    return dateString;

}

-(NSURL *)documentsDirectory
{
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

- (NSURL *)plist
{
    NSURL *pListPath = [[self documentsDirectory] URLByAppendingPathComponent:@"toothpastes.plist"];
    return pListPath;
}

-(void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *pListPath;
    pListPath = [self plist];
    [self.adoredToothpastes writeToURL:pListPath atomically:YES];
    [defaults setObject:[NSDate date] forKey:kDateKey];
    [defaults synchronize];
}

-(void)load
{
    NSURL *pListPath;
    pListPath = [self plist];
    self.adoredToothpastes = [NSMutableArray arrayWithContentsOfURL:pListPath];
}

-(IBAction)unwindFromToothpaste:(UIStoryboardSegue *)segue
{
    ToothpastesTableViewController *vc = segue.sourceViewController;
    [self.adoredToothpastes addObject:[vc selectedToothpaste]];
    [self save];
    [self.tableView reloadData];


}


@end
