//
//  NewsDetailsViewController.m
//  OnlinerRSS
//
//  Created by Vladislav on 15.02.16.
//  Copyright © 2016 domik. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import "TFHpple.h"
#import "News.h"


@interface NewsDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation NewsDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    News *news = [News MR_findFirstByAttribute:@"link" withValue:self.url];
    
    if (news.fullDesc == nil)
    {
        [self getFullTextOfNews:news];
    } else
    {
        [self.webView loadHTMLString:news.fullDesc baseURL:nil];
    }
}


- (BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
    if ( inType == UIWebViewNavigationTypeLinkClicked )
    {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}


- (void)getFullTextOfNews:(News *)news
{
    [[RKObjectManager sharedManager].HTTPClient getPath:self.url
                                             parameters:nil
                                                success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         TFHpple *doc = [[TFHpple alloc] initWithHTMLData:responseObject];
         TFHppleElement *elements  = [[doc searchWithXPathQuery:@"//article [@class='b-posts-1-item b-content-posts-1-item news_for_copy']"] objectAtIndex:0];
         NSString *string = [elements raw];
         news.fullDesc = string;
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
         [self.webView loadHTMLString:string baseURL:nil];
     }
                                                failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Ошибка!"
                                                          message:@"Проверьте подключение к интернету"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
         [alert show];
         [self.navigationController popViewControllerAnimated:YES];
     }];
}


@end
