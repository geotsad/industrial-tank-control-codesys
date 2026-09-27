PROGRAM PRG_TankSimulation
VAR

    fbPlantTick : TON;
	
	fbMotorStartSim : TON;

    rInletRatePctPerS : REAL := 2.0;

    rOutletRatePctPerS : REAL := 1.0;

END_VAR






// ==========================================
// INDUSTRIAL TANK - PROCESS SIMULATION
// ==========================================


// Generate one process update approximately every second

fbPlantTick(
    IN := NOT fbPlantTick.Q,
    PT := T#1s
);


// ==========================================
// TANK LEVEL SIMULATION
// ==========================================

IF fbPlantTick.Q THEN

    // Water entering the tank
    IF PLC_PRG.xInletValveCmd THEN

        GVL_Tank.rActualTankLevel :=
            GVL_Tank.rActualTankLevel + rInletRatePctPerS;

    END_IF;


    // Water leaving the tank
    IF PLC_PRG.xMotorRun AND GVL_IO.xMotorFeedback THEN

        GVL_Tank.rActualTankLevel :=
            GVL_Tank.rActualTankLevel - rOutletRatePctPerS;

    END_IF;


    // Keep physical level between 0 and 100 %
    IF GVL_Tank.rActualTankLevel > 100.0 THEN

        GVL_Tank.rActualTankLevel := 100.0;

    ELSIF GVL_Tank.rActualTankLevel < 0.0 THEN

        GVL_Tank.rActualTankLevel := 0.0;

    END_IF;

END_IF;


// ==========================================
// AUTOMATIC MOTOR FEEDBACK SIMULATION
// ==========================================

fbMotorStartSim(
    IN := PLC_PRG.xMotorRun
          AND GVL_IO.xMotorHealthy
          AND NOT GVL_IO.xSimulateMotorFailure,
    PT := T#2s
);


// Simulated running feedback
GVL_IO.xMotorFeedback := fbMotorStartSim.Q;


// ==========================================
// LEVEL TRANSMITTER SIMULATION - LT-101
// ==========================================

IF GVL_IO.xSimulateLevelSignalLoss THEN

    // Fault injection: transmitter signal lost
    GVL_Tank.rLevelCurrent_mA := 0.0;

ELSE

    // Normal operation:
    // 0...100 % physical level -> 4...20 mA
    GVL_Tank.rLevelCurrent_mA :=
        4.0 + (GVL_Tank.rActualTankLevel / 100.0) * 16.0;

END_IF;
