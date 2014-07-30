//
//  TextPool.h
//  Product
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - common
static NSString *const NSSessionInvalid = @"sessionInvalid";
static NSString *const NSActionSuccessMsg = @"actionSuccessMsg";
static NSString *const NSActionFaildMsg = @"actionFaildMsg";
static NSString *const NSYesTitle = @"yesTitle";
static NSString *const NSNoTitle = @"noTitle";
static NSString *const NSDeleteTitle = @"deleteTitle";
static NSString *const NSDeleteActionTitle = @"deleteActionTitle";
static NSString *const NSBackTitle = @"backTitle";
static NSString *const NSDoneTitle = @"doneTitle";
static NSString *const NSAllTitle = @"allTitle";
static NSString *const NSPastEventTitle = @"pastEventTitle";
static NSString *const NSThisMonthTitle = @"thisMonthTitle";
static NSString *const NSEntireTitle = @"entireTitle";
static NSString *const NSProcessingTitle = @"processingTitle";
static NSString *const NSEditTitle = @"editTitle";
static NSString *const NSFavoriteTitle = @"favoriteTitle";
static NSString *const NSUnfavoriteTitle = @"unfavoriteTitle";
static NSString *const NSSaveTitle = @"saveTitle";
static NSString *const NSSearchTitle = @"searchTitle";
static NSString *const NSSearchPromptTitle = @"searchPromptTitle";
static NSString *const NSInputTextTitle = @"inputTextTitle";
static NSString *const NSSearchResultTitle = @"searchResultTitle";
static NSString *const NSGoTitle = @"goTitle";
static NSString *const NSUpdateTitle = @"updateTitle";
static NSString *const NSNoThanksTitle = @"noThanksTitle";
static NSString *const NSOffTitle = @"offTitle";
static NSString *const NSOnTitle = @"onTitle";
static NSString *const NSAutoTitle = @"autoTitle";
static NSString *const NSDetailsTitle = @"detailsTitle";
static NSString *const NSNoSupportTitle = @"noSupportTitle";
static NSString *const NSSessionInvalidTitle = @"sessionInvalidTitle";
static NSString *const NSCallActionSheetTitle = @"callActionSheetTitle";
static NSString *const NSKeyboardTitle = @"keyboardTitle";
static NSString *const NSBackgroundLoadFailedMsg = @"backgroundLoadFailedMsg";
static NSString *const NSSubmitButTitle = @"submitButTitle";
static NSString *const NSSubmitDoneMsg = @"submitDoneMsg";
static NSString *const NSSubmitFailedMsg = @"submitFailedMsg";
static NSString *const NSModifyTitle = @"modifyTitle";
static NSString *const NSRefreshTitle = @"refreshTitle";
static NSString *const NSClearSearchHistoryMsg = @"clearSearchHistoryMsg";
static NSString *const NSSearchingTitle = @"searchingTitle";
static NSString *const NSCheckDetailTitle = @"checkDetailTitle";
static NSString *const NSCheckAllTitle = @"checkAllTitle";
static NSString *const NSCheckMoreTitle = @"checkMoreTitle";
static NSString *const NSEmptyListMsg = @"emptyListMsg";
static NSString *const NSCheckInputMsg = @"checkInputMsg";
static NSString *const NSInputIndexMsg = @"inputIndexMsg";
static NSString *const NSInputItemMsg = @"inputItemMsg";

#pragma mark - login page
static NSString *const NSLoginHelpButtonTitle = @"loginHelpButtonTitle";
static NSString *const NSLoginTitle= @"loginTitle";
static NSString *const NSAnonymousTitle= @"anonymousTitle";
static NSString *const NSLogoutTitle = @"logoutTitle";
static NSString *const NSLogoutMsgTitle = @"logoutMsgTitle";
static NSString *const NSLoginNote1Title= @"loginNote1Title";
static NSString *const NSLoginNote2Title= @"loginNote2Title";
static NSString *const NSLoginHelpTitle= @"loginHelpTitle";
static NSString *const NSLoginPSWDTitle = @"loginPSWDTitle";
static NSString *const NSUserInfoNeeded		= @"userInfoNeeded";
static NSString *const NSPswdInfoNeeded		= @"pswdInfoNeeded";
static NSString *const NSUserPlaceholder  = @"userPlaceholder";
static NSString *const NSNamePlaceholder  = @"namePlaceholder";
static NSString *const NSShareSoftTitle   = @"shareSoftTitle";

static NSString *const NSPswdPlaceholder  = @"pswdPlaceholder";
static NSString *const NSLoginFailedMsg   = @"loginFailedMsg";
static NSString *const NSRefreshSessionFailedMsg = @"refreshSessionFailedMsg";

#pragma mark - xml parser
static NSString *const NSParserXmlNullMsg   = @"parserXmlNullMsg";
static NSString *const NSParserXmlErrMsg    = @"parserXmlErrMsg";

#pragma mark - homepage
static NSString *const NSHomepageTitle      = @"homepageTitle";
static NSString *const NSMessageTitle       = @"messageTitle";
static NSString *const NSNearbyTitle        = @"nearbyTitle";
static NSString *const NSMeTitle            = @"meTitle";
static NSString *const NSInviteTitle        = @"inviteTitle";
static NSString *const NSAskTitle           = @"askTitle";
static NSString *const NSStartCircleTitle   = @"startCircleTitle";
static NSString *const NSQuickFeedNotifyMsg = @"quickFeedNotifyMsg";
static NSString *const NSQuickQANotifyMsg   = @"quickQANotifyMsg";
static NSString *const NSACircleTitle       = @"aCircleTitle";
static NSString *const NSOfExpatTitle       = @"ofExpatTitle";
static NSString *const NSByExpatTitle       = @"byExpatTitle";
static NSString *const NSForExpatTitle      = @"forExpatTitle";
static NSString *const NSYouHaveMsg         = @"youHaveMsg";
static NSString *const NSGroupPaymentMsg    = @"groupPaymentMsg";
static NSString *const NSEventPaymentMsg    = @"eventPaymentMsg";
static NSString *const NSTodoItemMsg        = @"todoItemMsg";
static NSString *const NSFollowWechatForHelpMsg = @"followWechatForHelpMsg";
static NSString *const NSDonateTitle        = @"donateTitle";

#pragma mark - hot news
static NSString *const NSHotNewsTitle       = @"hotNewsTitle";
static NSString *const NSLoadNewsFailedMsg  = @"loadNewsFailedMsg";
static NSString *const NSNewNewsLoadedMsg   = @"newNewsLoadedMsg";
static NSString *const NSClickImageForBigTitle = @"clickImageForBigTitle";
static NSString *const NSFavoriteNewsHandyNotifyMsg = @"favoriteNewsHandyNotifyMsg";
static NSString *const NSFetchNewsFailedMsg = @"fetchNewsFailedMsg";

#pragma mark - Q & A
static NSString *const NSQATitle              = @"qaTitle";
static NSString *const NSLoadCommentFailedMsg = @"loadCommentFailedMsg";

#pragma mark - comment
static NSString *const NSCommentTitle  = @"commentTitle";
static NSString *const NSCommentsTitle = @"commentsTitle";
static NSString *const NSSendCommentFailedMsg = @"sendCommentFailedMsg";
static NSString *const NSSendCommentDoneMsg = @"sendCommentDoneMsg";
static NSString *const NSCommentEmptyMsg = @"commentEmptyMsg";
static NSString *const NSWriteCommentTitle = @"writeCommentTitle";
static NSString *const NSWriteAnswerTitle = @"writeAnswerTitle";

#pragma mark - composer
static NSString *const NSTagTitle      = @"tagTitle";
static NSString *const NSPlaceTitle    = @"placeTitle";
static NSString *const NSTextComposerPlaceholder = @"textComposerPlaceholder";
static NSString *const NSSendTitle     = @"sendTitle";
static NSString *const NSCloseNotificationTitle = @"closeNotificationTitle";
static NSString *const NSAddPhotoTitle = @"addPhotoTitle";
static NSString *const NSTagHeader = @"tagHeader";
static NSString *const NSPlaceHeader = @"placeHeader";
static NSString *const NSSelectTagNotifyMsg = @"selectTagNotifyMsg";
static NSString *const NSLoadPlaceFailedMsg = @"loadPlaceFailedMsg";
static NSString *const NSTagStillLoadingMsg = @"tagStillLoadingMsg";
static NSString *const NSDiscardTitle = @"discardTitle";
static NSString *const NSCommentFieldPlaceHolder = @"commentFieldPlaceHolder";
static NSString *const NSSendingTitle = @"sendingTitle";

#pragma mark - image
static NSString *const NSSaveImageSuccessMsg = @"saveImageSuccessMsg";
static NSString *const NSOriginalImageTitle = @"originalImageTitle";
static NSString *const NSBWImageTitle = @"bWImageTitle";
static NSString *const NSPhotoEffectHandleTitle = @"photoEffectHandleTitle";
static NSString *const NSClearCurrentSelection = @"clearCurrentSelection";
static NSString *const NSChooseExistingPhotoTitle  = @"chooseExistingPhotoTitle";
static NSString *const NSTakePhotoTitle = @"takePhotoTitle";
static NSString *const NSBigPicTitle = @"bigPicTitle";
static NSString *const NSLoadImageFailedMsg = @"loadImageFailedMsg";
static NSString *const NSLoadCountryFailedMsg = @"loadCountryFailedMsg";
static NSString *const NSNormalTitle = @"normalTitle";
static NSString *const NSInkwellTitle = @"inkWellTitle";
static NSString *const NSClassicTitle = @"classicTitle";
static NSString *const NSPhotoDiscardMsg = @"photoDiscardMsg";
static NSString *const NSSharePhotoTitle = @"sharePhotoTitle";

