module go_detect (

	input 	go,
	input	rst,
	input	clk,
	
	output	wire	go_pulse
	
);
	//wire 	go_pulse;
	reg		go_prev;
	
	
	always @ (posedge clk or posedge rst) begin
		if (rst == 1'b1) begin
			go_prev <= 0;
		end else begin
			go_prev <= go;
		end
	end
	
	assign go_pulse = go & ~go_prev;
	
	
endmodule