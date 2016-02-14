//
//  LoadingViewController.m
//  OnlinerRSS
//
//  Created by Vladislav on 14.02.16.
//  Copyright © 2016 domik. All rights reserved.
//

#import "LoadingViewController.h"
#import <RestKit/RestKit.h>
#import "NewsModel.h"
#import "RKXMLReaderSerialization.h"
#import "News.h"
#import <MagicalRecord/MagicalRecord.h>


@interface LoadingViewController ()

@end


@implementation LoadingViewController


- (void)awakeFromNib
{
    self.navigationController.navigationBarHidden = YES;
    
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
                                                       @"description.text" : @"shortDesc"
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
             if (![newsDB.pubDate isEqualToString:news.pubDate])
                 [news createDBEntity];
         }
         
         UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                        message:[NSString stringWithFormat:@"%ld", [News MR_countOfEntities]]
                                                                 preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {}];
         
         [alert addAction:defaultAction];
         [self presentViewController:alert animated:YES completion:nil];
         
         NSLog(@"succ");
     } failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"What do you mean by 'there is no coffee?': %@", error);
     }];
}


@end
