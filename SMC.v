module SMC(
  // Input signals
    mode,
    W_0, V_GS_0, V_DS_0,
    W_1, V_GS_1, V_DS_1,
    W_2, V_GS_2, V_DS_2,
    W_3, V_GS_3, V_DS_3,
    W_4, V_GS_4, V_DS_4,
    W_5, V_GS_5, V_DS_5,   
  // Output signals
    out_n
);

//================================================================
//   INPUT AND OUTPUT DECLARATION                         
//================================================================
input [2:0] W_0, V_GS_0, V_DS_0;
input [2:0] W_1, V_GS_1, V_DS_1;
input [2:0] W_2, V_GS_2, V_DS_2;
input [2:0] W_3, V_GS_3, V_DS_3;
input [2:0] W_4, V_GS_4, V_DS_4;
input [2:0] W_5, V_GS_5, V_DS_5;
input [1:0] mode;
//output [8:0] out_n;         							// use this if using continuous assignment for out_n  // Ex: assign out_n = XXX;
output reg [9:0] out_n; 								// use this if using procedure assignment for out_n   // Ex: always@(*) begin out_n = XXX; end

reg [7:0]  ID[5:0];    // 6 elements each may reach 7 bits
reg [7:0]  GM[5:0];    // 6 elements each may reach 7 bits
reg [7:0]  N[5:0];     // 6 elements each may reach 7 bits
reg [2:0] counter;     // counter for for loop


reg [7:0] temp;        // temp reg for swapping







