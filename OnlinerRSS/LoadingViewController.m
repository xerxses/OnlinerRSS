//
//  LoadingViewController.m
//  OnlinerRSS
//
//  Created by Vladislav on 14.02.16.
//  Copyright © 2016 domik. All rights reserved.
//

#import "LoadingViewController.h"
#import "NewsModel.h"
#import "News.h"


@interface LoadingViewController ()

@end


@implementation LoadingViewController


- (void)awakeFromNib
{
    [self getOnlinerFeed];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)getOnlinerFeed
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://people.onliner.by"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *newsMapping = [RKObjectMapping mappingForClass:[NewsModel class]];
    [newsMapping addAttributeMappingsFromDictionary:@{ @"title.text" : @"title",
                                                       @"link.text" : @"link",
                                                       @"pubDate.text" : @"pubDate",
                                                       @"description.text" : @"shortDesc",
                                                       @"media:thumbnail.url" : @"image"
                                                       }];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:newsMapping method:RKRequestMethodGET pathPattern:@"/feed" keyPath:@"rss.channel.item" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    [RKMIMETypeSerialization registerClass:[RKXMLReaderSerialization class] forMIMEType:@"text/xml"];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/feed"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         for (NewsModel *news in mappingResult.array)
         {
             News *newsDB = [News MR_findFirstByAttribute:@"title" withValue:news.title];
             if ((newsDB == nil) || (![news.pubDate containsString:newsDB.pubDate]))
                 [news createDBEntity];
         }
         
         [self performSegueWithIdentifier:@"NewsFeed"
                                   sender:self];
         NSLog(@"Sucess!");
     } failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         [self performSegueWithIdentifier:@"NewsFeed"
                                   sender:self];
         NSLog(@"Error: %@", error);
     }];
}


@end
