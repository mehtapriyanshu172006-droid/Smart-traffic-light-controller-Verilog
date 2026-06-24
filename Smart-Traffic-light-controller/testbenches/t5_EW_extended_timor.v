`timescale 1ns/1ps

module tb_traffic_controller;

// inputs   
reg clk;
reg areset;

reg sensor_NS;
reg sensor_EW;

reg emergency_NS;
reg emergency_EW;

 // outputs being driven by the output ports of design 
wire NS_green;
wire NS_yellow;
wire NS_red;

wire EW_green;
wire EW_yellow;
wire EW_red;

// Instantiate your design

  traffic_controller I0(

    .clk(clk),
    .areset(areset),

    .sensor_NS(sensor_NS),
    .sensor_EW(sensor_EW),

    .emergency_NS(emergency_NS),
    .emergency_EW(emergency_EW),

    .NS_green(NS_green),
    .NS_yellow(NS_yellow),
    .NS_red(NS_red),

    .EW_green(EW_green),
    .EW_yellow(EW_yellow),
    .EW_red(EW_red)
);

  
  
  
// clock generation
  

initial
begin
    clk = 0;
end

always #5 clk = ~clk;  // clock period =10ns 

// stimulus

//when no cars are detected on the NS road, the controller keeps EW green and does not unnecessarily switch.  
 
initial
begin
  
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_traffic_controller);
    
     // initialize everything

    areset = 1;

    sensor_NS = 0;
    sensor_EW = 1;

    emergency_NS = 0;
    emergency_EW = 0;

    #20;
    areset = 0;
 
  
   // run for longer to see  longer transitions transitions 
    # 2000;


    $finish;

   
end

endmodule


