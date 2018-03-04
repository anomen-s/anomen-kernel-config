/**************************************************************************************************
 *                     Banana Pi AXP209 Power Management Chip Handler
 *
 * Author:	Dirk Hohmann
 * Copyright:   2015
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ***************************************************************************************************/
 	
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define DEBUG_AXP209 0	/*Print executed command lines*/

#define MAX_BUFFER 255 /*Buffer for Return Codes*/

#define REG_POWER_STATUS 	0x00
#define REG_POWER_MODE		0x01
#define REG_POWER_CONTROL 	0x12
#define REG_BAT_SHUTDOWN	0x31
#define REG_ADC_ENABLE_1  	0x82
#define REG_ADC_ENABLE_2  	0x83
#define REG_ADC_RATE		0x84


/*Current Values (Highbyte-Regs, Lowbyte is always +1)*/
#define REG_ACIN_CURRENT	0x58
#define REG_VBUS_CURRENT	0x5C
#define REG_BAT_CURRENT_DCHG  	0x7C
#define REG_BAT_CURRENT_CHG  	0x7A

/*Voltage Values (Highbyte-Regs, Lowbyte is always +1)*/
#define REG_ACIN_VOLT		0x56
#define REG_VBUS_VOLT		0x5A
#define REG_BAT_VOLT  		0x78
#define REG_IPSOUT_VOLT		0x7E

/*Temperature (Highbyte-Regs, Lowbyte is always +1)*/
#define REG_TEMPERATURE		0x5E

/*Power from Battery (first of three Regs)*/
#define REG_POWER		0x70

#define REG_CHG_CTRL_1		0x33
#define REG_CHG_CTRL_2		0x34
#define REG_BAKBAT_CTRL		0x35

/*Coulomb Counters: first four are charge, next four are discharge*/
#define REG_COULOMB		0xB0
#define REG_COULOMB_CTRL	0xB8

#define VOLT_VBUS	0	/*USB OTG Connector*/
#define VOLT_ACIN	1	/*Main Power Supply*/
#define VOLT_BAT	2	/*Battery*/
#define VOLT_IPSOUT	3	/*Output of Power-Selector (can be Ubat or Main Supply)*/

#define CUR_VBUS	0	/*Current from USB OTG Connector*/
#define CUR_ACIN	1	/*Main Supply Current*/
#define CUR_BAT_DCHG	2	/*Discharge Current*/
#define CUR_BAT_CHG	3	/*Charge Current*/

/*Available Power Sources*/
#define PAVAIL_MAIN	0x01
#define PAVAIL_USB_OTG	0x02
#define PAVAIL_BAT	0x04

/*Battery Status*/
#define BSTAT_AVAIL	0x01
#define BSTAT_CHARGE	0x02
#define BSTAT_DISCHARGE	0x04
#define BSTAT_HOT	0x08
#define BSTAT_LOWVOLT	0x10
#define BSTAT_ERR_CUR	0x20
#define BSTAT_ERR_ACT	0x40
#define BSTAT_CHG_ENA   0x80
#define BSTAT_CBAL_ENA  0x100

/*Current and Voltage Value Conversion*/
const struct{
	unsigned char reg;
	float scale;
}Currents[4]={
	{REG_VBUS_CURRENT,0.375f},
	{REG_ACIN_CURRENT,0.625f},
	{REG_BAT_CURRENT_DCHG,1.0f}, /*data sheet says 0.5, but I measured 1.0 !*/
	{REG_BAT_CURRENT_CHG,0.5f}
};

const struct{
	unsigned char reg;
	float scale;
}Voltages[4]={
	{REG_VBUS_VOLT,1.7f},
	{REG_ACIN_VOLT,1.7f},
	{REG_BAT_VOLT,1.1f},
	{REG_IPSOUT_VOLT,1.4f}
};
 	
	

