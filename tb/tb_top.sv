module tb_top;

	import uvm_pkg::*;
	import apb_uart_pkg::*;
`include "uvm_macros.svh"

bit clk1;
bit clk2;
bit PRESETn;

always #5 clk1=~clk1;

always #10 clk2=~clk2;

initial begin
	clk1=0;
	clk2=0;
	PRESETn=0;
	#100;
	PRESETn=1;
end

apb_if in0(clk1);
uart_if in1();

localparam int clk_freq=50_000_000;
localparam int BAUD_RATE=115200;
localparam int SAMPLE=16;

localparam int DIVISOR=
clk_freq/(BAUD_RATE*SAMPLE);

int baud_cnt;

always_ff@(posedge clk2 or negedge PRESETn) begin
	if(!PRESETn) begin
		baud_cnt <=0;
		in1.baud_o <=1'b0;
	end
	else if (baud_cnt==DIVISOR-1) begin
		baud_cnt=<=0;
		in1.baud_o<=1'b1;
	end
	else begin
	baud_cnt<=baud_cnt+1;
	in1.baud_o<=1'b0;
	end
end

uart_16550 dut(.PCLK(clk),.PRESETn(in0.Presetn),.PADDR(in0.Paddr),
.PWDATA(in0.Pwdata),.PWRITE(in0.Pwrite),.PENABLE(in0.Penable),
.PSEL(in0.Psel),.PREADY(in0.Pready),.PSLVERR(in0.Pslverr),.IRQ(in0.IRQ),.TXD(in1.rx),.RXD(in1.tx));

initial begin
	`ifdef VCS
	$fsdbDumpvars(0,top);
	`endif
	
	uvm_config_db#(virtual apb_if)::set(null,"*","avif",in0);
	uvm_config_db#(virtual uart_if)::set(null,"*","uvif",in1);
	
	run_test;
	
	end
endmodule
