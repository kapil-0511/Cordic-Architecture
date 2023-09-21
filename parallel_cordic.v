`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2023 00:10:09
// Design Name: 
// Module Name: cordic
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


module cordic(
    input clock,
    input signed [15:0] xstart,
    input signed [15:0] ystart,
    input signed [31:0] zangle,
    output signed [15:0] xout,
    output signed [15:0] yout,
    output reg done
    );

wire signed [31:0] atan_table[0:15];

assign atan_table[00] = 'b00100000000000000000000000000000; // 45.000 degrees -> atan(2^0)
assign atan_table[01] = 'b00010010111001000000010100011101; // 26.565 degrees -> atan(2^-1)
assign atan_table[02] = 'b00001001111110110011100001011011; // 14.036 degrees -> atan(2^-2)
assign atan_table[03] = 'b00000101000100010001000111010100; // atan(2^-3)
assign atan_table[04] = 'b00000010100010110000110101000011;
assign atan_table[05] = 'b00000001010001011101011111100001;
assign atan_table[06] = 'b00000000101000101111011000011110;
assign atan_table[07] = 'b00000000010100010111110001010101;
assign atan_table[08] = 'b00000000001010001011111001010011;
assign atan_table[09] = 'b00000000000101000101111100101110;
assign atan_table[10] = 'b00000000000010100010111110011000;
assign atan_table[11] = 'b00000000000001010001011111001100;
assign atan_table[12] = 'b00000000000000101000101111100110;
assign atan_table[13] = 'b00000000000000010100010111110011;
assign atan_table[14] = 'b00000000000000001010001011111001;
assign atan_table[15] = 'b00000000000000000101000101111100;


wire signed [15:0] xcomp_start,ycomp_start;

assign xcomp_start = (xstart>>>1)+(xstart>>>4)+(xstart>>>5)+(xstart>>>6)-(xstart>>>9);      //approximation of gain factor to 0.607
assign ycomp_start = (ystart>>>1)+(ystart>>>4)+(ystart>>>5)+(ystart>>>6)-(ystart>>>9);


wire [1:0] quad;
assign quad = zangle[31:30];

reg signed [15:0] x;
reg signed [15:0] y;
reg signed [31:0] z;


always @(posedge clock)
begin


case(quad)
	2'b00,2'b11:
		begin		// -90 to 90
		x <= xcomp_start;
		y <= ycomp_start;
		z <= zangle;
		end
	2'b01:				//subtract 90	(second quadrant)
		begin
		x <= -ycomp_start;
		y <= xcomp_start;
		z <= {2'b00,zangle[29:0]};
		end
	2'b10:				// add 90 (third quadrant)
		begin
		x <= ycomp_start;			
		y <= -xcomp_start;
		z <= {2'b11,zangle[29:0]};
		end
		
endcase
end

reg [3:0]counter=4'b1111;
reg signed [15:0] xtemp;
reg signed [15:0] ytemp;
reg signed [31:0] ztemp;
reg signed [15:0] xshift;
reg signed [15:0] yshift;


always @(posedge clock)
begin
    if(counter==4'b0000)
        begin
        xtemp<=x;
        ytemp<=y;
        ztemp<=z;
        counter<=counter+1;
        
        end
    else
        begin
        xshift=xtemp>>>(counter-1);
        yshift=ytemp>>>(counter-1);
        
        xtemp = ztemp[31] ? xtemp + yshift : xtemp - yshift;
		ytemp = ztemp[31] ? ytemp - xshift : ytemp + xshift;
        
//        xtemp = ztemp[31] ? xtemp + (ytemp>>>(counter-1)) : xtemp - (ytemp>>>(counter-1));
//		ytemp = ztemp[31] ? ytemp - (xtemp>>>(counter-1)) : ytemp + (xtemp>>>(counter-1));

		ztemp = ztemp[31] ? ztemp+atan_table[counter-1]:ztemp-atan_table[counter-1];
		
		counter=counter+1;
		
        if (counter == 4'b1111)
        done = 'b1;
        else
        done = 'b0;
        end
end
//generate
//for (i=0;i<15;i=i+1)
//begin: iterations

//	wire signed [width:0] xshift, yshift;

//	assign xshift = x[i] >>> i; // signed shift right
//	assign yshift = y[i] >>> i;

//	always @(posedge clock)
//		begin
//		x[i+1] <= z[i][31] ? x[i]+ yshift:x[i]-yshift;
//		y[i+1] <= z[i][31] ? y[i]-xshift:y[i]+xshift;
//		z[i+1] <= z[i][31] ? z[i]+atan_table[i]:z[i]-atan_table[i];
//        out <= out+1;
//        if (out == 4'b1111)
//        done = 'b1;
//        else
//        done = 'b0;

//	end


//end
//endgenerate


reg [15:0] xtempout,ytempout;
always @ (posedge clock)
begin
    if(counter==4'b1111)
    begin
    xtempout<=xtemp;
    ytempout<=ytemp;
    end
end
assign xout = xtempout;
assign yout = ytempout;

//assign xout = x;
//assign yout = y;

endmodule