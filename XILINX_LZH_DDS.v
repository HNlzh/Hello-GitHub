//---------------------------------------------------------------------------
//--	文件名		:	XILINX_LZH_DDS.v
//--	作者		:	刘大大
//--	描述		:	项目顶层模块
//--	修订历史	:	2017-6-26
//---------------------------------------------------------------------------
module XILINX_LZH_DDS
(
    CLK_50M,
	 RST_N,
	 RS,
	 E,
	 RW,
	 DATA_O,
	 DA_CLK,
	 DA_DIN,
	 DA_CS,
	 DA_CLR,
	 //
	 finish_flag,
	 start_flag,
    DA_data,
    DA_start,
    detect_edge,
    fsm,
	 CLK
);
input            CLK_50M; 
input            RST_N;  
 
output   RS;             
output   E;       
output   RW;      
output   [7:0]DATA_O;//lcd的八位数据，后期使用4位分开传。
output 	DA_CLK;		 		
output	DA_DIN;		 
output	DA_CS;     
output   DA_CLR;     
//
output finish_flag;
output start_flag;
output [11:0]DA_data;
output DA_start;
output [1:0]detect_edge;
output [5:0]fsm;
output CLK;
//
wire     CLK;	       
wire     [ 5:0]fsm;  
wire     [1:0]detect_edge;
wire     DA_start;	
wire     [11:0]DA_data;				
wire     [15:0]data1;
wire     [4:0] addr1;
wire     [15:0]data2;
wire     [4:0] addr2; 
wire     [15:0] traffic; 		
wire     finish_flag;
wire     start_flag;	
Frequency_converter  AA
(
    CLK_50M,RST_N,
	 CLK
);
LCD1602_Interface   BB 
(
.traffic(traffic[7:0]),
.traffic_start(start_flag),
.traffic_Choice(traffic[14]),
.CLK(CLK),
.RST_N(RST_N),
.E(E),
.RS(RS),
.RW(RW),
.DATA_O(DATA_O),
.finish_flag(finish_flag)
);
LCD1602_control  CC
(
.finish_flag(finish_flag),
.CLK(CLK),
.RST_N(RST_N),
.traffic(traffic),
.start_flag(start_flag),
.rom_data(data1),
.rom_addr(addr1),
.rom2_data(data2),
.rom2_addr(addr2),
.detect_edge(detect_edge),
.fsm(fsm)
);
LCD1602_ROM_Initialization   DD
(
.CLK(CLK),
.RST_N(RST_N),
.detect_edge(detect_edge),
.fsm(fsm),
.rom_data(data1),
.rom_addr(addr1)
);
LCD1602_ROM_data   EE
(
.CLK(CLK),
.RST_N(RST_N),
.detect_edge(detect_edge),
.fsm(fsm),
.rom_data(data2),
.rom_addr(addr2)
);
LTC2624DA_control FF
(
	.CLK_50M(CLK_50M),
	.RST_N(RST_N),
	.da_data(DA_data),
	.da_start(DA_start)
);
LTC2624DAC_Interface GG
(
	.CLK_50M(CLK_50M),
	.RST_N(RST_N),
	.DA_CLK(DA_CLK),
	.DA_DIN(DA_DIN),
	.DA_CS(DA_CS),
	.DA_data(DA_data),
	.DA_start(DA_start)
);
 
assign   DA_CLR=1'b1;
Endmodule
