//Fractional Clock Divider
//http://zipcpu.com/blog/2017/06/02/generating-timing.html

module frac_clock_divider(clk, clk_div);
input clk; //50MHz
output reg clk_div;

//parameter divider = 16'h80E5;// Divide by 1.986097319


reg [15:0] counter;
//Counter Overflows into clk_div
always @(posedge clk)
    {clk_div, counter} <= counter + 16'h8000;  // divide by 4: (2^16)/2 = 0x8000


endmodule