/*Read Register of AXP209*/
int readAXP209(unsigned char reg)
{
	FILE *f;
        char cmd[30];
        char out[MAX_BUFFER];
	char *p0,*p1;
	int val;

	/*Use i2cget command to access I2C-Bus*/
	sprintf(cmd,"i2cget -y -f 0 0x34 0x%x",(int)reg);

	#if DEBUG_AXP209
	   printf("CMD: %s\n",cmd);
	#endif

        f = popen(cmd, "r");
        while ( fgets(out, MAX_BUFFER, f) != NULL )
        pclose(f);

	p0=strchr(out,'x');
	if(p0){
	  val=(int)strtol(p0+1,&p1,16);
	}

	#if DEBUG_AXP209
	   printf("Retval: 0x%x\n",val);
	#endif

	return val;
}

/*Write Register of AXP209*/
void writeAXP209(unsigned char reg,unsigned char val)
{
        char cmd[34];

	/*Use i2cset command to access I2C-Bus*/
	sprintf(cmd,"i2cset -y -f 0 0x34 0x%x 0x%x",(int)reg,(int)val);
	
	#if DEBUG_AXP209
	  printf("CMD: %s\n",cmd);
	#endif

        system(cmd);
}


/*get measured Currents in Milliamperes*/
int getCurrent_mA(int sel){
	int val0,val1,current;

	val0=readAXP209(Currents[sel].reg);
	val1=readAXP209(Currents[sel].reg+1);

	current=((val0<<4)|(val1 & 0x0F));

	current=(int)((float)current*Currents[sel].scale);

	return 	current;
}

/*get measured Voltages in Millivolts*/
int getVoltage_mV(int sel){
	int val0,val1,voltage;

	val0=readAXP209(Voltages[sel].reg);
	val1=readAXP209(Voltages[sel].reg+1);

	voltage=((val0<<4)|(val1 & 0x0F));

	voltage=(int)((float)voltage*Voltages[sel].scale);

	return 	voltage;
}

/*get Temperature of AXP209 internal Sensor*/
int getTemperature_C(void){
	int val0,val1,voltage;
	int temperature;

	val0=readAXP209(REG_TEMPERATURE);
	val1=readAXP209(REG_TEMPERATURE+1);

	temperature=((val0<<4)|(val1 & 0x0F));
	temperature=(int)((float)temperature*0.1f-144.7f);
	
	return temperature;
}

/*get currentz Battery discharge Power in Milliwatts*/
long getPower_mW(void){
	long val0,val1,val2;
	long  power;

	val0=readAXP209(REG_POWER);
	val1=readAXP209(REG_POWER+1);
	val2=readAXP209(REG_POWER+2);

	power=((val0<<16)|(val1<<8)|val2);
	power=(long)((float)power/1100.0f);  /*compared with measured values...*/
	
	return power;
}

/*get Battery Charge Balance in mAh*/
long getCoulomb_mAh(void){
	int rate_sel;
	float adc_rate[4]={25.0f,50.0f,100.0f,200.0f};
	long val0,val1,val2,val3;
	long  coulomb,coulomb_chg,coulomb_dchg;

	rate_sel=(readAXP209(REG_ADC_RATE) & 0xC0)>>6; //ADC Sample Rate needed for calculation

	val0=readAXP209(REG_COULOMB);
	val1=readAXP209(REG_COULOMB+1);
	val2=readAXP209(REG_COULOMB+2);
	val3=readAXP209(REG_COULOMB+3);


	coulomb_chg=((val0<<24)|(val1<<16)|(val2<<8)|val3); //Charge Counter

	val0=readAXP209(REG_COULOMB+4);
	val1=readAXP209(REG_COULOMB+5);
	val2=readAXP209(REG_COULOMB+6);
	val3=readAXP209(REG_COULOMB+7);

	coulomb_dchg=((val0<<24)|(val1<<16)|(val2<<8)|val3); //Discharge Counter

	coulomb=(long)(65536.0f*0.5f*(float)(coulomb_chg-coulomb_dchg)/3600.0/adc_rate[rate_sel]);
	
	return coulomb;
}


