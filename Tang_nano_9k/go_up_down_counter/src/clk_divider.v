module clock_divider #(

	parameter					COUNT_WIDTH = 24,
	parameter	[COUNT_WIDTH-1:0] MAX_COUNT 	= 13500000-1
)(
	//inputs
	input		clk,
	input		rst,
	
	//output
	output	reg	slow_clk
);

	//internal signals
	reg[COUNT_WIDTH-1:0]	count;
	
	//clk divider
	always @ (posedge clk or posedge rst) begin
		if (rst == 1'b1) begin
			count <= 0;
			slow_clk <= 0;
		end else if (count == MAX_COUNT) begin
			count <= 0;
			slow_clk <= 1;
		end else begin
			count <= count + 1;
			slow_clk <= 0;
		end
	end

endmodule