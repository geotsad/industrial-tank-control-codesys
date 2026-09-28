# Functional Test Scenarios

## TC-01 — Normal Pump Start

### Initial conditions
- Tank level is above the minimum operating level.
- LT-101 signal is valid.
- Motor protection is healthy.
- No motor fault is latched.

### Action
Press the START PUMP command.

### Expected behaviour
1. A run request is latched.
2. The start-delay timer begins.
3. After the configured delay, the PLC issues the pump command.
4. Simulated motor feedback becomes active after the simulated startup delay.
5. No start-failure alarm is generated.


## TC-02 — Motor Start Failure

### Initial conditions
- Normal pump start permissives are satisfied.
- Simulated motor failure is enabled.

### Action
Press START PUMP.

### Expected behaviour
1. Pump command becomes active.
2. Motor feedback remains inactive.
3. The feedback supervision timer expires.
4. A motor start failure is generated.
5. The fault is latched.
6. A new start is inhibited until the fault is reset.


## TC-03 — LT-101 Signal Loss

### Initial conditions
- Tank level measurement is operating normally.

### Action
Enable SIMULATE LEVEL SIGNAL LOSS.

### Expected behaviour
1. LT-101 current falls to 0 mA.
2. The level signal becomes invalid.
3. The last valid measured level is retained.
4. Level-dependent permissives are removed.
5. The inlet valve is driven to its safe condition.
6. An LT-101 signal alarm is generated.


## TC-04 — Automatic Tank Filling

### Expected behaviour
- At or below 30 %, the inlet valve opens.
- Filling continues after the level rises above 30 %.
- At or above 70 %, the inlet valve closes.
- The SR latch provides the required hysteresis.


## TC-05 — High-High Level Alarm

### Initial conditions
- LT-101 measurement is valid.

### Action
Increase the simulated tank level to at least 90 %.

### Expected behaviour
- High-high level alarm becomes active.
- The alarm captures the tank level at the trigger event.


## TC-06 — Fault Reset

### Initial conditions
- Motor start fault is latched.
- Equipment is no longer running.
- Reset permissives are satisfied.

### Action
Press RESET FAULT.

### Expected behaviour
- The latched motor fault is cleared.
- The system becomes available for a new start command.