#pragma mark - enterprise
static NSString *const NSCaseShareTitle = @"caseShareTitle";
static NSString *const NSShareSuccessMsg = @"shareSuccessMsg";
static NSString *const NSCaseShareAdiMsg = @"caseShareAdiMsg";
static NSString *const NSCaseShareEmailSubjectMsg = @"caseShareEmailSubjectMsg";
static NSString *const NSCaseSloganmsg = @"caseSloganmsg";
static NSString *const NSPublicDiscussGroupTitle = @"publicDiscussGroupTitle";
static NSString *const NSJoinedDiscussGroupTitle = @"joinedDiscussGroupTitle";
static NSString *const NSOtherDiscussGroupTitle = @"otherDiscussGroupTitle";
static NSString *const NSClubAndBranchGroup = @"clubAndBranchGroup";
static NSString *const NSPopularGroup = @"popularGroup";

#pragma mark - user profile
static NSString *const NSPointTitle = @"pointTitle";
static NSString *const NSUserProfileTitle = @"userProfileTitle";
static NSString *const NSLoadUserProfileFailedMsg = @"loadUserProfileFailedMsg";
static NSString *const NSInvitationSentPointTitle = @"invitationSentPointTitle";
static NSString *const NSInvitationDonePointTitle = @"invitationDonePointTitle";
static NSString *const NSFeedPointTitle = @"feedPointTitle";
static NSString *const NSCommentPointTitle = @"commentPointTitle";
static NSString *const NSTotalPointsTitle = @"totalPointsTitle";
static NSString *const NSLiveStatusTitle = @"liveStatusTitle";
static NSString *const NSPeopleTitle = @"peopleTitle";
static NSString *const NSFavoritedItemTitle = @"favoritedItemTitle";
static NSString *const NSFavoritedWelfareTitle = @"favoritedWelfareTitle";
static NSString *const NSFavoritedTitle = @"favoritedTitle";
static NSString *const NSInvitedTitle = @"invitedTitle";
static NSString *const NSUninvitedTitle = @"uninvitedTitle";
static NSString *const NSJoinedTitle = @"joinedTitle";
static NSString *const NSUnjoinedTitle = @"unjoinedTitle";
static NSString *const NSLoadSNSFriendsFailedMsg = @"loadSNSFriendsFailedMsg";
static NSString *const NSFacebookFriendsTitle = @"facebookFriendsTitle";
static NSString *const NSTwitterFriendsTitle = @"twitterFriendsTitle";
static NSString *const NSLinkedinFriendsTitle = @"linkedinFriendsTitle";
static NSString *const NSAddressbookFriendsTitle = @"addressbookFriendsTitle";
static NSString *const NSSNSListTitle = @"snsListTitle";
static NSString *const NSInvitationDoneMsg = @"invitationDoneMsg";
static NSString *const NSInvitationFailedMsg = @"invitationFailedMsg";
static NSString *const NSUserNameTitle = @"userNameTitle";
static NSString *const NSUpdatePhotoDoneMsg = @"updatePhotoDoneMsg";
static NSString *const NSUpdatePhotoFailedMsg = @"updatePhotoFailedMsg";
static NSString *const NSUpdateNationalityDoneMsg = @"updateNationalityDoneMsg";
static NSString *const NSUpdateNationalityFailedMsg = @"updateNationalityFailedMsg";
static NSString *const NSUpdateLivingCityDoneMsg = @"updateLivingCityDoneMsg";
static NSString *const NSUpdateLivingCityFailedMsg = @"updateLivingCityFailedMsg";
static NSString *const NSUpdateLivingYearsDoneMsg = @"updateLivingYearsDoneMsg";
static NSString *const NSUpdateLivingYearsFailedMsg = @"updateLivingYearsFailedMsg";
static NSString *const NSUpdateUsernameDoneMsg = @"updateUsernameDoneMsg";
static NSString *const NSUpdateUsernameFailedMsg = @"updateUsernameFailedMsg";
static NSString *const NSEditProfileTitle = @"editProfileTitle";
static NSString *const NSCurrentCityTitle = @"currentCityTitle";
static NSString *const NSAnswerTitle = @"answerTitle";
static NSString *const NSAnswersTitle = @"answersTitle";
static NSString *const NSUnfavoritePeopleDoneMsg = @"unfavoritePeopleDoneMsg";
static NSString *const NSUnfavoritePeopleFailedMsg = @"unfavoritePeopleFailedMsg";
static NSString *const NSFavoritePeopleDoneMsg = @"favoritePeopleDoneMsg";
static NSString *const NSFavoritePeopleFailedMsg = @"favoritePeopleFailedMsg";
static NSString *const NSRequireTitle = @"requireTitle";
static NSString *const NSOptionalTitle = @"optionalTitle";
static NSString *const NSEmailTitle = @"emailTitle";
static NSString *const NSPasswordTitle = @"passwordTitle";
static NSString *const NSNationalityTitle = @"nationalityTitle";
static NSString *const NSYearsInChinaTitle = @"yearsInChinaTitle";
static NSString *const NSCurrentResidenceTitle = @"currentResidenceTitle";
static NSString *const NSServiceTermTitle = @"serviceTermTitle";
static NSString *const NSUsernameEmptyMsg = @"usernameEmptyMsg";
static NSString *const NSEmptyUsenameCannotUploadMsg = @"emptyUsenameCannotUploadMsg";
static NSString *const NSEmailEmptyMsg = @"emailEmptyMsg";
static NSString *const NSNationalityEmptyMsg = @"nationalityEmptyMsg";
static NSString *const NSResidenceEmptyMsg = @"residenceEmptyMsg";
static NSString *const NSEmailOccupiedMsg = @"emailOccupiedMsg";
static NSString *const NSSigninByLinkedinTitle = @"signinByLinkedinTitle";
static NSString *const NSSigninConfirmTitle = @"signinConfirmTitle";
static NSString *const NSSigninTitle = @"signinTitle";
static NSString *const NSUserSignInInfoMsg = @"userSignInInfoMsg";
static NSString *const NSSsoFailedMsg = @"ssoFailedMsg";
static NSString *const NSReSignInTitle= @"reSignInTitle";
static NSString *const NSSigninFailedMsg = @"signinFailedMsg";
static NSString *const NSIncentivesTitle = @"incentivesTitle";
static NSString *const NSABFriendJoinedStatusTitle = @"ABFriendJoinedStatusTitle";
static NSString *const NSLinkedinFriendJoinedStatusTitle = @"LinkedinFriendJoinedStatusTitle";
static NSString *const NSSearchABMsg = @"searchABMsg";
static NSString *const NSNotifyABContactUploadMsg = @"notifyABContactUploadMsg";
static NSString *const NSAllowTitle = @"allowTitle";
static NSString *const NSDonotAllowTitle = @"donotAllowTitle";
static NSString *const NSPointStatusTitle = @"pointStatusTitle";
static NSString *const NSReceiveAwardHistoryTitle = @"receiveAwardHistoryTitle";
static NSString *const NSSendInvitationTitle = @"sendInvitation";
static NSString *const NSInvitationAcceptPrimeTitle = @"invitationAcceptPrimeTitle";
static NSString *const NSInvitationAcceptNonPrimeTitle = @"invitationAcceptNonPrimeTitle";
static NSString *const NSCreditRuleTitle = @"creditRuleTitle";
static NSString *const NSFriendsOnECTitle = @"friendsOnECTitle";
static NSString *const NSInvitationAcceptCommentMsg = @"invitationAcceptCommentMsg";
static NSString *const NSScanningABMsg = @"scanningABMsg";
static NSString *const NSFriendsTitle = @"friendsTitle";

#pragma mark - Q & A
static NSString *const NSNewQuestionLoadedMsg = @"newQuestionLoadedMsg";
static NSString *const NSLoadQuestionFailedMsg = @"loadQuestionFailedMsg";
static NSString *const NSNewQuestionTitle = @"newQuestionTitle";
static NSString *const NSNewAnswerTitle = @"newAnswerTitle";

#pragma mark - location
static NSString *const NSIntroTitle = @"introTitle";
static NSString *const NSUserPlaceTitle = @"userPlaceTitle";
static NSString *const NSLoadNearbyDoneMsg = @"loadNearbyDoneMsg";
static NSString *const NSLoadNearbyFailedMsg = @"loadNearbyFailedMsg";
static NSString *const NSNoNearbyInfoMsg = @"noNearbyInfoMsg";
static NSString *const NSLoadServiceGroupFailedMsg = @"loadServiceGroupFailedMsg";
static NSString *const NSFilterSortTitle = @"filterSortTitle";
static NSString *const NSEntireCityTitle = @"entireCityTitle";
static NSString *const NSWithin2kmTitle = @"within2kmTitle";
static NSString *const NSWithin5kmTitle = @"within5kmTitle";
static NSString *const NSWithin10kmTitle = @"within10kmTitle";
static NSString *const NSSortByDistanceTitle = @"sortByDistanceTitle";
static NSString *const NSSortByCommonRateTitle = @"sortByCommonRateTitle";
static NSString *const NSSortByMyCountryRateTitle = @"sortByMyCountryRateTitle";
static NSString *const NSSortByCommentTitle = @"sortByCommentRateTitle";
static NSString *const NSKMTitle = @"kmTitle";
static NSString *const NSMeterTitle = @"meterTitle";
static NSString *const NSMapTitle = @"mapTitle";
static NSString *const NSListTitle = @"listTitle";
static NSString *const NSSPSequenceTitle = @"SPSequenceTitle";
static NSString *const NSCallTitle = @"callTitle";
static NSString *const NSPhotoTitle = @"photoTitle";

