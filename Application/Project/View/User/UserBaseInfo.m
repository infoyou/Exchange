//
//  UserBaseInfo.m
//  Project
//
//  Created by user on 13-9-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "UserBaseInfo.h"
#import "UserProperty.h"

@implementation UserBaseInfo

- (void)parseValueProperties {
    
    if (![self.groups isEqual:[NSNull null]] && self.groups.count) {
        UserProperty *up = (UserProperty *)self.groups[0];
        
        if (up.values.count > PORTRAITNAME_INDEX) self.portraitName = up.values[PORTRAITNAME_INDEX];
        if (up.values.count > CHNAME_INDEX)    self.chName = up.values[CHNAME_INDEX];
        if (up.values.count > ENNAME_INDEX)   self.enName = up.values[ENNAME_INDEX];
        if (up.values.count > COMPANY_INDEX)   self.company = up.values[COMPANY_INDEX];
        if (up.values.count > DEPARTMENT_INDEX)   self.department = up.values[DEPARTMENT_INDEX];
        if (up.values.count > POSITION_INDEX)   self.position = up.values[POSITION_INDEX];
        if (up.values.count > CITY_INDEX)   self.city = up.values[CITY_INDEX];
        if (up.values.count > ADDRESS_INDEX)   self.address = up.values[ADDRESS_INDEX];
        
        if (self.groups.count >=2) {
            
            UserProperty *up2 = (UserProperty *)self.groups[1];
            
            if (up2.values.count > PHONE_INDEX) self.phone = up2.values[PHONE_INDEX];
            if (up2.values.count > WEIXUN_INDEX)    self.weixin = up2.values[WEIXUN_INDEX];
            if (up2.values.count > EMAIL_INDEX)   self.email = up2.values[EMAIL_INDEX];
        }
    }
}

@end