/*Convert Available Power Source Bitfield to Text*/ 
char* cnvAvailTxt(int a){
	static char avail[20];
	avail[0]=0;
	int first=1;

	if(a & PAVAIL_MAIN){
		strcat(avail,"MAIN");
		first=0;
	}

	if(a & PAVAIL_USB_OTG){
		if(!first) strcat(avail," ");
		strcat(avail,"USB-OTG");
		first=0;
	}
	
	if(a & PAVAIL_BAT){
		if(!first) strcat(avail," ");
		strcat(avail,"BAT");
	}
	return avail;
}

/*get Battery Low Voltage Limit*/
int getBatteryLowVoltLevel_mV(void){
	int val;

	/*Battery Threshold*/
	val=readAXP209(REG_BAT_SHUTDOWN);
	val=(val & 0x07)*100+2600;

	return val;
}


/*get Battery Charge Voltage Limit (usually 4200mV)*/
int getBatteryChargeVoltage_mV(void){
	static const int voltages[4]={4100,4150,4200,4360};
	int val;

	val=readAXP209(REG_CHG_CTRL_1);
	
	return voltages[(val>>5) & 0x3];
}

/*get Battery Charge Current*/
int getBatteryChargeCurrent_mA(void){
	int val;
	val=readAXP209(REG_CHG_CTRL_1);

	val=300+(val & 0x0F)*100;	
	return val;
}

/*get Battery Pre Charge Time*/
int getBatteryPreChargeTimeout_minutes(void){
	int val;
	val=readAXP209(REG_CHG_CTRL_2);

	val=40+((val>>6) & 0x03)*10;	
	return val;
}

/*get Battery Constant Current Charging Time*/
int getBatteryConstCurrentTimeout_hours(void){
	int val;
	val=readAXP209(REG_CHG_CTRL_2);

	val=6+(val & 0x03)*2;	
	return val;
}

/*Set Low Voltage Limit for Battery*/
int setBatteryLowVoltLevel_mV(int v){
	int val;

	val=readAXP209(REG_BAT_SHUTDOWN);
	val&=~0x07;

	val|=((v-2600)/100) & 0x07;
	
	writeAXP209(REG_BAT_SHUTDOWN,val);

	return getBatteryLowVoltLevel_mV()==v;
}

/*Set Battery Charge Voltage Limit (Std LiIon with Manganese usually 4200 mV)*/
int setBatteryChargeVoltage_mV(int v){
	int val;
	
	val=readAXP209(REG_CHG_CTRL_1);

	val&=~0x60;
	if(v==4150){
		val|=0x20;
	}
	else if(v==4200){
		val|=0x40;
	}
	else if(v==4360){
		val|=0x60;
	}

	writeAXP209(REG_CHG_CTRL_1,val);

	return getBatteryChargeVoltage_mV()==v;
}

/*Set Battery Charge Current*/
int setBatteryChargeCurrent_mA(int v){
	int val;

	val=readAXP209(REG_CHG_CTRL_1);
	val&=~0x0F;
	val|=((v-300)/100) & 0x0F;
	writeAXP209(REG_CHG_CTRL_1,val);

	return getBatteryChargeCurrent_mA()==v;
}

/*Set Timeout for Battery Precharge*/
int setBatteryPreChargeTimeout_minutes(int v){
	int val;

	val=readAXP209(REG_CHG_CTRL_2);
	val&=~0xC0; 
	val|=(((v-40)/10) & 0x03)<<6;
	writeAXP209(REG_CHG_CTRL_2,val);

	return getBatteryPreChargeTimeout_minutes()==v;
}

/*Set Timeout for Constant Current Charging*/
int setBatteryConstCurrentTimeout_hours(int v){
	int val;
	val=readAXP209(REG_CHG_CTRL_2);

	val&=~0x03;
	val|=((v-6)/2) & 0x3;
	writeAXP209(REG_CHG_CTRL_2,val);

	return getBatteryConstCurrentTimeout_hours()==v;
}

/*Check for Low Battery Voltage*/
int lowBat(void){
	return getBatteryLowVoltLevel_mV()>=getVoltage_mV(VOLT_BAT) ? 1:0;
}


