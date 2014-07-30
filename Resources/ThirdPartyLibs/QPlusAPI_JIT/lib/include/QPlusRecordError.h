//
//  QPlusRecordError.h
//  QPlusAPI
//
//  Created by 陈 奕奕 on 13-5-2.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#ifndef QPlusAPI_QPlusRecordError_h
#define QPlusAPI_QPlusRecordError_h


typedef enum
{
    /**
	 * 录音时间过短，少于1秒
	 */
	VOICE_TOO_SHORT,
	
	/**
	 * 录音设备正在被使用
	 */
	RECORDER_BUSY,
	
	/**
	 * 未知错误，一般是因为发生了异常
	 */
	UNKNOWN_ERROR_RECORDER
}QPlusRecordError;

#endif
