//
//  TradeInformationView.h
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InformationList;
@protocol TradeInformationViewDelegate <NSObject>

@optional
- (void)tradeInformationViewDidTapped;
- (void)tradeInformationViewTappedWithInformationList:(InformationList *)list;

@end

@interface TradeInformationView : UIView

@property (nonatomic, assign) id<TradeInformationViewDelegate> delegate;
@property (nonatomic, retain) NSManagedObjectContext *MOC;
@property (nonatomic, retain) NSArray *infoLists;

- (id)initWithFrame:(CGRect)frame MOC:(NSManagedObjectContext *)MOC;
- (void)loadInformation;

@end