static NSString *const NSTaxiTitle = @"taxiTitle";
static NSString *const NSShowCardTitle = @"showCardTitle";
static NSString *const NSAddPhotoDoneTitle = @"addPhotoDoneTitle";
static NSString *const NSAddPhotoFailedTitle = @"addPhotoFailedTitle";
static NSString *const NSLikersLoadingTitle = @"likersLoadingTitle";
static NSString *const NSLikersLoadFailedTitle = @"likersLoadFailedTitle";
static NSString *const NSLikeActionDoneMsg = @"likeActionDoneMsg";
static NSString *const NSUnlikeActionDoneMsg = @"unlikeActionDoneMsg";
static NSString *const NSLikeActionFailedMsg = @"likeActionFailedMsg";
static NSString *const NSUnlikeActionFailedMsg = @"unlikeActionFailedMsg";
static NSString *const NSFavoriteDoneMsg = @"favoriteDoneMsg";
static NSString *const NSUnfavoriteDoneMsg = @"unfavoriteDoneMsg";
static NSString *const NSFavoriteFailedMsg = @"favoriteFailedMsg";
static NSString *const NSUnfavoriteFailedMsg = @"unfavoriteFailedMsg";
static NSString *const NSCheckinFailedMsg = @"checkinFailedMsg";
static NSString *const NSCallThisNumberTitle = @"callThisNumberTitle";
static NSString *const NSAddPhotoForVenueTitle = @"addPhotoForVenueTitle";
static NSString *const NSLoadPhotoFailedMsg = @"loadPhotoFailedMsg";
static NSString *const NSVenueTitle = @"venueTitle";
static NSString *const NSVenuesTitle = @"venuesTitle";
static NSString *const NSFetchPlacesFailedMsg = @"fetchPlacesFailedMsg";
static NSString *const NSAtTitleMsg = @"atTitleMsg";

#pragma mark - nearby item
static NSString *const NSIamDoingTitle = @"IamDoingTitle";
static NSString *const NSFetchNearbyItemDetailFailedMsg = @"fetchNearbyItemDetailFailedMsg";
static NSString *const NSFetchNearbyPeopleFailedMsg = @"fetchNearbyPeopleFailedMsg";
static NSString *const NSFetchNearbyPlaceFailedMSg = @"fetchNearbyPlaceFailedMSg";
static NSString *const NSBranchTitle = @"branchTitle";
static NSString *const NSOtherBranchTitle = @"otherBranchTitle";
static NSString *const NSIamHereTitle = @"iamHereTitle";
static NSString *const NSBeFirstCheckinMsg = @"beFirstCheckinMsg";
static NSString *const NSTotalCheckinCountMsg = @"totalCheckinCountMsg";
static NSString *const NSFetchCheckinUserFailedMsg = @"fetchCheckinUserFailedMsg";
static NSString *const NSCheckinAlumnusTitle = @"checkinAlumnusTitle";
static NSString *const NSNearbyAlumnusTitle = @"nearbyAlumnusTitle";
static NSString *const NSCheckinDoneMsg = @"checkinDoneMsg";
static NSString *const NSAlumniCouponTitle = @"alumniCouponTitle";
static NSString *const NSAlumniExclusiveTitle = @"alumniExclusiveTitle";
static NSString *const NSNearbyCouponTitle = @"nearbyCouponTitle";
static NSString *const NSLoadBrandsFailedMsg = @"loadBrandsFailedMsg";
static NSString *const NSAllowedBranchsTitle = @"allowedBranchsTitle";
static NSString *const NSIalumniCouponTitle = @"ialumniCouponTitle";
static NSString *const NSShowForUseCouponTitle = @"showForUserConponTitle";
static NSString *const NSAlumniWorkedInCompanyTitle = @"alumniWorkedInCompanyTitle";
static NSString *const NSAlumniInCompanyTitle = @"alumniInCompanyTitle";
static NSString *const NSFetchBrandDetailFailedMsg = @"fetchBrandDetailFailedMsg";
static NSString *const NSFetchBrandsFailedMsg = @"fetchBrandsFailedMsg";
static NSString *const NSAllBranchesTitle = @"allBranchesTitle";
static NSString *const NSFetchAlumnusFailedMsg = @"fetchAlumnusFailedMsg";
static NSString *const NSCheckinFarAwayMsg = @"checkinFarAwayMsg";
static NSString *const NSCouponTipsMsg = @"couponTipsMsg";
static NSString *const NSCouponTip_1Msg = @"couponTip_1Msg";
static NSString *const NSCouponInfoTitle = @"couponInfoTitle";
static NSString *const NSAlumniCompanyTitle = @"alumniCompanyTitle";
static NSString *const NSNonAlumniCompanyTitle = @"nonAlumniCompanyTitle";
static NSString *const NSNearbyVenuesTitle = @"nearbyVenuesTitle";
static NSString *const NSNearestVenueDistanceTitle = @"nearestVenueDistanceTitle";
static NSString *const NSContactUsTitle = @"contactUsTitle";
static NSString *const NSShareToWechatTitle = @"shareToWechatTitle";

#pragma mark - event
static NSString *const NSEventDetailTitle = @"eventDetailTitle";
static NSString *const NSSponsorDetailTitle = @"sponsorDetailTitle";
static NSString *const NSSponsorTitle = @"sponsorTitle";
static NSString *const NSCheckedinAlumnusTitle = @"checkedinAlumnusTitle";
static NSString *const NSAlumniCheckinFarAwayMsg = @"alumniCheckinFarAwayMsg";
static NSString *const NSNoRegistrationFeeMsg = @"noRegistrationFeeMsg";
static NSString *const NSNotSignUpMsg = @"notSignUpMsg";
static NSString *const NSDiscussVoteTitle = @"discussVoteTitle";
static NSString *const NSIKnowTitle = @"iKnowTitle";
static NSString *const NSCheckedinAlumnusListTitle = @"checkedinAlumnusListTitle";
static NSString *const NSEventDiscussionTitle = @"eventDiscussionTitle";
static NSString *const NSEventVoteTitle = @"eventVoteTitle";
static NSString *const NSJoinEventDiscussTitle = @"joinEventDiscussTitle";
static NSString *const NSCheckinNeedConfirmMsg = @"checkinNeedConfirmMsg";
static NSString *const NSShouldPayTitle = @"shouldPayTitle";
static NSString *const NSActualPayTitle = @"actualPayTitle";
static NSString *const NSCheckinFailedEventOverdueMsg = @"checkinFailedEventOverdueMsg";
static NSString *const NSDigitalTicketTitle = @"digitalTicketTitle";
static NSString *const NSCheckinResultTitle = @"checkinResultTitle";
static NSString *const NSContinueCheckinTitle = @"continueCheckinTitle";
static NSString *const NSCheckAdminWhetherApprovedMsg = @"checkAdminWhetherApprovedMsg";
static NSString *const NSDiscussTitle = @"discussTitle";
static NSString *const NSAppearAlumniTitle = @"appearAlumniTitle";
static NSString *const NSCheckinConfirmedMsg = @"checkinConfirmedMsg";
static NSString *const NSFetchEventDetailFailedMsg = @"fetchEventDetailFailedMsg";
static NSString *const NSEventNotBeginMsg = @"eventNotBeginMsg";
static NSString *const NSEventDuplicateCheckinMsg = @"eventDuplicateCheckinMsg";
static NSString *const NSHaveSignedUpTitle = @"haveSignedUpTitle";
static NSString *const NSHaveNotSignedUpTitle = @"haveNotSignedUpTitle";
static NSString *const NSEventDetailSignupTitle = @"eventDetailSignupTitle";
static NSString *const NSSignedUpCountTitle = @"signedUpCountTitle";
static NSString *const NSEventCellSignupTitle = @"eventCellSignupTitle";
static NSString *const NSCheckedinCountTitle = @"checkedinCountTitle";
static NSString *const NSSignedUpAlumniTitle = @"signedUpAlumniTitle";
static NSString *const NSAddCalendarFailedMsg = @"addCalendarFailedMsg";
static NSString *const NSAddTitle = @"addTitle";
static NSString *const NSMoreInfoDownloadTitle = @"moreInfoDownloadTitle";
static NSString *const NSDownloadTitle = @"downloadTitle";
static NSString *const NSNotStartTitle = @"notStartTitle";
static NSString *const NSClosedTitle = @"closedTitle";
static NSString *const NSInProcessTitle = @"inProcessTitle";
static NSString *const NSVotedTitle = @"votedTitle";
static NSString *const NSNotVotedTitle = @"notVotedTitle";
static NSString *const NSLoadEventTopicFailedMsg = @"loadEventTopicFailedMsg";
static NSString *const NSLoadEventOptionFailedMsg = @"loadEventOptionFailedMsg";
static NSString *const NSFillVoteTitle = @"fillVoteTitle";
static NSString *const NSSelectOptionConfirmMsg = @"selectOptionConfirmMsg";
static NSString *const NSVoteTitle = @"voteTitle";
static NSString *const NSShareBySMSTitle = @"shareBySMSTitle";
static NSString *const NSShareByWeixinTitle = @"shareByWeixinTitle";
static NSString *const NSNoWeChatMsg = @"noWeChatMsg";
static NSString *const NSInstallTitle = @"installTitle";
static NSString *const NSDonotInstallTitle = @"donotInstallTitle";
static NSString *const NSAppRecommendTitle = @"appRecommendTitle";
static NSString *const NSAppShareByWeChatDoneMsg = @"appShareByWeChatDoneMsg";
static NSString *const NSSharedFromiAlumniTitle = @"sharedFromiAlumniTitle";
static NSString *const NSAppShareToWeChatGroupTitle = @"appShareToWeChatGroupTitle";
static NSString *const NSAppShareByWeChatFailedMsg = @"appShareByWeChatFailedMsg";
static NSString *const NSVoteRepeatedlyMsg = @"voteRepeatedlyMsg";
static NSString *const NSVoteInCloseStatusMsg = @"voteInCloseStatusMsg";
static NSString *const NSSelectOneOptionMsg = @"selectOneOptionMsg";
static NSString *const NSEmptyContentNotifyMsg = @"emptyContentNotifyMsg";
static NSString *const NSTableInfoTitle = @"tableInfoTitle";
static NSString *const NSAcademicAndLecturesTitle = @"cademicAndLecturesTitle";
static NSString *const NSPlayAndPartyTitle = @"playAndPartyTitle";
static NSString *const NSStartupTitle = @"startupTitle";
static NSString *const NSStartupProjectTitle = @"startupProjectTitle";
static NSString *const NSProjectDiscussTitle = @"projectDiscussTitle";
static NSString *const NSMyEventMsg = @"myEventMsg";
static NSString *const NSMySignUpEventMsg = @"mySignUpEventMsg";
static NSString *const NSMyCheckInEventMsg = @"myCheckInEventMsg";
static NSString *const NSSignedAndJoinedEventTitle = @"signedAndJoinedEventTitle";
static NSString *const NSGroupLatestEventTitle = @"groupLatestEventTitle";
static NSString *const NSHoldDayTitle = @"holdDayTitle";
static NSString *const NSEventAwardFailedMsg = @"eventAwardFailedMsg";
static NSString *const NSNoGrantedForCalendarTitle = @"noGrantedForCalendarTitle";
static NSString *const NSHowToGrantCalendarMsg = @"howToGrantCalendarMsg";
static NSString *const NSEventPersonTitle = @"eventPersonTitle";
static NSString *const NSAppliedTitle = @"appliedTitle";
static NSString *const NSAttendTitle = @"attendTitle";
static NSString *const NSPlacedSignUpCountMsg = @"placedSignUpCountMsg";

