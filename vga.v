// VGA 
module vga(clk, vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, stupid_buzzer);

input clk; //Pin 23
output vga_h_sync; //Pin 101
output vga_v_sync; //Pin 103
output reg vga_r; //Pin 106
output reg vga_g; //Pin 105
output reg vga_b; //Pin 104

output stupid_buzzer;

assign stupid_buzzer = 1'b1;



wire pixel_clock;
wire inDisplayArea;
wire [9:0] CounterX;
wire [9:0] CounterY;
wire [3:0] selector;

wire [2:0] pixel_out;

reg [7:0] ascii_char;

frac_clock_divider clk_divider(.clk(clk), .clk_div(pixel_clock));

sync_generator hvsync(.clk(pixel_clock), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), .inDisplayArea(inDisplayArea), .CounterX(CounterX), .CounterY(CounterY));

framebuffer buffer(.clk(clk), .counterX(CounterX), .counterY(CounterY), .pixel_out(pixel_out));

always @(posedge pixel_clock)
begin
	if (inDisplayArea) begin
		vga_r <= pixel_out;
		vga_g <= pixel_out;
		vga_b	<= pixel_out;
	end
	else begin// if it's not to display, go dark
	  vga_r <= 1'b0;
	  vga_g <= 1'b0;
	  vga_b <= 1'b0;
	end
end


//always @(posedge pixel_clock)
//begin
//	if (inDisplayArea) begin
////        vga_r <= 1'b1;
////		  vga_g <= 1'b0;
////		  vga_b <= 1'b0;
//		if(CounterX > 0 && CounterX <= 80) begin
//			vga_r <= 1'b0;
//			vga_g <= 1'b0;
//			vga_b <= 1'b0;
//		end
//		else if(CounterX > 80 && CounterX <= 160) begin
//			vga_r <= 1'b1;
//			vga_g <= 1'b0;
//			vga_b <= 1'b0;
//		end
//		else if(CounterX > 160 && CounterX <= 240) begin
//			vga_r <= 1'b0;
//			vga_g <= 1'b1;
//			vga_b <= 1'b0;
//		end
//		else if(CounterX > 240 && CounterX <= 320) begin
//			vga_r <= 1'b1;
//			vga_g <= 1'b1;
//			vga_b <= 1'b0;
//		end
//		else if(CounterX > 320 && CounterX <= 400) begin
//			vga_r <= 1'b0;
//			vga_g <= 1'b0;
//			vga_b <= 1'b1;
//		end
//		else if(CounterX > 400 && CounterX <= 480) begin
//			vga_r <= 1'b1;
//			vga_g <= 1'b0;
//			vga_b <= 1'b1;
//		end
//		else if(CounterX > 480 && CounterX <= 560) begin
//			vga_r <= 1'b0;
//			vga_g <= 1'b1;
//			vga_b <= 1'b1;
//		end
//		else begin
//			vga_r <= 1'b1;
//			vga_g <= 1'b1;
//			vga_b <= 1'b1;
//		end
//	end
//	else begin// if it's not to display, go dark
//	  vga_r <= 1'b0;
//	  vga_g <= 1'b0;
//	  vga_b <= 1'b0;
//	end
//end





endmodule

