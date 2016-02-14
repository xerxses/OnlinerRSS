//
//  NewsModel.h
//  OnlinerRSS
//
//  Created by Vladislav on 14.02.16.
//  Copyright © 2016 domik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject


@property (nullable, nonatomic, retain) NSString *fullDesc;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *pubDate;
@property (nullable, nonatomic, retain) NSString *shortDesc;
@property (nullable, nonatomic, retain) NSString *title;


- (void)createDBEntity;


@end
