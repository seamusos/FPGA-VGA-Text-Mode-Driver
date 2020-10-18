module SPI_Module(clk, sck, mosi, cs, input_shiftreg, done, cs_record);

input clk;	//System Clock

input sck;	//SPI Slave Clock
input mosi;	//Data Input
input cs;	//Chip Select

output reg [7:0] input_shiftreg;	//Data shift register

output reg [2:0] cs_record;	//Records 3 previous states of CS

output wire done;	//Transaction done


reg [2:0] sck_record;
always @(posedge clk)
	sck_record <= {sck_record[1:0], sck};
	


always @(posedge clk)
	cs_record <= {cs_record[1:0], cs};

reg current_state;
reg [3:0] bitcounter;

always @(posedge clk) begin
	if(cs_record[2:1] == 2'b01) begin //Rising Edge
		current_state <= 0;
		bitcounter <= 0;
	end else if (cs_record[2:1] == 2'b10) begin //Falling Edge (Start)
		bitcounter <= 1; // Reset Bit Counter
		current_state <= 1;
	end else if (current_state == 1'b1 && sck_record[2:1] == 2'b01) begin
		input_shiftreg = input_shiftreg << 1;
		input_shiftreg[0] = mosi;
		bitcounter <= bitcounter + 1;
		if (bitcounter == 8)
			current_state <= 0;
	end else begin
		input_shiftreg <= input_shiftreg;
	end
end

assign done = (bitcounter == 8);

endmodule