static NSString *const NSEventTopicTitle = @"eventTopicTitle";
static NSString *const NSEventGroupTitle = @"eventGroupTitle";
static NSString *const NSEventDateTitle = @"eventDateTitle";
static NSString *const NSEventAddressTitle = @"eventAddressTitle";
static NSString *const NSEventDescTitle = @"eventDescTitle";

#pragma mark - settings
static NSString *const NSSettingsTitle = @"settingsTitle";
static NSString *const NSCurrentSystemLanguageTitle = @"currentSystemLanguageTitle";
static NSString *const NSFollowUsOnWechatTitle = @"followUsOnWechatTitle";
static NSString *const NSFollowWechatPublicNoTitle = @"followWechatPublicNoTitle";
static NSString *const NSFollowUsOnWechatForMoreHelpTitle = @"followUsOnWechatForMoreHelpTitle";
static NSString *const NSLanguageTitle = @"languageTitle";
static NSString *const NSLanguageSwitchDoneMsg = @"languageSwitchDoneMsg";
static NSString *const NSSignOutTitle = @"signOutTitle";
static NSString *const NSSignOutNotifyMsg = @"signOutNotifyMsg";
static NSString *const NSLanguageSwitchFailedMsg = @"languageSwitchFailedMsg";
static NSString *const NSNewsFontSizeTitle = @"newsFontSizeTitle";
static NSString *const NSLargeTitle = @"largeTitle";
static NSString *const NSMediumTitle = @"mediumTitle";
static NSString *const NSSmallTitle = @"smallTitle";
static NSString *const NSTodayTitle = @"todayTitle";
static NSString *const NSProfileSettingTitle = @"profileSettingTitle";
static NSString *const NSFollowWechatPublicNoNoteMsg = @"followWechatPublicNoNoteMsg";
static NSString *const NSFollowMethod1Msg = @"followMethod1Msg";
static NSString *const NSFollowMethod2Msg = @"followMethod2Msg";
static NSString *const NSOption1Title = @"option1Title";
static NSString *const NSOption2Title = @"option2Title";
static NSString *const NSSaveQRPicMsg = @"saveQRPicMsg";

#pragma mark - system message
static NSString *const NSAwardTitle = @"awardTitle";
static NSString *const NSUpdateAvailableTitle = @"updateAvailableTitle";

#pragma mark - service
static NSString *const NSServicePrivacyTermsTitle = @"servicePrivacyTermsTitle";
static NSString *const NSTipsTitle = @"tipsTitle";
static NSString *const NSPriceTitle = @"priceTitle";
static NSString *const NSCostTitle = @"costTitle";
static NSString *const NSTasteTitle = @"tasteTitle";
static NSString *const NSTopicTitle = @"topicTitle";
static NSString *const NSCategoryTitle = @"categoryTitle";
static NSString *const NSCompensationTitle = @"compensationTitle";
static NSString *const NSShareTitle = @"shareTitle";
static NSString *const NSShareToFriendTitle = @"shareToFriendTitle";
static NSString *const NSSMSTitle = @"smsTitle";
static NSString *const NSSMSSentFailed = @"smsSentFailed";
static NSString *const NSRouteTitle = @"routeTitle";
static NSString *const NSPhoneTitle = @"phoneTitle";
static NSString *const NSAppTitle = @"appTitle";
static NSString *const NSPaymentErrorMsg = @"paymentErrorMsg";
static NSString *const NSPaymentDoneMsg = @"paymentDoneMsg";

#pragma mark - home page
static NSString *const NSNewsActivityTitle  = @"newsActivityTitle";
static NSString *const NSReportTitle        = @"reportTitle";
static NSString *const NSUpcomingTitle      = @"upcomingTitle";
static NSString *const NSCooperationTitle   = @"cooperationTitle";
static NSString *const NSEventTitle         = @"eventTitle";
static NSString *const NSEventReportTitle   = @"eventReportTitle";
static NSString *const NSEventFilterTitle   = @"filterTitle";
static NSString *const NSAlumniTitle        = @"alumniTitle";
static NSString *const NSClassTitle         = @"classTitle";
static NSString *const NSAlumniEventTitle   = @"alumniEventTitle";
static NSString *const NSAlumniInteractTitle= @"alumniInteractTitle";
static NSString *const NSProfAssocTitle     = @"profAssocTitle";
static NSString *const NSNearbyAlumniTitle  = @"nearbyAlumniTitle";
static NSString *const NSQuestionTitle      = @"questionTitle";
static NSString *const NSAlumniProfileTitle = @"alumniProfileTitle";
static NSString *const NSFeedbackTitle      = @"feedbackTitle";
static NSString *const NSSurveyTitle        = @"surveyTitle";
static NSString *const NSBackAlumniCheckInTitle   = @"backAlumniCheckInTitle";
static NSString *const NSShakeTitle         = @"shakeTitle";
static NSString *const NSShakeExchangeNameCardTitle = @"shakeExchangeNameCardTitle";
static NSString *const NSShakeNameCardTitle = @"shakeNameCardTitle";
static NSString *const NSVideoTitle         = @"videoTitle";
static NSString *const NSClubTitle          = @"clubTitle";
static NSString *const NSOpenVideoTitle     = @"openVideoTitle";

#pragma mark - alumni
static NSString *const NSMySupplyDemandTitle = @"mySupplyDemandTitle";
static NSString *const NSAddTagTitle = @"addTagTitle";
static NSString *const NSSupplyDemandSentNotifyMsg = @"supplyDemandSentNotifyMsg";

