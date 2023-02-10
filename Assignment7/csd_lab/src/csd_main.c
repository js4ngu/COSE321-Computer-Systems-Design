#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include <xgpio.h>
#include "sleep.h"
#include "xparameters.h"

int csd_main()
{
	init_platform();
	printf("TTT\r\n");	
    cleanup_platform();
    return 0;
}
