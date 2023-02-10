#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include <xgpio.h>
#include "sleep.h"
#include "xparameters.h"
#include "sleep.h"

void _sleep();
int duration_set();

int csd_main() {
	XGpio LED;
	int led_staus = 0x01;
	int duration;
	XGpio_Initialize(&LED, 		XPAR_LEDS_DEVICE_ID);	//initialize input XGpio variable
	init_platform();

	duration = duration_set();
	while (1) {
		_sleep(duration);
		XGpio_DiscreteWrite(&LED, 1, led_staus);
		led_staus = led_staus << 1;
		if (led_staus > 0x80){
			led_staus = 0x01;
			duration = duration_set();
		} 
	}

    cleanup_platform();
    return 0;
}

void _sleep(int sel){
	/*
	XGpio dipSW;
	int dipSW_status;
   	XGpio_Initialize(&dipSW,	XPAR_SWITCHES_DEVICE_ID);	//initialize input XGpio variable
	XGpio_SetDataDirection(&dipSW, 1, 0xFF);
	dipSW_status = XGpio_DiscreteRead(&dipSW, 1);// if you wany input set 1
	*/

	if (sel == 1)		usleep(100000);
	else if (sel == 2)	usleep(200000);
	else if (sel == 4)	usleep(300000);
	else if (sel == 8)	usleep(400000);
	else if (sel == 16)	usleep(500000);
	else if (sel == 32)	usleep(600000);
	else if (sel == 64)	usleep(700000);
	else if (sel == 128)usleep(800000);
	else 				usleep(1000000);
}

int duration_set(){
	int sel;
	printf("----------------- LED On Duration ----------------\r\n");
	printf("1. 100ms 2. 200ms 3. 300ms 4. 400 ms\r\n");
	printf("5. 500ms 6. 600ms 7. 700ms 8. 1 sec\r\n");
	printf("---------------------------------------------------\r\n");
	printf("Select:\r\n");

	while (1) {
		scanf("%d", &sel);
		if (sel != NULL) break;
	}
	return sel;
}