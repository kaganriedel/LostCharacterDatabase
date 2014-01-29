//
//  Character.h
//  LostCharacterDatabase
//
//  Created by Kagan Riedel on 1/28/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Character : NSManagedObject

@property (nonatomic, retain) NSString * actor;
@property (nonatomic, retain) NSString * passenger;
@property (nonatomic, retain) NSString * spoiler;
@property (nonatomic, retain) NSData * image;

@end
