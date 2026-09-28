// ==========================================
// ANALOG INPUT PROCESSING - LT-101
// ==========================================


// 1. Validate transmitter signal

GVL_Tank.xLevelSensorValid :=
    (GVL_Tank.rLevelCurrent_mA >= 4.0)
    AND
    (GVL_Tank.rLevelCurrent_mA <= 20.0);


// 2. Diagnostic signal fault

GVL_Tank.xLevelSignalFault :=
    NOT GVL_Tank.xLevelSensorValid;


// 3. Scale valid 4-20 mA signal to 0-100 %

IF GVL_Tank.xLevelSensorValid THEN

    GVL_Tank.rTankLevel :=
        ((GVL_Tank.rLevelCurrent_mA - 4.0) / 16.0) * 100.0;

END_IF;


// 4. High-High process alarm
// This MUST execute every PLC scan

GVL_Tank.xHighHighLevelAlarm :=
    GVL_Tank.xLevelSensorValid
    AND
    (GVL_Tank.rTankLevel >= 90.0);