/*Check for available Power Sources*/
int getAvailableSupplies(void){
	int val;
	int pavail=0;

	val=readAXP209(REG_POWER_STATUS);
	if(val & 0x80){  //ACIN present
		if(val & 0x40){ //ACIN available
			pavail|=PAVAIL_MAIN;
		}
	}
	
	if(val & 0x20){  //VBUS present
		if(val & 0x10){ //VBUS available
			pavail|=PAVAIL_USB_OTG;
		}
	}

	val=readAXP209(REG_POWER_MODE);	
	if(val & 0x20){  //Battery connected
		if(!lowBat()){ //Vbat must be greater than Shutdown-Voltage
			pavail|=PAVAIL_BAT;
		}
	}

	return pavail;
}


/*Convert Battery Status Bitfield to Text*/
char *cnvBStatTxt(int s){
	static char bstat[200];
	bstat[0]=0;
	int first=1;

	if(s & BSTAT_AVAIL){
		strcat(bstat,"AVAIL");
		first=0;
	}

	if(s & BSTAT_CHARGE){
		if(!first) strcat(bstat," ");
		strcat(bstat,"CHARGE");
		first=0;
	}
	
	if(s & BSTAT_DISCHARGE){
		if(!first) strcat(bstat," ");
		strcat(bstat,"DISCHARGE");
		first=0;
	}

	if(s & BSTAT_HOT){
		if(!first) strcat(bstat," ");
		strcat(bstat,"HOT");
		first=0;
	}

	if(s & BSTAT_LOWVOLT){
		if(!first) strcat(bstat," ");
		strcat(bstat,"LOWVOLT");
		first=0;
	}

	if(s & BSTAT_ERR_CUR){
		if(!first) strcat(bstat," ");
		strcat(bstat,"ERR-CURRENT");
		first=0;
	}

	if(s & BSTAT_ERR_ACT){
		if(!first) strcat(bstat," ");
		strcat(bstat,"ERR-CHARGE");
		first=0;
	}

	if(s & BSTAT_CHG_ENA){
		if(!first) strcat(bstat," ");
		strcat(bstat,"CHARGE-ENA");
		first=0;
	}

	if(s & BSTAT_CBAL_ENA){
		if(!first) strcat(bstat," ");
		strcat(bstat,"BALANCE-CNT");
	}

	return bstat;

}

/*Return Battery Status as Bitfield*/
int getBatteryStatus(void){
	int stat=0;
	int val;

	val=readAXP209(REG_POWER_MODE);

	if(val & 0x20){
	 	stat=BSTAT_AVAIL;
		if(lowBat()) stat|=BSTAT_LOWVOLT;
		if(val & 0x40) stat|=BSTAT_CHARGE;
		if(val & 0x80) stat|=BSTAT_HOT;
		if(val & 0x04) stat|=BSTAT_ERR_CUR;
		if(val & 0x08) stat|=BSTAT_ERR_ACT;
		if(readAXP209(REG_CHG_CTRL_1) & 0x80)stat|=BSTAT_CHG_ENA;
		if(readAXP209(REG_COULOMB_CTRL) & 0x80)stat|=BSTAT_CBAL_ENA;
		if(!((readAXP209(REG_POWER_STATUS) & 0x04)) && (getCurrent_mA(CUR_BAT_DCHG)>0)) stat|=BSTAT_DISCHARGE;
}

	return stat;
}

/*Enable/Disable Battery-Charge function*/
int setBatterChargeEnable(int v){
	int val;

	val=readAXP209(REG_CHG_CTRL_1);
	if(v) val|=0x80;
	else val &=~0x80;
	writeAXP209(REG_CHG_CTRL_1,val);

	return (readAXP209(REG_CHG_CTRL_1) & 0x80) ? v!=0:v==0;
}

/*Disable Supply for USB, SD-CARD,...*/
int disableExtPower(void){
	int val;
	val=readAXP209(REG_POWER_CONTROL);

	val&=~0x01;
	writeAXP209(REG_POWER_CONTROL,val);

	return (readAXP209(REG_POWER_CONTROL) & 0x01) ? 1:0;
}

