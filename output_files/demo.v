// VGA 
module demo(clk, vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, pixel_clock);

input clk; //Pin 23
output vga_h_sync; //Pin 101
output vga_v_sync; //Pin 103
output reg [2:0] vga_r; //Pin 106
output reg [2:0] vga_g; //Pin 105
output reg [2:0] vga_b; //Pin 106

output pixel_clock;


wire pixel_clock;
wire inDisplayArea;
wire [9:0] CounterX;
wire [9:0] CounterY;
wire [3:0] selector;

frac_clock_divider clk_divider(.clk(clk), .clk_div(pixel_clock));

sync_generator hvsync(.clk(pixel_clock), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), .inDisplayArea(inDisplayArea), .CounterX(CounterX), .CounterY(CounterY));


// use this bits from CounterX to divide the
// horizontal screen in strips 64 bytes wide
assign selector = CounterX[9:6];

always @(posedge pixel_clock)
begin
  if (inDisplayArea) begin
      /*
       * I don't know if there is a smarter way to assign
       * only one color for strip.
       *
       * Maybe using the selector signal as index?
       */
      vga_r[2] <= selector == 4'b0000;
      vga_r[1] <= selector == 4'b0001;
      vga_r[0] <= selector == 4'b0010;
      vga_g[2] <= selector == 4'b0011;
      vga_g[1] <= selector == 4'b0100;
      vga_g[0] <= selector == 4'b0101;
      vga_b[2] <= selector == 4'b0110;
      vga_b[1] <= selector == 4'b0111;
      vga_b[0] <= selector == 4'b1000;
  end
  else begin// if it's not to display, go dark
      vga_r <= 3'b000;
      vga_g <= 3'b000;
      vga_b <= 3'b000;
  end
end




endmodule

