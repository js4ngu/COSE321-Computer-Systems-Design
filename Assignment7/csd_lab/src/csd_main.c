/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"




int csd_main() {
    init_platform();

    static int hour = 0;
    static int min = 0;
    static int sec = 0;

	xil_printf("%d : %d : %d\r", hour, min, sec);
    cleanup_platform();
    sec++;
    if (sec >= 60) {
        xil_printf("%d : %d :   \r", hour, min, sec);
        sec = 0;
        min++;
    }
    if (min >= 60) {
        min = 0;
        hour++;
    }    
    return 0;
}