static NSString *const NSFetchClassFailedMsg = @"fetchClassFailedMsg";
static NSString *const NSFetchCityFailedMsg = @"fetchCityFailedMsg";
static NSString *const NSFetchCountryFailedMsg = @"fetchCounryFailedMsg";
static NSString *const NSFetchIndustryFailedMsg = @"fetchIndustryFailedMsg";
static NSString *const NSClassQueryTitle = @"classQueryTitle";
static NSString *const NSSignCodeTitle = @"signCodeTitle";
static NSString *const NSNameTitle  = @"nameTitle";
static NSString *const NSGenderTitle  = @"genderTitle";
static NSString *const NSCountryTitle = @"countryTitle";
static NSString *const NSCompanyTitle = @"companyTitle";
static NSString *const NSCompanyPlaceTitle = @"companyPlaceTitle";
static NSString *const NSCompanyCityTitle = @"companyCityTitle";
static NSString *const NSCompanyProvinceTitle = @"companyProvinceTitle";
static NSString *const NSIndustryTitle  = @"industryTitle";
static NSString *const NSPleaseSelectTitle  = @"pleaseSelectTitle";
static NSString *const NSQueryTitle = @"queryTitle";
static NSString *const NSBlankQueryTitle = @"blankQueryTitle";
static NSString *const NSClearTitle = @"clearTitle";
static NSString *const NSBlankClearTitle = @"blankClearTitle";
static NSString *const NSMaleTitle  = @"maleTitle";
static NSString *const NSFemaleTitle  = @"femaleTitle";
static NSString *const NSFetchAlumniFailedMsg = @"fetchAlumniFailedMsg";
static NSString *const NSPositionTitle  = @"positionTitle";
static NSString *const NSMobileTitle  = @"mobileTitle";
static NSString *const NSCompanyNameTitle = @"companyNameTitle";
static NSString *const NSCompanyAddressTitle = @"companyAddressTitle";
static NSString *const NSCompanyPhoneTitle = @"companyPhoneTitle";
static NSString *const NSCompanyFaxTitle = @"companyFaxTitle";
static NSString *const NSQueryLimitMsg = @"queryLimitMsg";
static NSString *const NSSearchInputTitle = @"searchInputTitle";
static NSString *const NSSearchConditionTitle = @"searchConditionTitle";
static NSString *const NSUnApprovedTitle = @"unApprovedTitle";
static NSString *const NSApprovedTitle = @"approvedTitle";
static NSString *const NSAddContactTitle = @"addContactTitle";
static NSString *const NSSaveAlumniTitle = @"saveAlumniTitle";
static NSString *const NSSinaWeiboTitle = @"sinaWeiboTitle";
static NSString *const NSWeixinTitle = @"weixinTitle";

static NSString *const NSAlumniDetailTitle = @"alumniDetailTitle";
static NSString *const NSAddNewContactTitle = @"addNewContactTitle";
static NSString *const NSAddExistingContactTitle = @"addExistingContactTitle";
static NSString *const NSCannotCallMsg = @"cannotCallMsg";

static NSString *const NSNotCEIBSAlumniMsg = @"notCEIBSAlumniMsg";
static NSString *const NSFollowedTitle = @"followedTitle";
static NSString *const NSFollowedAlumnusTitle = @"followedAlumnusTitle";
static NSString *const NSBackProjectTitle = @"backProjectTitle";
static NSString *const NSBackedProjectTile = @"backedProjectTile";
static NSString *const NSSurveyCannotEditMsg = @"surveyCannotEditMsg";

// Filter
static NSString *const NSFilterEventType = @"filterEventType";
static NSString *const NSFilterEventCity = @"filterEventCity";
static NSString *const NSFilterOrderTitle = @"filterOrderTitle";
static NSString *const NSFilterGroupType = @"filterGroupType";

static NSString *const NSBackedAlumnusTitle = @"backedAlumnusTitle";
static NSString *const NSJoinButTitle = @"joinButTitle";
static NSString *const NSClubListPostTitle = @"clubListPostTitle";
static NSString *const NSClubListMemberTitle = @"clubListMemberTitle";
static NSString *const NSClubListEventTitle = @"clubListEventTitle";
static NSString *const NSClubDetailMemberTitle = @"clubDetailMemberTitle";
static NSString *const NSClubDetailEventTitle = @"clubDetailEventTitle";
static NSString *const NSClubManageTitle = @"clubManageTitle";
static NSString *const NSClubLabelTitle = @"clubLabelTitle";
static NSString *const NSActivityLabelTitle = @"activityLabelTitle";
static NSString *const NSClubAddMemberTitle = @"clubAddMemberTitle";
static NSString *const NSClubDetailTitle = @"clubDetailTitle";
static NSString *const NSClubEventTitle = @"clubEventTitle";
static NSString *const NSQuitButTitle = @"quitButTitle";
static NSString *const NSQuitNoteTitle = @"quitNoteTitle";
static NSString *const NSClubJoinButTitle = @"clubJoinButTitle";
static NSString *const NSClubQuitButTitle = @"clubQuitButTitle";
static NSString *const NSAdminShowCheckInButTitle = @"adminShowCheckInButTitle";
static NSString *const NSAdminCheckInButTitle = @"adminCheckInButTitle";
static NSString *const NSAdminCheckSmsTitle = @"adminCheckSmsTitle";
static NSString *const NSRecommendClubTitle = @"recommendClubTitle";

static NSString *const NSAdminCheckButTitle = @"adminCheckButTitle";
static NSString *const NSAdminUnCheckInButTitle = @"adminUnCheckInButTitle";
static NSString *const NSModifyMobileTitle = @"modifyMobileTitle";
static NSString *const NSModifyEmailTitle = @"modifyEmailTitle";
static NSString *const NSModifyEmailDoneMsg = @"modifyEmailDoneMs";
static NSString *const NSModifyEmailFailedMsg = @"modifyEmailFailedMsg";
static NSString *const NSModifyMobileDoneMsg = @"modifyMobileDoneMsg";
static NSString *const NSModifyMobileFailedMsg = @"modifyMobileFailedMsg";

static NSString *const NSClubNotify2SharingTitle = @"clubNotify2SharingTitle";
static NSString *const NSQuestion2AnswerButTitle = @"question2AnswerButTitle";
static NSString *const NSCreateTimeTitle = @"createTimeTitle";

static NSString *const NSDateTitle = @"dateTitle";
static NSString *const NSTimeTitle = @"timeTitle";
static NSString *const NSContactTitle = @"contactTitle";
static NSString *const NSTelTitle = @"telTitle";
static NSString *const NSAddressTitle = @"addressTitle";
static NSString *const NSSentFromExpatCircleAppTitle = @"sentFromExpatCircleAppTitle";
static NSString *const NSCannotSendSMSMsg = @"cannotSendSMSMsg";
static NSString *const NSCannotSendEmailMsg = @"cannotSendEmailMsg";
static NSString *const NSAddPhotoSubTitle = @"addPhotoSubTitle";
static NSString *const NSNoLikerNotifyMsg = @"noLikerNotifyMsg";
static NSString *const NSServiceProviderTitle = @"serviceProviderTitle";
static NSString *const NSRecruiterTitle = @"recruiterTitle";
static NSString *const NSOrganizerTitle = @"organizerTitle";
static NSString *const NSTransitTitle = @"transitTitle";
static NSString *const NSRecommendationsTitle = @"recommendationsTitle";
static NSString *const NSChineseDishTitle = @"chineseDishTitle";
static NSString *const NSValidityTitle = @"validityTitle";
static NSString *const NSDisclaimersTitle = @"disclaimersTitle";
static NSString *const NSReviewsTitle = @"reviewsTitle";
static NSString *const NSReviewsEmptyMsg = @"reviewsEmptyMsg";
static NSString *const NSWriteReviewsTitle = @"writeReviewsTitle";
static NSString *const NSLoadReviewsFailedMsg = @"loadReviewsFailedMsg";
static NSString *const NSNewReviewTitle = @"newReviewTitle";
static NSString *const NSServiceQuickTipsTitle = @"serviceQuickTipsTitle";
static NSString *const NSSourceTitle = @"sourceTitle";
static NSString *const NSJDTitle = @"jdTitle";
static NSString *const NSCouponDetailTitle = @"couponDetailTitle";
static NSString *const NSPriceDetailTitle = @"priceDetailTitle";
static NSString *const NSValueTitle = @"valueTitle";
static NSString *const NSPrpTitle = @"prpTitle";
static NSString *const NSFormatedPrpTitle = @"formatedPrpTitle";
static NSString *const NSYuanTitle = @"yuanTitle";
static NSString *const NSDiscountsTitle = @"discountsTitle";
static NSString *const NSHighlightsTitle = @"highlightsTitle";

static NSString *const NSChangeTitle = @"changeTitle";
static NSString *const NSWebSiteTitle = @"websiteTitle";
static NSString *const NSMembersTitle = @"membersTitle";
static NSString *const NSActivitysTitle = @"activitysTitle";

static NSString *const NSClubPostTitle = @"clubPostTitle";
static NSString *const NSGroupTrendsTitle = @"groupTrendsTitle";
static NSString *const NSPostTitle = @"postTitle";
static NSString *const NSPostInputTitle = @"postInputTitle";

static NSString *const NSAllSponsorTitle    = @"allSponsorTitle";
static NSString *const NSAllCityTitle       = @"allCityTitle";

static NSString *const NSBackBtnTitle		= @"backBtnTitle";
static NSString *const NSSelectTitle        = @"selectTitle";
static NSString *const NSQuestionnaireTitle = @"questionnaireTitle";
static NSString *const NSAboutQuestionnaireTitle = @"aboutQuestionnaireTitle";
static NSString *const NSAboutCEIBSTitle = @"aboutCEIBSTitle";

static NSString *const NSAlumniSearchTitle   = @"alumniSearchTitle";
static NSString *const NSBizCoopTitle = @"bizCoopTitle";
static NSString *const NSPostDetailTitle    = @"postDetailTitle";
static NSString *const NSPostSurveyTitle    = @"postSurveyTitle";
static NSString *const NSPostReSurveyTitle    = @"postReSurveyTitle";
static NSString *const NSPostSurveyResultTitle    = @"postSurveyResultTitle";
static NSString *const NSPersonSettingTitle = @"personSettingTitle";

