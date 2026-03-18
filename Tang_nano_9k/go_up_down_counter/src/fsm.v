module fsm_counter (
	
	input				clk,
	input				rst,
	input				go_pulse,
	input				slow_clk,
	
	output	reg[3:0]	counter
);
	
	localparam	IDLE_UP		= 2'b00;
	localparam	COUNT_UP	= 2'b01;
	localparam	IDLE_DOWN	= 2'b10;
	localparam	COUNT_DOWN	= 2'b11;
	
	reg	[1:0]	state;
	
	wire	COUNTER_MAX = (counter == 4'hF);
	wire	COUNTER_MIN = (counter == 4'h0);
	
	always @ (posedge clk or posedge rst) begin
		//on reset return to IDLE_UP
		if (rst == 1'b1) begin
			state <= IDLE_UP;
			
		//state transitions
		end else begin
			case (state)
				//idle up
				IDLE_UP: begin
				if (go_pulse == 1'b1) begin
					state <= COUNT_UP;
					end else
					state <= IDLE_UP;
				end
				
				//count up to 1111 and reach idle down
				COUNT_UP: begin
					if(COUNTER_MAX) begin
						state <= IDLE_DOWN;
						end else
						state <= COUNT_UP;
					end
				
				//idle down
				IDLE_DOWN: begin
					if (go_pulse == 1'b1) begin
						state <= COUNT_DOWN;
						end else
						state <= IDLE_DOWN;
					end
				
				//count down to 0000 and reach idle up
				COUNT_DOWN: begin
					if(COUNTER_MIN) begin
						state <= IDLE_UP;
						end else
						state <= COUNT_DOWN;
					end
				
				//go to idle up when in unknown state
				default: state <= IDLE_UP;
			endcase
		end
	end
	
	//counter logic
	always @ (posedge clk or posedge rst) begin
		//at reset counter gets 0
		if (rst == 1'b1) begin
			counter <= 4'h0;
		end else begin
			if (slow_clk ==1'b1) begin
			case (state)
				//up counter
				COUNT_UP: begin
					counter <= counter +1;
				end
				//down counter
				COUNT_DOWN: begin
					counter <= counter - 1;
				end
				//default, idle up and down hold the value
				default: counter <= counter;
			endcase
			end
		end
	end
	
endmodule
	
						