/*Enable/Disable Battery-Charge Balance Counter function*/
int setBatterChargeBalanceCtrEnable(int v){
	int val;

	val=readAXP209(REG_COULOMB_CTRL);
	if(v) val|=0x80;
	else val &=~0x80;
	writeAXP209(REG_COULOMB_CTRL,val);

	return (readAXP209(REG_COULOMB_CTRL) & 0x80) ? v!=0:v==0;
}

/*Reset Battery-Charge Balance Counter*/
void resetBatterChargeBalanceCtr(void){
	int val;

	val=readAXP209(REG_COULOMB_CTRL);
	val|=0x20;
	writeAXP209(REG_COULOMB_CTRL,val);
}

void shutdownMonitor(void){
	int val;

	for(;;){
	  val=readAXP209(REG_POWER_STATUS);
	  if(!(val & 0x80)){ //no Main Power Available
	    system("poweroff");
	    exit(0);	  
	  }
	  sleep(1);
	}
}

/*get end of charge limit in percent*/
int getBatterEndOfCharge_percent(void){
	int val;

	val=readAXP209(REG_CHG_CTRL_1);

	return (readAXP209(REG_CHG_CTRL_1) & 0x10) ? 15:10;
}

/*set end of charge limit in percent*/
int setBatterEndOfCharge_percent(int v){
	int val;

	val=readAXP209(REG_CHG_CTRL_1);
	if(v==15) val|=0x10;
	else val &=~0x10;

	writeAXP209(REG_CHG_CTRL_1,val);

	return getBatterEndOfCharge_percent()==v;
}