#pragma mark - club
static NSString *const NSMyClassCircleTitle = @"myClassCircleTitle";
static NSString *const NSClubDescTitle = @"clubDescTitle";
static NSString *const NSNewClubPostTitle = @"newClubPostTitle";
static NSString *const NSAllClubPostTitle = @"allClubPostTitle";
static NSString *const NSActiveClubTitle = @"activeClubTitle";
static NSString *const NSNewClubEventTitle = @"newClubEventTitle";
static NSString *const NSNoClubEventTitle = @"noClubEventTitle";
static NSString *const NSGroupEventTitle = @"groupEventTitle";
static NSString *const NSGroupMemberTitle = @"groupMemberTitle";
static NSString *const NSNoGroupEventTitle = @"noGroupEventTitle";
static NSString *const NSClubTrendTitle = @"clubTrendTitle";
static NSString *const NSMyGroupsTitle = @"myGroupsTitle";
static NSString *const NSAllGroupsTitle = @"allGroupsTitle";
static NSString *const NSGroupsTitle = @"groupsTitle";
static NSString *const NSPaidDateMsg = @"paidDateMsg";
static NSString *const NSLoadGroupFailedMsg = @"loadGroupFailedMsg";
static NSString *const NSLoadFilterOptionsFailedMsg = @"loadFilterOptionsFailedMsg";
static NSString *const NSRenewalsTitle = @"renewalsTitle";
static NSString *const NSPayNowTitle = @"payNowTitle";
static NSString *const NSForAllAlumnusTitle = @"forAllAlumnusTitle";
static NSString *const NSServicePlanTitle = @"servicePlanTitle";
static NSString *const NSConstitutionTitle = @"constitutionTitle";
static NSString *const NSCouncilListTitle = @"councilListTitle";
static NSString *const NSGetUserDetialFailedMsg = @"getUserDetailFailedMsg";
static NSString *const NSGroupManagementTitle = @"groupManagementTitle";
static NSString *const NSPaidUserCannotExitMsg = @"paidUserCannotExitMsg";
static NSString *const NSNeedPayGroupFeeMsg = @"needPayGroupFeeMsg";

#pragma mark - shake
static NSString *const NSShakeLoadingTitle = @"shakeLoadingTitle";
static NSString *const NSShakeNoteTitle     = @"shakeNoteTitle";
static NSString *const NSShakeForAwardsTitle = @"shakeForAwardsTitle";
static NSString *const NSShakeRoarTitle     = @"shakeRoarTitle";
static NSString *const NSShakeChatListTitle     = @"shakeChatListTitle";
static NSString *const NSShakeThingTitle = @"shakeThingTitle";
static NSString *const NSShakePlaceTitle = @"shakePlaceTitle";
static NSString *const NSShakeThingNoteTitle = @"shakeThingNoteTitle";
static NSString *const NSShakePlaceNoteTitle = @"shakePlaceNoteTitle";
static NSString *const NSShakeThingLabelTitle = @"shakeThingLabelTitle";
static NSString *const NSShakePlaceLabelTitle = @"shakePlaceLabelTitle";
static NSString *const NSChatTitle = @"chatTitle";
static NSString *const NSDistanceTitle = @"distanceTitle";
static NSString *const NSChatEmptyWarningMsg = @"chartEmptyWarningMsg";
static NSString *const NSChatPrompt1Text = @"chatPrompt1Text";
static NSString *const NSChatPrompt2Text = @"chatPrompt2Text";
static NSString *const NSShakeAwardsTitle = @"shakeAwardsTitle";
static NSString *const NSShakeNameCardInfoMsg = @"shakeNameCardInfoMsg";
static NSString *const NSNoNameCardMsg = @"noNameCardMsg";

#pragma mark - share
static NSString *const NSFavoriteStatusTitle = @"favoriteStatusTitle";
static NSString *const NSFetchingTagMsg = @"fetchingTagMsg";
static NSString *const NSWeChatShareTitle = @"weChatShareTitle";

#pragma mark - feedback
static NSString *const NSFeedbackMsg        = @"feedbackMsg";
static NSString *const NSFeedbackMsg1       = @"feedbackMsg1";
static NSString *const NSFeedbackMsg2       = @"feedbackMsg2";
static NSString *const NSFeedbackMsg3       = @"feedbackMsg3";
static NSString *const NSFeecbackEmptyWarningMsg = @"feecbackEmptyWarningMsg";
static NSString *const NSFeedbackPromptTitle = @"feedbackPromptTitle";
static NSString *const NSMoreTitle = @"moreTitle";
static NSString *const NSBracketsNewsTitle = @"bracketsNewsTitle";
static NSString *const NSBracketsVideoTitle = @"bracketsVideoTitle";
static NSString *const NSRecommendBracketsVideoTitle = @"recommendBracketsVideoTitle";

#pragma mark - people network
static NSString *const NSProfileModifyImgTitle = @"profileModifyImgTitle";
static NSString *const NSBaseInfoTitle = @"baseInfoTitle";
static NSString *const NSProfileBaseTitle = @"profileBaseTitle";
static NSString *const NSProfileHomeTitle = @"profileHomeTitle";
static NSString *const NSProfileHomeNoteMsg = @"profileHomeNoteMsg";
static NSString *const NSProfileCompanyTitle = @"profileCompanyTitle";
static NSString *const NSProfileAccountTitle = @"profileAccountTitle";
static NSString *const NSHowToKnowTitle = @"howToKnowTitle";
static NSString *const NSMaybeConnectedFriendsTitle = @"maybeConnectedFriendsTitle";
static NSString *const NSWithMeConnectionTitle = @"withMeConnectionTitle";
static NSString *const NSWhoJoinedGroupTitle = @"whoJoinedGroupTitle";
static NSString *const NSJoinedGroupTitle = @"joinedGroupTitle";
static NSString *const NSFavoriteAlumniDoneMsg = @"favoriteAlumniDoneMsg";
static NSString *const NSNameCardTitle = @"nameCardTitle";
static NSString *const NSCheckNameCardTitle = @"checkNameCardTitle";
static NSString *const NSFavoritedAlumnusTitle = @"favoritedAlumnusTitle";
static NSString *const NSRecommendAlumnusTitle = @"recommendAlumnusTitle";
static NSString *const NSKnownAlumnusTitle = @"knownAlumnusTitle";
static NSString *const NSWantToKnowAlumniTitle = @"wantToKnowAlumniTitle";
static NSString *const NSClassmateTitle = @"classmateTitle";
static NSString *const NSNonclassmateTitle = @"nonclassmateTitle";
static NSString *const NSAllSupplyDemandTitle = @"allSupplyDemandTitle";
static NSString *const NSDeleteFavoriteTitle = @"deleteFavoriteTitle";
static NSString *const NSOrTitle = @"orTitle";
static NSString *const NSSearchNameCardTitle = @"searchNameCardTitle";
static NSString *const NSPeopleNetworkTitle = @"peopleNetworkTitle";
static NSString *const NSExchangeNameCardTitle = @"exchangeNameCardTitle";
static NSString *const NSSelectAllTitle = @"selectAllTitle";
static NSString *const NSDeselectAllTitle = @"deselectAllTitle";
static NSString *const NSExchangeTitle = @"exchangeTitle";
static NSString *const NSSearchNearbyAlumnusMsg = @"searchNearbyAlumnusMsg";
static NSString *const NSConfirmReceiveNameCardTitle = @"confirmReceiveNameCardTitle";
static NSString *const NSNameCardExchangeDoneMsg = @"nameCardExchangeDoneMsg";
static NSString *const NSCheckKnownAlumniTitle = @"checkKnownAlumniTitle";
static NSString *const NSSelectOneNameCardMsg = @"selectOneNameCardMsg";
static NSString *const NSShakeForNameCardTitle = @"shakeForNameCardTitle";
static NSString *const NSReceivingTitle = @"receivingTitle";
static NSString *const NSAddToAddressbook = @"addToAddressbook";
static NSString *const NSMustSelectFavoriteTypeMsg = @"mustSelectFavoriteTypeMsg";
static NSString *const NSDMTitle = @"dmTitle";
static NSString *const NSDMNotificationTitle = @"dmNotificationTitle";
static NSString *const NSHavePaidTitle = @"havePaidTitle";
static NSString *const NSNotPaidTitle = @"notPaidTitle";

#pragma mark - user list action sheet
static NSString *const NSActionSheetTitle = @"actionSheetTitle";
static NSString *const NSChatActionSheetTitle = @"chatActionSheetTitle";
static NSString *const NSProfileActionSheetTitle = @"profileActionSheetTitle";
static NSString *const NSChatWithTitle = @"chatWithTitle";

#pragma mark - pay
static NSString *const NSSubmitOrderTitle = @"submitOrderTitle";
static NSString *const NSConfimOrderTitle = @"confimOrderTitle";
static NSString *const NSConfimPayTitle = @"confimPayTitle";
static NSString *const NSOrderDescTitle = @"orderDescTitle";
static NSString *const NSOrderDescPromptTitle = @"orderDescPromptTitle";
static NSString *const NSTotalPriceTitle = @"totalPriceTitle";
static NSString *const NSOrderCountTitle = @"orderCountTitle";
static NSString *const NSOrderItemTitle = @"orderItemTitle";
static NSString *const NSOrderIdTitle = @"orderIdTitle";
static NSString *const NSOrderAmountTitle = @"orderAmountTitle";
static NSString *const NSOrderDetailTitle = @"orderDetailTitle";
static NSString *const NSPayActionSheetTitle = @"payActionSheetTitle";
static NSString *const NSAlipayTitle = @"alipayTitle";
static NSString *const NSUnionpayTitle = @"unionpayTitle";
static NSString *const NSAlipayDescTitle = @"alipayDescTitle";
static NSString *const NSUnionpayDescTitle = @"unionpayDescTitle";
static NSString *const NSUnpayOrderDescTitle = @"unpayOrderDescTitle";

