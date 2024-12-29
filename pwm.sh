                                                                                                 
#!/bin/bash

# Ensure correct usage
if [ $# -lt 3 ]; then
    echo "Usage: $0 <enable> <frequency (Hz)> <duty cycle (%)>"
    exit 1
fi

ENABLE=$1
FREQ=$2
DUTY_CYCLE=$3

# Replace symbolic link with the absolute path
PWM_PATH="/sys/devices/platform/ocp/48000000.interconnect/48000000.interconnect:segment@300000/48302000.target-module/48302000.epwmss/48302200.pwm/pwm/pwmchip5/pwm1"

# Convert frequency to period in nanoseconds
PERIOD_NS=$((1000000000 / FREQ))

# Calculate duty cycle in nanoseconds
DUTY_NS=$((PERIOD_NS * DUTY_CYCLE / 100))

# Debug messages
echo "DEBUG: ENABLE=$ENABLE, FREQ=$FREQ, DUTY_CYCLE=$DUTY_CYCLE"
echo "DEBUG: PERIOD_NS=$PERIOD_NS, DUTY_NS=$DUTY_NS"
echo "DEBUG: PWM_PATH=$PWM_PATH"

# Check if PWM path exists
if [ ! -d "$PWM_PATH" ]; then
    echo "Error: PWM path '$PWM_PATH' does not exist. Check your configuration."
    exit 1
fi

# Configure the period and duty cycle
echo $PERIOD_NS | sudo tee "$PWM_PATH/period" > /dev/null
echo $DUTY_NS | sudo tee "$PWM_PATH/duty_cycle" > /dev/null

# Enable or disable the PWM
if [ "$ENABLE" -eq 1 ]; then
    echo 1 | sudo tee "$PWM_PATH/enable" > /dev/null
else
    echo 0 | sudo tee "$PWM_PATH/enable" > /dev/null
fi

echo "PWM configured successfully: ENABLE=$ENABLE, FREQ=$FREQ Hz, DUTY_CYCLE=$DUTY_CYCLE%"