//================================================================
//      Calculat   ID[0~5]  MAX 7 7 7 ... value will be 252 8 bits
//================================================================
always @(*)
begin
				ID[0] = (mode[0] == 1'b1) ? ((V_GS_0 - 1) <= V_DS_0) ? (W_0*(V_GS_0 - 1)**2) : (W_0*V_DS_0*(2*V_GS_0-2-V_DS_0)) : 0;
		
				ID[1] = (mode[0] == 1'b1) ? ((V_GS_1 - 1) <= V_DS_1) ? (W_1*(V_GS_1 - 1)**2) : (W_1*V_DS_1*(2*V_GS_1-2-V_DS_1)) : 0;
		
				ID[2] = (mode[0] == 1'b1) ? ((V_GS_2 - 1) <= V_DS_2) ? (W_2*(V_GS_2 - 1)**2) : (W_2*V_DS_2*(2*V_GS_2-2-V_DS_2)) : 0;
		
				ID[3] = (mode[0] == 1'b1) ? ((V_GS_3 - 1) <= V_DS_3) ? (W_3*(V_GS_3 - 1)**2) : (W_3*V_DS_3*(2*V_GS_3-2-V_DS_3)) : 0;
		
				ID[4] = (mode[0] == 1'b1) ? ((V_GS_4 - 1) <= V_DS_4) ? (W_4*(V_GS_4 - 1)**2) : (W_4*V_DS_4*(2*V_GS_4-2-V_DS_4)) : 0;
	    
				ID[5] = (mode[0] == 1'b1) ? ((V_GS_5 - 1) <= V_DS_5) ? (W_5*(V_GS_5 - 1)**2) : (W_5*V_DS_5*(2*V_GS_5-2-V_DS_5)) : 0;
				
end

//================================================================
//      Calculate   GM[0~5]  MAX 7 7 7 ... value will be 98 7 bits
//================================================================		
always @(*)
begin
				GM[0] = (mode[0] == 1'b0) ? ((V_GS_0 - 1) <= V_DS_0) ? (2*(W_0*(V_GS_0 - 1))) : (2*(W_0 * V_DS_0)) : 0;
				
				GM[1] = (mode[0] == 1'b0) ? ((V_GS_1 - 1) <= V_DS_1) ? (2*(W_1*(V_GS_1 - 1))) : (2*(W_1 * V_DS_1)) : 0;
				
				GM[2] = (mode[0] == 1'b0) ? ((V_GS_2 - 1) <= V_DS_2) ? (2*(W_2*(V_GS_2 - 1))) : (2*(W_2 * V_DS_2)) : 0;
				
				GM[3] = (mode[0] == 1'b0) ? ((V_GS_3 - 1) <= V_DS_3) ? (2*(W_3*(V_GS_3 - 1))) : (2*(W_3 * V_DS_3)) : 0;
				
				GM[4] = (mode[0] == 1'b0) ? ((V_GS_4 - 1) <= V_DS_4) ? (2*(W_4*(V_GS_4 - 1))) : (2*(W_4 * V_DS_4)) : 0;
				
				GM[5] = (mode[0] == 1'b0) ? ((V_GS_5 - 1) <= V_DS_5) ? (2*(W_5*(V_GS_5 - 1))) : (2*(W_5 * V_DS_5)) : 0;
end



//================================================================
//                 Sorting according to mode[0]
//================================================================

always@(*)
begin
	case(mode[0])
		1'b0:          // sort GM[0]~GM[5] and assign to N[0~5] need 6 iterations
			begin
				for(counter = 0; counter <6; counter = counter + 2)   // 1st iteration 
					begin
						N[counter]   = (GM[counter] < GM[counter+1]) ? GM[counter+1] : GM[counter  ];
						N[counter+1] = (GM[counter] < GM[counter+1]) ? GM[counter  ] : GM[counter+1];
					end
				for(counter = 1; counter <5; counter = counter + 2)   // 2nd iteration 
					begin
					
						if(N[counter] < N[counter+1])
							begin
								temp = N[counter];
								N[counter] = N[counter+1];
								N[counter+1] = temp;
							end
						else
							begin
							end
							
					end
				for(counter = 0; counter <6; counter = counter + 2)   // 3rd iteration 
					begin
				
						if(N[counter] < N[counter+1])
							begin
								temp = N[counter];
								N[counter] = N[counter+1];
								N[counter+1] = temp;
							end
						else
							begin
							end
							
					end
				for(counter = 1; counter <5; counter = counter + 2)   // 4th iteration 
					begin
					
					
						if(N[counter] < N[counter+1])
							begin
								temp = N[counter];
								N[counter] = N[counter+1];
								N[counter+1] = temp;
							end
						else
							begin
							end
					
					end
				for(counter = 0; counter <6; counter = counter + 2)   // 5th iteration 
					begin
					
						if(N[counter] < N[counter+1])
							begin
								temp = N[counter];
								N[counter] = N[counter+1];
								N[counter+1] = temp;
							end
						else
							begin
							end
					
					end
				for(counter = 1; counter <5; counter = counter + 2)   // 6th iteration 
					begin
					
						if(N[counter] < N[counter+1])
							begin
								temp = N[counter];
								N[counter] = N[counter+1];
								N[counter+1] = temp;
							end
						else
							begin
							end
					
					end
			end
		default:      // case 1'b1 sort ID[0]~ID[5] and assign to N[0~5]
			begin
				for(counter = 0; counter <6; counter = counter + 2)   // 1st iteration 
					begin
						N[counter]   = (ID[counter] < ID[counter+1]) ? ID[counter+1] : ID[counter  ];
						N[counter+1] = (ID[counter] < ID[counter+1]) ? ID[counter  ] : ID[counter+1];
					end
				for(counter = 1; counter <5; counter = counter + 2)   // 2nd iteration 
					begin
					
						if(N[counter] < N[counter+1])
							begin
								temp = N[counter];
								N[counter] = N[counter+1];
								N[counter+1] = temp;
							end
						else
							begin
							end
					
					end
				for(counter = 0; counter <6; counter = counter + 2)   // 3rd iteration 
					begin
					
						if(N[counter] < N[counter+1])
							begin
								temp = N[counter];
								N[counter] = N[counter+1];
								N[counter+1] = temp;
							end
						else
							begin
							end
					
					end
				for(counter = 1; counter <5; counter = counter + 2)   // 4th iteration 
					begin
					
						if(N[counter] < N[counter+1])
							begin
								temp = N[counter];
								N[counter] = N[counter+1];
								N[counter+1] = temp;
							end
						else
							begin
							end
					
					end
				for(counter = 0; counter <6; counter = counter + 2)   // 5th iteration 
					begin
					
						if(N[counter] < N[counter+1])
							begin
								temp = N[counter];
								N[counter] = N[counter+1];
								N[counter+1] = temp;
							end
						else
							begin
							end
					
					end
				for(counter = 1; counter <5; counter = counter + 2)   // 6th iteration 
					begin
					
						if(N[counter] < N[counter+1])
							begin
								temp = N[counter];
								N[counter] = N[counter+1];
								N[counter+1] = temp;
							end
						else
							begin
							end
					
					end
			end
	endcase
end



//================================================================
//                 Calculating out_n according to mode[1]
//================================================================

always@(*)
begin
	case(mode)
		2'b00:      //  out_n = GM_Total = N[3] + N[4] + N[5]
			begin
				out_n = N[3]/3 + N[4]/3 + N[5]/3;   //all /3
			end
		2'b01:		//  out_n = I_Total  = 3*N[3] + 4*N[4] + 5*N[5]
			begin
			    out_n = (N[3]/3)*3 + (N[4]/3)*4 + (N[5]/3)*5;
			end
		2'b10:		//  out_n = GM_Total = N[0] + N[1] + N[2]
			begin
				out_n = N[0]/3 + N[1]/3 + N[2]/3;
			end
		default:	//  out_n = I_Total  = 3*N[0] + 4*N[1] + 5*N[2]
			begin
				out_n = (N[0]/3)*3 + (N[1]/3)*4 + (N[2]/3)*5;
			end
	endcase
end


endmodule






















//================================================================
//    Wire & Registers 
//================================================================
// Declare the wire/reg you would use in your circuit
// remember 
// wire for port connection and cont. assignment
// reg for proc. assignment


//================================================================
//    DESIGN
//================================================================
// --------------------------------------------------
// write your design here
// --------------------------------------------------




//================================================================
//   SUB MODULE
//================================================================

// module BBQ (meat,vagetable,water,cost);
// input XXX;
// output XXX;
// 
// endmodule

// --------------------------------------------------
// Example for using submodule 
// BBQ bbq0(.meat(meat_0), .vagetable(vagetable_0), .water(water_0),.cost(cost[0]));
// --------------------------------------------------
// Example for continuous assignment
// assign out_n = XXX;
// --------------------------------------------------
// Example for procedure assignment
// always@(*) begin 
// 	out_n = XXX; 
// end
// --------------------------------------------------
// Example for case statement
// always @(*) begin
// 	case(op)
// 		2'b00: output_reg = a + b;
// 		2'b10: output_reg = a - b;
// 		2'b01: output_reg = a * b;
// 		2'b11: output_reg = a / b;
// 		default: output_reg = 0;
// 	endcase
// end
// --------------------------------------------------