#pragma mark - welfare
static NSString *const NSWantProvideBenefitTitle = @"wantProvideBenefitTitle";
static NSString *const NSProvideBenefitNoteTitle = @"provideBenefitNoteTitle";
static NSString *const NSProvideName = @"provideName";
static NSString *const NSProvideTel = @"provideTel";
static NSString *const NSProvideMail = @"provideMail";
static NSString *const NSProvideWeixin = @"provideWeixin";
static NSString *const NSProvideBrand = @"provideBrand";
static NSString *const NSProvideCompanyDesc = @"provideCompanyDesc";
static NSString *const NSProvideCompanyScale = @"provideCompanyScale";
static NSString *const NSProvideWelfareDesc = @"provideWelfareDesc";
static NSString *const NSWelfareDetailTitle = @"welfareDetailTitle";
static NSString *const NSDownloadUserInfoMsg = @"downloadUserInfoMsg";
static NSString *const NSBoughtUserInfoMsg = @"boughtUserInfoMsg";
static NSString *const NSEndTimeTipsMsg = @"endTimeTipsMsg";
static NSString *const NSCheckAllStoreMsg = @"checkAllStoreMsg";
static NSString *const NSUseNoticeTitle = @"useNoticeTitle";
static NSString *const NSContactWelfareSupportMsg = @"contactWelfareSupportMsg";
static NSString *const NSBrandInfoTitle = @"brandInfoTitle";
static NSString *const NSDownloadNowTitle = @"downloadNowTitle";
static NSString *const NSStoreDetailTitle = @"storeDetailTitle";
static NSString *const NSBrandDetailTitle = @"brandDetailTitle";
static NSString *const NSConsultTitle = @"consultTitle";
static NSString *const NSOverCountTitle = @"overCountTitle";
static NSString *const NSCouponSaveToAlbumMsg = @"couponSaveToAlbumMsg";
static NSString *const NSDownloadedUserListTitle = @"downloadedUserListTitle";
static NSString *const NSFailedToGetOrderMsg = @"failedToGetOrderMsg";
static NSString *const NSRecommendBracketsWelfareTitle = @"recommendBracketsWelfareTitle";
static NSString *const NSAlumniPriceTitle = @"alumniPriceTitle";
static NSString *const NSShareWelfareTitle = @"shareWelfareTitle";


#pragma mark -- training
static NSString *const NSDownloadStatusPending = @"downloadStatusPending";
static NSString *const NSDownloadStatusFinished = @"downloadStatusFinished";
static NSString *const NSDownloadStatusDownloading = @"downloadStatusDownloading";
static NSString *const NSDownloadStatusPause = @"downloadStatusPause";

static NSString *const NSSplashLoadNessesaryResource = @"splashLoadNessesaryResource";
static NSString *const NSLoadingUserDataTitle = @"loadingUserDataTitle";

//---------login------------
static NSString *const NSLoginRegister  = @"loginRegister";
static NSString *const NSLoginLogin     = @"loginLogin";
static NSString *const NSRegistLogin     = @"registLogin";
static NSString *const NSLoginLogining    = @"loginLogining";
static NSString *const NSLoginCustomer   = @"loginCustomer";
static NSString *const NSLoginUserName     = @"loginUserName";
static NSString *const NSLoginPassword    = @"loginPassword";

static NSString *const NSLoginCustomerEmpty    = @"loginCustomerEmpty";
static NSString *const NSLoginUserNameEmpty    = @"loginUserNameEmpty";
static NSString *const NSLoginPasswordEmpty    = @"loginPasswordEmpty";

static NSString *const NSLoginErrorCustomer = @"loginErrorCustomer";
static NSString *const NSLoginErrorUserName = @"loginErrorUserName";
static NSString *const NSLoginErrorPassword = @"loginErrorPassword";
static NSString *const NSLoginErrorIDIllegal = @"loginErrorIdIllegal";
static NSString *const NSLoginErrorDB       = @"loginErrorDB";

//------mian page bottom
static NSString *const NSMainPageBottomBarInformation = @"mainPageBottomBarInformation";
static NSString *const NSMainPageBottomBarBusiness = @"mainPageBottomBarBusiness";
static NSString *const NSMainPageBottomBarTraining = @"mainPageBottomBarTraining";
static NSString *const NSMainPageBottomBarCommunication = @"mainPageBottomBarCommunication";
static NSString *const NSMainPageBottomBarMore=@"mainPageBottomBarMore";

//------mian page top
static NSString *const NSMainPageTopInformation=@"mainPageTopInfomation";
static NSString *const NSMainPageTopBusiness = @"mainPageTopBusiness";
static NSString *const NSMainPageTopTraining = @"mainPageTopTraining";
static NSString *const NSMainPageTopCOmmunication = @"mainPageTopCommunication";
static NSString *const NSMainPageTopMore = @"mainPageTopMore";

//-----GoHigh Business
static NSString *const NSBusinessItemLocation=@"businessItemLocation";
static NSString *const NSBusinessItemType=@"businessItemType";
static NSString *const NSBusinessItemArea=@"businessItemArea";
static NSString *const NSBusinessItemSalePrice=@"businessItemSalePrice";
static NSString *const NSBusinessItemSaleTime=@"usinessItemSaleTime";

//----training
static NSString *const NSTrainingCourse = @"trainingCourse";

//-----Communicat
static NSString *const NSCommunicatMemberList=@"communicatMemberList";
static NSString *const NSCommunicatHoldTo = @"communicatHoldTo";
static NSString *const NSCommunicateLoosenTheSendingVoice=@"communicateLoosenTheSendingVoice";

#pragma mark -- day
static NSString *const NSCommonToday = @"commonToday";
static NSString *const NSCommonYesterDay = @"commonYesterDay";
static NSString *const NSCommonWarning = @"commonWarning";
static NSString *const NSCommonError = @"commonError";

//------------------------------------------

static NSString *const NSSignUpFailedMsg        = @"signUpFailedMsg";
static NSString *const NSUploadDiplomaTitle     = @"uploadDiplomaTitle";
static NSString *const NSUsernamePlaceholderTitle = @"usernamePlaceholderTitle";
static NSString *const NSFirstUserNoteTitle     = @"firstUserNoteTitle";
static NSString *const NSSignInInfoMandatoryMsg = @"signInInfoMandatoryMsg";
static NSString *const NSWechatAccountTitle     = @"wechatAccountTitle";
static NSString *const NSWeiboAccountTitle      = @"weiboAccountTitle";
static NSString *const NSLinkedinAccountTitle   = @"linkedinAccountTitle";
static NSString *const NSChangePwdTitle         = @"changePwdTitle";
static NSString *const NSPendingApprovalMsg     = @"pendingApprovalMsg";
static NSString *const NSUserProfileUpdateDoneMsg = @"userProfileUpdateDoneMsg";
static NSString *const NSUserProfileUpdateFailedMsg = @"userProfileUpdateFailedMsg";
static NSString *const NSOldPwdTitle            = @"oldPwdTitle";
static NSString *const NSNewPwdTitle            = @"newPwdTitle";
static NSString *const NSResetPSWDTitle         = @"resetPSWDTitle";
static NSString *const NSPwdInconsistentMsg     = @"pwdInconsistentMsg";
static NSString *const NSSavingTitle            = @"savingTitle";
static NSString *const NSChangePwdDoneMsg       = @"changePwdDoneMsg";
static NSString *const NSChangePwdFailedMsg     = @"changePwdFailedMsg";
static NSString *const NSChangeSchoolNoteMsg    = @"changeSchoolNoteMsg";
static NSString *const NSChangeCourseNoteMsg    = @"changeCourseNoteMsg";
static NSString *const NSChangeStartYearNoteMsg = @"changeStartYearNoteMsg";
static NSString *const NSNoauthApprovalMemberMsg= @"noauthApprovalMemberMsg";
static NSString *const NSSignUpSaveNoteMsg      = @"signUpSaveNoteMsg";
static NSString *const NSProfileSaveNoteMsg     = @"profileSaveNoteMsg";
static NSString *const NSOldPwdIncorrectMsg     = @"oldPwdIncorrectMsg";
static NSString *const NSAvatarMandatoryMsg     = @"avatarMandatoryMsg";
static NSString *const NSCourseTitle            = @"courseTitle";
static NSString *const NSCourseMandatoryMsg     = @"courseMandatoryMsg";
static NSString *const NSChangeAvatarFailedMsg  = @"changeAvatarFailedMsg";
static NSString *const NSChangeAvatarDoneMsg    = @"changeAvatarDoneMsg";
static NSString *const NSHometownTitle          = @"hometownTitle";
static NSString *const NSTravelCitiesTitle      = @"travelCitiesTitle";
static NSString *const NSApprovedPassTitle      = @"approvedPassTitle";
static NSString *const NSApprovalRefuseTitle    = @"approvalRefuseTitle";
static NSString *const NSForbidOpenGroupForPendingApprovelMsg = @"forbidOpenGroupForPendingApprovelMsg";
static NSString *const NSForbidOpenPostForPendingApprovelMsg = @"forbidOpenPostForPendingApprovelMsg";
static NSString *const NSForbidSendPostForPendingApprovelMsg = @"forbidSendPostForPendingApprovelMsg";
static NSString *const NSForbidGetPostsForPendingApprovelMsg = @"forbidGetPostsForPendingApprovelMsg";
static NSString *const NSForbidJoinGroupForPendingApprovelMsg = @"forbidJoinGroupForPendingApprovelMsg";
static NSString *const NSForbidQuitGroupForPendingApprovelMsg = @"forbidQuitGroupForPendingApprovelMsg";
static NSString *const NSForbidSendDMForPendingApprovelMsg = @"forbidSendDMForPendingApprovelMsg";
static NSString *const NSForbidCheckContactForPendingApprovelMsg = @"forbidCheckContactForPendingApprovelMsg";
static NSString *const NSForbidSearchUserForPendingApprovelMsg = @"forbidSearchUserForPendingApprovelMsg";
static NSString *const NSForbidSendSupplyDemandForPendingApprovelMsg = @"forbidSendSupplyDemandForPendingApprovelMsg";

