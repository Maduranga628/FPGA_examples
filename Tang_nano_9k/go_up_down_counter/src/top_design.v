//top module combines clk divider, go detection, fsm and counter. LED and btn inversions are in this module
module top_module (
	
	input			clk,
	input			rst_btn,
	input			go_btn,
	
	output	[3:0]	led
	
);
	wire	rst = ~rst_btn;
	wire	go = ~go_btn;
	
	wire		slow_clk;
	wire		go_pulse;
	wire[3:0]	counter;
	
	//clk divider
	clock_divider #(.COUNT_WIDTH(24), .MAX_COUNT(13500000-1)) div(
		.clk(clk),
		.rst(rst),
		.slow_clk(slow_clk)
	);
	
	//go_detector
	go_detect u_go (
		.go(go),
		.rst(rst),
		.clk(clk),   // usually use slow clock for debouncing
		.go_pulse(go_pulse)
	);
	
	//fsm counter
	fsm_counter u_fsm (
		.clk(clk),
		.slow_clk(slow_clk),
		.rst(rst),
		.go_pulse(go_pulse),
		.counter(counter)   // connect counter output to LED
	);
	
	assign led = ~counter;
	
endmodule