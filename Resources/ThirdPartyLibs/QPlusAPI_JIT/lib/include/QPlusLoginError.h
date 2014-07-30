//
//  LoginError.h
//  QPlusAPI
//
//  Created by ouyang on 13-4-27.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#ifndef QPlusAPI_LoginError_h
#define QPlusAPI_LoginError_h

typedef enum
{
    /**
	 * 网络超时
	 */
	TIMEOUT,
	
	/**
	 * 验证失败
	 */
	VERIFY_FAILED,
	
	/**
	 * 当服务器人数过多时，被强制下线
	 */
	FORCE_LOGOUT,
	
	/**
	 * 网络断开
	 */
	NETWORK_DISCONNECT,
}QPlusLoginError;

#endif
