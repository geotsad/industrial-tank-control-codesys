VAR_GLOBAL

    // Actual physical tank level in simulation
    rActualTankLevel : REAL := 50.0;

    // Simulated 4-20 mA level transmitter signal
    rLevelCurrent_mA : REAL := 12.0;

    // Measured tank level calculated by PLC
    rTankLevel : REAL := 50.0;

    // Level signal diagnostics
    xLevelSensorValid : BOOL := FALSE;
    xLevelSignalFault : BOOL := FALSE;

    // High-high level alarm
    xHighHighLevelAlarm : BOOL := FALSE;

END_VAR
