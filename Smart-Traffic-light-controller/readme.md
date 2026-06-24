#### Smart Traffic Light Controller using Verilog HDL

This project implements a Smart Traffic Light Controller using Verilog HDL based on a Finite State Machine (FSM) architecture. The controller manages traffic flow at a two-way intersection using timer-based signal transitions, vehicle detection sensors, and emergency vehicle handling logic.

Unlike a conventional fixed-time traffic controller, the system adapts signal durations based on real-time traffic conditions. It extends green-light duration when no vehicles are detected on the opposing road and provides immediate priority to emergency vehicles.

### Key Features
* 6-State Moore FSM implementation
* Timer-based traffic signal sequencing
* North-South and East-West vehicle detection sensors
* Adaptive green-light extension for low-traffic conditions
* Emergency vehicle prioritization
* Priority resolution for simultaneous emergency requests
* RTL implementation in Verilog HDL
* Functional verification using simulation waveforms

### Test Case 1 – Normal Traffic Operation

Scenario

Both traffic sensors detect vehicles (sensor_NS = 1, sensor_EW = 1) and no emergency vehicles are present. The controller operates under normal traffic conditions using the predefined timing sequence.

Expected Behaviour

The controller cycles through all traffic states according to the programmed timing intervals:

* North-South Green for 50 clock cycles
* North-South Yellow for 20 clock cycles
* East-West Green for 50 clock cycles
* East-West Yellow for 20 clock cycles

Observed State Sequence

S0 → S1 → S2 → S3 → S0

where:

* S0 : NS Green,  EW Red
* S1 : NS Yellow, EW Red
* S2 : NS Red,    EW Green
* S3 : NS Red,    EW Yellow

Counter Verification

* Counter resets at count = 49 in states S0 and S2.
* Counter resets at count = 19 in states S1 and S3.
* State transitions occur at the expected timer expiration points.

Result

* Successfully completed the full traffic signal sequence.
* Verified correct FSM state transitions.
* Verified timer-based operation using a 6-bit counter.
* Verified correct traffic light outputs for all four traffic phases.
* Confirmed stable cyclic operation without emergency events.  

### Test Case 2: Emergency Vehicle Override (North-South)

An emergency vehicle was detected on the North-South road while the controller was operating in normal mode.

Expected Behaviour:
- Immediately grant right-of-way to the emergency vehicle.
- Force traffic controller into emergency state S4.
- North-South signal remains Green.
- East-West signal remains Red.
- After emergency clearance, controller returns to normal operation and timer restarts.

Result:
Successfully transitioned from S2 → S4 upon emergency detection and recovered to S0 after emergency clearance while resetting the timing counter.

### Test Case 3: Emergency Priority Resolution (Competing Emergency Requests)

An emergency request was first generated on the East-West road while the controller was operating in normal mode. The controller correctly transitioned into the East-West emergency state (S5), granting immediate right-of-way to the East-West direction.

While the controller was servicing the East-West emergency request, a second emergency request was generated on the North-South road. Since the controller was designed with a higher priority assigned to North-South emergency vehicles, it immediately transitioned from S5 to S4, overriding the existing East-West emergency condition.

Expected Behaviour:

* East-West emergency request should force the controller into emergency state S5.
* If both emergency requests become active simultaneously, North-South emergency should receive higher priority.
* The controller should transition from S5 to S4 when the North-South emergency request arrives.
* After the North-South emergency request is cleared, the controller should return to S5 if the East-West emergency request is still active.
* Once all emergency requests are cleared, the controller should resume normal operation and restart the timing counter.

Observed State Transitions:

S0 → S1 → S2 → S5 → S4 → S5 → S2

Result:
Successfully implemented emergency priority arbitration between multiple emergency requests. The controller correctly prioritized North-South emergency vehicles over East-West emergency vehicles, dynamically switched between emergency states, and restored normal operation after all emergency conditions were cleared.

### Test Case 4 – Adaptive Green Light Extension (No EW Traffic)

Scenario

No vehicles are detected on the East-West road (sensor_EW = 0) while vehicles continue to arrive from the North-South direction.

Expected Behaviour

When the controller reaches the end of the North-South green interval (count = 49 in state S0), it checks the East-West traffic sensor. Since no vehicles are detected, the controller remains in S0 instead of switching to the yellow transition state.

Observed State Sequence

S0 → S0 → S0 → S0 ...

Result

* North-South green signal remains active continuously.
* East-West signal remains red.
* Unnecessary signal switching is avoided.
* Demonstrates adaptive traffic flow control based on real-time sensor information.

### Test Case 5 – Adaptive Green Light Extension (No NS Traffic)

Scenario

No vehicles are detected on the North-South road (sensor_NS = 0) while vehicles continue to arrive from the East-West direction.

Expected Behaviour

The controller initially transitions through the normal sequence and reaches state S2 (EW Green). When the East-West green interval expires (count = 49), it checks the North-South traffic sensor. Since no vehicles are detected, the controller remains in S2 instead of entering the yellow transition state.

Observed State Sequence

S0 → S1 → S2 → S2 → S2 ...

Result

* East-West green signal remains active continuously.
* North-South signal remains red.
* Unnecessary signal switching is avoided.
* Demonstrates adaptive traffic management using vehicle detection sensors.
