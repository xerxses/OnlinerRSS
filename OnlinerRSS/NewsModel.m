//
//  NewsModel.m
//  OnlinerRSS
//
//  Created by Vladislav on 14.02.16.
//  Copyright © 2016 domik. All rights reserved.
//

#import "NewsModel.h"
#import "News.h"
#import <MagicalRecord/MagicalRecord.h>


@implementation NewsModel


- (void)createDBEntity
{
    News *news = [News MR_createEntity];
    news.title = self.title;
    news.shortDesc = self.shortDesc;
    news.pubDate = self.pubDate;
    news.link = self.link;
    news.image = self.link;
    news.fullDesc = self.fullDesc;
    [self saveContext];
    NSLog(@"%ld", [News MR_countOfEntities]);
}


- (void)saveContext
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
    {
        if (success)
        {
            NSLog(@"You successfully saved your context.");
        } else if (error)
        {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}


@end
