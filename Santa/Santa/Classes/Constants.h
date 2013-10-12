//
//  Constants.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#define offsetX 50
#define offsetY 31

typedef enum
{
	MoveDirectionNone = 0,

	MoveDirectionLowerRight,
	MoveDirectionUpperRight,
    MoveDirectionLowerLeft,
    MoveDirectionUpperLeft,
    
	MAX_MoveDirections,
} EMoveDirection;

