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

  
 // both emergencies come at same , then priroity is given to NS emergency vehicle 
initial
begin
  
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_traffic_controller);
    
     // initialize everything

    areset = 1;

    sensor_NS = 1;
    sensor_EW = 1;

    emergency_NS = 0;
    emergency_EW = 0;

    #20;
    areset = 0;
 
   // allow FSM to reach S2
    #800;
  
   // EW emergency arrives
    emergency_EW = 1;

    #150;

    // NS emergency arrives while EW emergency still active
    emergency_NS = 1;

    #150;

    // remove NS emergency only
    emergency_NS = 0;

    #150;

    // remove EW emergency
    emergency_EW = 0;

    #300;


    $finish;

   
end

endmodule


