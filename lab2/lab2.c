#include "xparameters.h"
#include "xgpio.h"
int main (void)
{
XGpio dip, push;
int psb_check, dip_check;

xil_printfStart of the Program --\r\n");
XGpio_Initialize(&dip,XPAR_SWITCHES_DEVICE_ID);
XGpio_SetDataDirection(&dip, 1,0xffffffff);
XGpio_Initialize(&push, XPAR_BUTTONS_DEVICE_ID);
XGpio_SetDataDirection(&push, 1, Qxffffffff);
while (1)
{
    psb_check = XGpio_DiscreteRead(&push, 1);
    xil_printf("Push Buttons Status %x\r\n", psb_check);
    dip_check = XGpio_DiscreteRead(&dip, 1);
    xil_printf("DIP Switch Status %x\r\n", dip_check);
    sleep(1);
}
}
