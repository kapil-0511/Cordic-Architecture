`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2023 00:11:21
// Design Name: 
// Module Name: cordic_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cordic_tb;

	reg clock;
	reg [15:0] xstart;
	reg [15:0] ystart;
	reg [31:0] zangle;

	wire [15:0] xout;
	wire [15:0] yout;
	wire done;

	cordic uut (
		.clock(clock), 
		.xstart(xstart), 
		.ystart(ystart), 
		.zangle(zangle), 
		.xout(xout), 
		.yout(yout), 
		.done(done)
	);


	initial begin
		// Initialize Inputs
		clock = 0;
		xstart = 0;
		ystart = 0;
		zangle = 0;

		
		
		// Wait 100 ns for global reset to finish
		#100;
		
		// Add stimulus here
		xstart = 1200;
//		ystart = 1200;
		
//		zangle = 'b00000000000000000000000000000000;  //-00
		
//		zangle = 'b00100000000000000000000000000000;  //45
//		zangle = 'b11100000000000000000000000000000;  //-45

//		zangle = 'b00010101010101010101010101010101;  //30
//		zangle = 'b11101010101010101010101010101011;  //-30

//		zangle = 'b00101010101010101010101010101010;  //60
//		zangle = 'b11010101010101010101010101010110;  //-60
		
//		zangle = 'b01000000000000000000000000000000;  //90
//		zangle = 'b11000000000000000000000000000000;  //-90

		zangle = 'b01010101010101010101010101010101;  //120
//		zangle = 'b10101010101010101010101010101011;  //-120

//		zangle = 'b01101010101010101010101010101010;  //150
//		zangle = 'b10010101010101010101010101010110;  //-150
		 
		 clock = 'b0;
		 forever
		 begin
			#5 clock = !clock;
		 end
        
		// Add stimulus here
		//xstart = 3200;
		//ystart = 0;
		//zangle = 'b00100000000000000000000000000000;

	end
      
endmodule