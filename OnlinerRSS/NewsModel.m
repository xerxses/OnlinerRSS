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
#import "TFHpple.h"


@implementation NewsModel


- (void)createDBEntity
{
    [self newsFormater];
    News *news = [News MR_createEntity];
    news.title = self.title;
    news.shortDesc = self.shortDesc;
    news.pubDate = self.pubDate;
    news.link = self.link;
    news.image = self.image;
    news.fullDesc = self.fullDesc;
    [self saveContext];
    NSLog(@"%ld", [News MR_countOfEntities]);
}


- (void)newsFormater
{
    self.pubDate = [self.pubDate substringToIndex:self.pubDate.length - 6];
    NSData *data = [self.shortDesc dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements  = [doc searchWithXPathQuery:@"//p"];
    self.shortDesc = [(TFHppleElement *)[elements objectAtIndex:1] text];
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
