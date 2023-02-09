#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include <xgpio.h>
#include "sleep.h"
#include "xparameters.h"

int csd_main()
{
//	usleep(100000);

	XGpio dipSW;
	int dipSW_status;
   	XGpio_Initialize(&dipSW, XPAR_SWITCHES_DEVICE_ID);	//initialize input XGpio variable
	XGpio_SetDataDirection(&dipSW, 1, 0xFF);
	
	init_platform();
	dipSW_status = XGpio_DiscreteRead(&dipSW, 1);// if you wany input set 1
	printf("%d\r\n", dipSW_status);
	if (dipSW_status == 1)			usleep(100000);
	else if (dipSW_status == 2)		usleep(200000);
	else if (dipSW_status == 4)		usleep(300000);
	else if (dipSW_status == 8)		usleep(400000);
	else if (dipSW_status == 16)	usleep(500000);
	else if (dipSW_status == 32)	usleep(600000);
	else if (dipSW_status == 64)	usleep(700000);
	else if (dipSW_status == 128)	usleep(800000);
	else 							usleep(1000000);

    cleanup_platform();
    return 0;
}

int blink(){
	//printf("Blink\r\n");
}
