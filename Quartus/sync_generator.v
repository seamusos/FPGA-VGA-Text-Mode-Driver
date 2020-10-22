// Sync Generator
module sync_generator(clk, vga_h_sync, vga_v_sync, inDisplayArea, CounterX, CounterY);

	input clk;						//pixel clock ~25.175MHz
	output vga_h_sync;			//Horizontal Sync Pulse
	output vga_v_sync;			//Vertical Sync Pulse
	output reg inDisplayArea;	//Display region Flag
	output reg [9:0] CounterX;	//Horizontal Counter
	output reg [9:0] CounterY;	//Verticle Counter
	
	reg vga_HS, vga_VS;
	
	wire CounterXmaxed = (CounterX == 800); // 16 + 48 + 96 + 640
   wire CounterYmaxed = (CounterY == 525); // 10 + 2 + 33 + 480
	
	//For each pixel clock increment horizontal counter
   always @(posedge clk)
   if (CounterXmaxed)
     CounterX <= 0;
   else
     CounterX <= CounterX + 1;
	
	// For each row complete increment verticle counter
   always @(posedge clk)
   begin
		if (CounterXmaxed)
      begin
			if(CounterYmaxed)
				CounterY <= 0;
			else
				CounterY <= CounterY + 1;
		end
	end
	
	// Calculate timings for Horizontal and Verticle Sync Pulses
   always @(posedge clk)
   begin
		vga_HS <= (CounterX > (640 + 16) && (CounterX < (640 + 16 + 96)));   // active for 96 clocks
		vga_VS <= (CounterY > (480 + 10) && (CounterY < (480 + 10 + 2)));   // active for 2 clocks
   end
	
	// If counters are within the Display Region, set flag
   always @(posedge clk)
   begin
		inDisplayArea <= (CounterX < 640) && (CounterY < 480);
	end
	
	//Active Low VGA Outputs
	assign vga_h_sync = ~vga_HS;
	assign vga_v_sync = ~vga_VS;

endmodule
