`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Two sine wave outputs�� -10V ~ +10V
//////////////////////////////////////////////////////////////////////////////////
module ad9767_test
(
input sys_clk_p,           // Differential input clock  200Mhz
input sys_clk_n,           // Differential input clock  200Mhz 

output da1_clk,             //AD9767 CH1 clock
output da1_wrt,             //AD9767 CH1 enable
output [13:0] da1_data,     //AD9767 CH1 data output

output da2_clk,             //AD9767 CH2 clock
output da2_wrt,	         //AD9767 CH2 enable
output [13:0] da2_data,      //AD9767 CH2 data output
output fan_pwm
);


reg [9:0] rom_addr;

wire [13:0] rom_data;
wire clk_125M;

//ͨ��1
assign da1_clk=clk_125M;
assign da1_wrt=clk_125M;
assign da1_data=rom_data;
//ͨ��2
assign da2_clk=clk_125M;
assign da2_wrt=clk_125M;
assign da2_data=rom_data;
assign fan_pwm =1'b0;//���ȿ���
//===========================================================================
// ���ʱ��ת���ɵ���ʱ��
//===========================================================================
wire sys_clk_ibufg;
IBUFGDS u_ibufg_sys_clk
 (
  .I  (sys_clk_p),            
  .IB (sys_clk_n),          
  .O  (sys_clk_ibufg)        //Differential clock converted to single terminal clock
  );

//DA output sin waveform
always @(negedge clk_125M)
begin
 //rom_addr <= rom_addr + 1'b1 ;              //The output sine wave frequency is 122Khz Ƶ���ɲ�����������������
 //rom_addr <= rom_addr + 4 ;              //The output sine wave frequency is 488Khz������Ƶ�ʲ��䣬��������١�
 rom_addr <= rom_addr + 128 ;            //The output sine wave frequency is 15.6Mhz								
end 



ROM ROM_inst
(
.clka(clk_125M), // input clka
.addra(rom_addr), // input [8 : 0] addra
.douta(rom_data) // output [7 : 0] douta
);


PLL PLL_inst
(// Clock in ports
.clk_in1    (sys_clk_ibufg  ),      // IN
// Clock out ports
.clk_out1   (clk_125M       ),     // OUT
// Status and control signals
.reset      (1'b0           ),      // IN
.locked     (               )
);      

endmodule