//add ailiao
static NSString *const NSExitButTitle = @"exitButTitle";

//ichat
static NSString *const NSICcreateGroupMsg  = @"ICcreateGroupMsg";
static NSString *const NSICcreateGroupFailedMsg  = @"ICcreateGroupFailedMsg";
static NSString *const NSICcreateGroup  = @"ICcreateGroup";
static NSString *const NSICgroupIcon  = @"ICgroupIcon";
static NSString *const NSICgroupName  = @"ICgroupName";
static NSString *const NSICgroupChoosePic  = @"ICgroupChoosePic";
static NSString *const NSICaddGroup  = @"ICaddGroup";
static NSString *const NSICchatLoginFail  = @"ICchatLoginFail";
static NSString *const NSICchatLogoutFail  = @"ICchatLogoutFail";
static NSString *const NSICchatRecordFail  = @"ICchatRecordFail";
static NSString *const NSICchatTextMode  = @"ICchatTextMode";
static NSString *const NSICchatRecordMode  = @"ICchatRecordMode";

static NSString *const NSICchatJoinGroupSucMsg  = @"ICchatJoinGroupSucMsg";
static NSString *const NSICchatJoinGroupStepMsg  = @"ICchatJoinGroupStepMsg";
static NSString *const NSICchatJoinGroupStep0Msg  = @"ICchatJoinGroupStep0Msg";
static NSString *const NSICchatJoinGroupStep1Msg  = @"ICchatJoinGroupStep1Msg";
static NSString *const NSICchatJoinGroupStep2Msg  = @"ICchatJoinGroupStep2Msg";
static NSString *const NSICchatOutGroupMsg  = @"ICchatOutGroupMsg";
static NSString *const NSICchatOutGroupSucMsg  = @"ICchatOutGroupSucMsg";
static NSString *const NSICsearchFriend  = @"ICsearchFriend";
static NSString *const NSICgroupMemberListTitle  = @"ICgroupMemberListTitle";
static NSString *const NSICaddFriend  = @"ICaddFriend";
static NSString *const NSICexitFriend  = @"ICexitFriend";
static NSString *const NSICaddFriendMsg  = @"ICaddFriendMsg";

#pragma mark - feed
static NSString *const NSFilterHeaderTitle = @"filterHeaderTitle";
static NSString *const NSSortHeaderTitle = @"sortHeaderTitle";
static NSString *const NSFilterTitle = @"filterTitle";
static NSString *const NSSortTitle = @"sortTitle";
static NSString *const NSDoFilterTitle = @"doFilterTitle";
static NSString *const NSSortByCreateTimeTitle = @"sortByCreateTimeTitle";
static NSString *const NSSortByPraiseTitle = @"sortByPraiseTitle";
static NSString *const NSSortByNewCommentTimeTitle = @"sortByNewCommentTimeTitle";
static NSString *const NSSortByCommentCountTitle = @"sortByCommentCountTitle";
static NSString *const NSSortOptionsTitle = @"sortOptionsTitle";
static NSString *const NSTagLoadingMsg = @"tagLoadingMsg";
static NSString *const NSPlaceLoadingMsg = @"placeLoadingMsg";
static NSString *const NSLoadFeedFailedMsg = @"loadFeedFailedMsg";
static NSString *const NSSendFeedDoneMsg = @"sendFeedDoneMsg";
static NSString *const NSSendFeedFailedMsg = @"sendFeedFailedMsg";
static NSString *const NSSendQuestionDoneMsg = @"sendQuestionDoneMsg";
static NSString *const NSSendQuestionFailedMsg = @"sendQuestionFailedMsg";
static NSString *const NSLikeThisTitle = @"likeThisTitle";
static NSString *const NSFromTitle = @"fromTitle";
static NSString *const NSDeleteFeedWarningMsg = @"deleteFeedWarningMsg";
static NSString *const NSDeleteCommentWarningMsg = @"deleteCommentWarningMsg";
static NSString *const NSDeleteFeedFailedMsg = @"deleteFeedFailedMsg";
static NSString *const NSDeleteFeedDoneMsg = @"deleteFeedDoneMsg";
static NSString *const NSDeleteCommentFailedMsg = @"deleteCommentFailedMsg";
static NSString *const NSDeleteCommentDoneMsg = @"deleteCommentDoneMsg";
static NSString *const NSFeedTitle = @"feedTitle";
static NSString *const NSLikerTitle = @"likerTitle";
static NSString *const NSNewFeedLoadedMsg = @"newFeedLoadedMsg";
static NSString *const NSNewFeedTitle = @"newFeedTitle";
static NSString *const NSNewCommentTitle = @"newCommentTitle";
static NSString *const NSYearTitle = @"yearTitle";
static NSString *const NSMonthTitle = @"monthTitle";
static NSString *const NSDayTitle = @"dayTitle";

static NSString *const NSHideKeyboardTitle      = @"hideKeyboardTitle";
static NSString *const NSNextItemTitle          = @"nextItemTitle";
static NSString *const NSPublishSupplyTitle = @"publishSupplyTitle";
static NSString *const NSPublishDemandTitle = @"publishDemandTitle";
static NSString *const NSPublishDemandTextTitle = @"publishDemandTextTitle";
static NSString *const NSSupplyTitle = @"supplyTitle";
static NSString *const NSDemandTitle = @"demandTitle";
static NSString *const NSOnlyVisibleForFriendTitle = @"onlyVisibleForFriendTitle";
static NSString *const NSOnlyVisibleForVerifiedTitle = @"onlyVisibleForVerifiedTitle";
static NSString *const NSSupplyDemandInfo = @"supplyDemandInfo";
static NSString *const NSLoadSupplyDemandFailedMsg = @"loadSupplyDemandFailedMsg";
static NSString *const NSSupplyLongTitle = @"supplyLongTitle";
static NSString *const NSDemandLongTitle = @"demandLongTitle";
static NSString *const NSSupplyDemandTagPlaceholderTitle = @"supplyDemandTagPlaceholderTitle";
static NSString *const NSSupplyDemandContentTitle = @"supplyDemandContentTitle";
static NSString *const NSSupplyDemandContentEmptyMsg = @"supplyDemandContentEmptyMsg";
static NSString *const NSSupplyDemandTagsEmptyMsg = @"supplyDemandTagsEmptyMsg";
static NSString *const NSSupplyDemandTagsVerificationMsg = @"supplyDemandTagsVerificationMsg";
static NSString *const NSSelectSupplyDemandTypeMsg = @"selectSupplyDemandTypeMsg";
static NSString *const NSSupplyDemandSearchPlaceholderTitle = @"supplyDemandSearchPlaceholderTitle";
static NSString *const NSSearchTagTitle = @"searchTagTitle";

static NSString *const NSSaveImageTitle = @"saveImageTitle";
static NSString *const NSCopyImageTitle = @"copyImageTitle";

static NSString *const NSManagerTitle = @"managerTitle";
static NSString *const NSIntroductionTitle = @"introductionTitle";
static NSString *const NSHostTitle = @"hostTitle";
static NSString *const NSDetailTitle = @"detailTitle";
static NSString *const NSWinnerTitle = @"winnerTitle";
static NSString *const NSActivityShareTitle = @"activityShareTitle";
static NSString *const NSNoSponsorTitle = @"noSponsorTitle";
static NSString *const NSAdd2CalendarTitle = @"add2CalendarTitle";
static NSString *const NSCalendarTitle = @"calendarTitle";
static NSString *const NSUpdateUserInfoTitle = @"updateUserInfoTitle";
static NSString *const NSUnCheckInButTitle = @"unCheckInButTitle";
static NSString *const NSUpdateUserInfoNote = @"updateUserInfoNote";
static NSString *const NSActivityHostTitle = @"activityHostTitle";
static NSString *const NSActivitySponsorTitle = @"activitySponsorTitle";
static NSString *const NSCheckInTitle = @"checkInButTitle";
static NSString *const NSSignUpTitle = @"signUpButTitle";
static NSString *const NSNoAwardMsg = @"noAwardMsg";
static NSString *const NSFollowTitle = @"followTitle";
static NSString *const NSUnfollowTitle = @"unFollowTitle";

static NSString *const NSPublishTitle = @"publishTitle";
static NSString *const NSPublishSupplyDemandTitle = @"publishSupplyDemandTitle";

static NSString *const NSGroupDeleted   = @"groupDeleted";

#import "WXWTextPool.h"

@interface TextPool : WXWTextPool {
  
}

@end