int main(int argc,char **argv)
{
	int val;
	
	if(argc<=1){
	  puts("axp209 <cmd> [parm] (SUPERUSER required !)\n");
	  puts("cmd         function");
	  puts("-----------------------------------------------------------------");
	  puts("all         Print all infos as readable text");
	  puts("init        Useful Config: ADC-Setup, start Charge Balancing");
	  puts("monitor     Monitor Main Supply and call 'poweroff' if Vbat is on");
	  puts("pavail      Available Power Sources");
	  puts("             Bit 0: Main Power");
	  puts("             Bit 1: USB OTG");
	  puts("             Bit 2: Battery");
	  puts("bstat       Battery Status");
	  puts("             Bit 0: Battery connected");
	  puts("             Bit 1: Charging");
	  puts("             Bit 2: Discharging");
	  puts("             Bit 3: High Temperature");
	  puts("             Bit 4: Low Voltage");
	  puts("             Bit 5: Error Low Charge Current");
	  puts("             Bit 6: Error Low Voltage Charge Mode");
	  puts("             Bit 7: Charge Function Enabled");
	  puts("             Bit 8: Change Balance Counter Enabled");
	  puts("mainvolt    Main Supply Voltage");
	  puts("usbvolt     USB OTG Voltage");
	  puts("batvolt     Battery Volatge");
	  puts("swvolt 	    Power Switch Voltage");
	  puts("maincur     Main Supply Current");
	  puts("usbcur      USB OTG Current");
	  puts("batdcur     Battery Discharge Current");
	  puts("batccur     Battery Charge Current");
	  puts("temp        Device Temperature in Celsius");
	  puts("batpwr      Battery Discharge Power in mW");
	  puts("batbalance  Charge Balance in mAh");
	  puts("gbatlowvolt get Battery Low Voltage Limit");
	  puts("gbatchgvolt get Battery Charge Voltage Limit");
	  puts("gbatchgcur  get Battery Charge Current");
	  puts("gbatpctime  get Battery PreCharge Time in Minutes");
	  puts("gbatcctime  get Battery Constant Current Time in Hours");
	  puts("gbateoc     get Battery End Of Charge Limit in Percent");
	  puts("sbatlowvolt set Battery Low Voltage Limit");
	  puts("sbatchgvolt set Battery Charge Voltage Limit");
	  puts("sbatchgcur  set Battery Charge Current");
	  puts("sbatpctime  set Battery PreCharge Time in Minutes");
	  puts("sbatcctime  set Battery Constant Current Time in Hours");
	  puts("sbateoc     set Battery End Of Charge Limit in Percent");
	  puts("encbal      enable charge balance counter");
	  puts("discbal     disable charge balance counter");
	  puts("rstcbal     reset charge balance counter");
	  puts("enchg       enable charge function");
	  puts("dischg      disable charge function");
	  puts("disexpwr    disable USB and SD-Card Power ONE WAY !!!");
	  puts("\nAll voltages in Millivolts, all currents in Milliamperes");
	  puts("Set functions verify the desired value by readback and return 'OK'.");
	}
	else{
	  /*ADC Enable for all useful inputs*/
	  if(readAXP209(REG_ADC_ENABLE_1)!=0xFF){
		#if DEBUG_AXP209
		  puts("Write ADC Enable to 0xFF\n");
		#endif
		writeAXP209(REG_ADC_ENABLE_1,0xFF);
		sleep(1); /*wait for first conversion*/
	  }

	  if(strstr(argv[1],"all")){
		puts("===============  Power Management Status =================\n");
		printf("Power Sources:  %s\n",cnvAvailTxt(getAvailableSupplies()));
		printf("Battery Status: %s\n",cnvBStatTxt(getBatteryStatus()));
		printf("Main Supply     %i mV\n",getVoltage_mV(VOLT_ACIN));
		printf("USB OTG         %i mV\n",getVoltage_mV(VOLT_VBUS));
		printf("Battery         %i mV\n",getVoltage_mV(VOLT_BAT));
		printf("Power Switch    %i mV\n",getVoltage_mV(VOLT_IPSOUT));
		printf("Main Supply     %i mA\n",getCurrent_mA(CUR_ACIN));
		printf("USB OTG         %i mA\n",getCurrent_mA(CUR_VBUS));
		printf("Discharge       %i mA\n",getCurrent_mA(CUR_BAT_DCHG));
		printf("Charge          %i mA\n",getCurrent_mA(CUR_BAT_CHG));
		printf("Temperature     %i C\n",getTemperature_C());
		printf("Battery Power   %i mW\n",getPower_mW());
		printf("Charge Balance  %i mAh\n",getCoulomb_mAh());
		printf("Bat Low Volt:   %i mV\n",getBatteryLowVoltLevel_mV());
		printf("Bat Chg Volt:   %i mV\n",getBatteryChargeVoltage_mV());
		printf("Bat Chg Cur:    %i mA\n",getBatteryChargeCurrent_mA());
		printf("Bat PreChg:     %i Minutes\n",getBatteryPreChargeTimeout_minutes());
		printf("Bat ConstCur:   %i Hours\n",getBatteryConstCurrentTimeout_hours());
		printf("Bat EOC Limit:  %i %%\n",getBatterEndOfCharge_percent());
		#if 0  /*Test*/
		  printf("\nsetBatteryLowVoltLevel %i\n",setBatteryLowVoltLevel_mV(2800));
		  printf("setBatteryChargeVoltage %i\n",setBatteryChargeVoltage_mV(4150));
		  printf("setBatteryChargeCurrent %i\n",setBatteryChargeCurrent_mA(500));
		  printf("setBatteryPreChargeTimeout %i\n",setBatteryPreChargeTimeout_minutes(60));
		  printf("setBatteryConstCurrentTimeout %i\n",setBatteryConstCurrentTimeout_hours(10));
		  printf("setBatterEndOfCharge_percent %i\n",setBatterEndOfCharge_percent(15));
		#endif
        	puts("=============================================================\n");
	  }

	  if(strstr(argv[1],"init")){
		setBatterChargeBalanceCtrEnable(1);
		setBatterChargeEnable(1);
	  }

	  if(strstr(argv[1],"monitor")){
		shutdownMonitor();
	  }

	  if(strstr(argv[1],"pavail")) printf("%i\n",getAvailableSupplies());
	  if(strstr(argv[1],"bstat")) printf("%i\n",getBatteryStatus());
	  if(strstr(argv[1],"mainvolt")) printf("%i\n",getVoltage_mV(VOLT_ACIN));
	  if(strstr(argv[1],"usbvolt")) printf("%i\n",getVoltage_mV(VOLT_VBUS));
	  if(strstr(argv[1],"batvolt")) printf("%i\n",getVoltage_mV(VOLT_BAT));
	  if(strstr(argv[1],"swvolt")) printf("%i\n",getVoltage_mV(VOLT_IPSOUT));
	  if(strstr(argv[1],"maincur")) printf("%i\n",getCurrent_mA(CUR_ACIN));
	  if(strstr(argv[1],"usbcur")) printf("%i\n",getCurrent_mA(CUR_VBUS));
	  if(strstr(argv[1],"batdcur")) printf("%i\n",getCurrent_mA(CUR_BAT_DCHG));
	  if(strstr(argv[1],"batccur")) printf("%i\n",getCurrent_mA(CUR_BAT_CHG));
	  if(strstr(argv[1],"temp")) printf("%i\n",getTemperature_C());
	  if(strstr(argv[1],"batpwr")) printf("%i\n",getPower_mW());
	  if(strstr(argv[1],"batbalance")) printf("%i\n",getCoulomb_mAh());
	  if(strstr(argv[1],"gbatlowvolt")) printf("%i\n",getBatteryLowVoltLevel_mV());
	  if(strstr(argv[1],"gbatchgvolt")) printf("%i\n",getBatteryChargeVoltage_mV());
	  if(strstr(argv[1],"gbatchgcur")) printf("%i\n",getBatteryChargeCurrent_mA());
	  if(strstr(argv[1],"gbatpctime")) printf("%i\n",getBatteryPreChargeTimeout_minutes());
	  if(strstr(argv[1],"gbatcctime")) printf("%i\n",getBatteryConstCurrentTimeout_hours());
	  if(strstr(argv[1],"gbateoc")) printf("%i\n",getBatterEndOfCharge_percent());
	  if(strstr(argv[1],"sbatlowvolt")) printf("%s\n",setBatteryLowVoltLevel_mV(atoi(argv[2])) ? "OK":"FAIL");
	  if(strstr(argv[1],"sbatchgvolt")) printf("%s\n",setBatteryChargeVoltage_mV(atoi(argv[2])) ? "OK":"FAIL");
	  if(strstr(argv[1],"sbatchgcur")) printf("%s\n",setBatteryChargeCurrent_mA(atoi(argv[2])) ? "OK":"FAIL");
	  if(strstr(argv[1],"sbatpctime")) printf("%s\n",setBatteryPreChargeTimeout_minutes(atoi(argv[2])) ? "OK":"FAIL");
	  if(strstr(argv[1],"sbatcctime")) printf("%s\n",setBatteryConstCurrentTimeout_hours(atoi(argv[2])) ? "OK":"FAIL");
	  if(strstr(argv[1],"sbateoc")) printf("%s\n",setBatterEndOfCharge_percent(atoi(argv[2])) ? "OK":"FAIL");
	  if(strstr(argv[1],"encbal"))  if(setBatterChargeBalanceCtrEnable(1)) puts("OK\n"); else puts("FAIL\n");
	  if(strstr(argv[1],"discbal")) if(setBatterChargeBalanceCtrEnable(0)) puts("OK\n"); else puts("FAIL\n");
	  if(strstr(argv[1],"rstcbal")){
		resetBatterChargeBalanceCtr();
		puts("OK\n"); 
	  }
	  if(strstr(argv[1],"enchg")) if(setBatterChargeEnable(1)) puts("OK\n"); else puts("FAIL\n");
	  if(strstr(argv[1],"dischg")) if(setBatterChargeEnable(0)) puts("OK\n"); else puts("FAIL\n");
	  if(strstr(argv[1],"disexpwr")){
		printf("OK\n");
		disableExtPower();
	  }			

	}
}
