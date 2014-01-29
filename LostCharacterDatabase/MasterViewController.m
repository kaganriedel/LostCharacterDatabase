//
//  ViewController.m
//  LostCharacterDatabase
//
//  Created by Kagan Riedel on 1/28/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "MasterViewController.h"
@import CoreData;
#import "Character.h"

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *characters;
    NSArray *pickerArray;
    
    NSString *sortPicked;
    
    __weak IBOutlet UITableView *lostTableView;
    __weak IBOutlet UITextField *actorTextField;
    __weak IBOutlet UITextField *passangerTextField;
    __weak IBOutlet UITextField *spoilerTextField;
    __weak IBOutlet UIPickerView *sortPicker;
}

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sortPicked = @"actor";
    
    [self reload];
    
    
    pickerArray = [NSArray arrayWithObjects:@"actor",@"passenger",@"spoiler", nil];
}

- (IBAction)onAddPressed:(id)sender
{
    Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:_managedObjectContext];
    character.actor = actorTextField.text;
    character.passenger = passangerTextField.text;
    character.spoiler = spoilerTextField.text;
    
    NSURL *url = [NSURL URLWithString:@"http://placekitten.com/30/30"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    character.image = UIImageJPEGRepresentation(img, 0.0);
    [_managedObjectContext save:nil];

    
    [self reload];
    
    actorTextField.text = @"";
    [actorTextField resignFirstResponder];
    passangerTextField.text = @"";
    [passangerTextField resignFirstResponder];
    spoilerTextField.text = @"";
    [spoilerTextField resignFirstResponder];
}


-(void)reload
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortPicked ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    request.sortDescriptors = @[sortDescriptor];
    
    characters = [_managedObjectContext executeFetchRequest:request error:nil];
    if (characters.count == 0) //if nothing loaded into characters then load the Plist data and set the array again
    {
        [self loadPlistData];
        characters = [_managedObjectContext executeFetchRequest:request error:nil];
    }
    
    [lostTableView reloadData];
}

-(void)loadPlistData
{
    NSURL *url = [NSURL URLWithString:@"file:///Users/kaganriedel/Downloads/lost.plist"];
    NSMutableArray *temporaryCharacterArray = [NSArray arrayWithContentsOfURL:url];
    
    for (NSDictionary *dict in temporaryCharacterArray)
    {
        Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:_managedObjectContext];
        character.actor = dict[@"actor"];
        character.passenger = dict[@"passenger"];
        [_managedObjectContext save:nil];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Character *character = characters[indexPath.row];
        [_managedObjectContext deleteObject:character];
        [_managedObjectContext save:nil];
        [self reload];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"SMOKE MONSTER";
}

-(LostCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Character *character;
    LostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LostCell"];
    character = characters[indexPath.row];
    
    cell.actorLabel.text = character.actor;
    cell.passangerLabel.text = character.passenger;
    cell.spoilerLabel.text = character.spoiler;
    
    if (character.image == nil)
    {
        NSURL *url = [NSURL URLWithString:@"http://placekitten.com/40/40"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.imgView.image = [UIImage imageWithData:data];
    }
    else
    {
        cell.imgView.image = [UIImage imageWithData:character.image];
    }
    
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return characters.count;
}
                   
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView* newView;
    
    if (view)
        newView = view;
    else {
        newView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,50)];
        //Create a label, put it on the left side of the view
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, newView.frame.size.width, newView.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = pickerArray[row];
        [label setBackgroundColor:[UIColor clearColor]];
        [newView addSubview:label];//add
    }
    return newView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    sortPicked = pickerArray[row];
    NSLog(@"picked %@",sortPicked);
    [self reload];
}

                   


@end
