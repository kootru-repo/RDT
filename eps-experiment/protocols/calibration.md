# Torsion Balance Calibration

**Procedure for establishing traceable force measurement**

---

## Overview

Before any thrust measurement, the torsion balance must be calibrated against known forces. This establishes the conversion from angular displacement to force.

---

## Method 1: Electrostatic Calibration (Recommended)

### Principle

A parallel-plate capacitor exerts a known force:

$$F = \frac{\varepsilon_0 A V^2}{2d^2}$$

Where:
- ε₀ = 8.854 × 10⁻¹² F/m
- A = plate area (m²)
- V = applied voltage (V)
- d = plate separation (m)

### Equipment

| Item | Specification |
|------|---------------|
| Capacitor plates | 10 × 10 mm, polished aluminum |
| Gap spacer | 1.00 ± 0.01 mm (precision shim) |
| High-voltage supply | 0-1000 V DC, calibrated |
| Voltmeter | 5-digit, calibrated |

### Procedure

1. Mount one capacitor plate on balance arm, one on fixed frame
2. Set gap d = 1.00 mm using precision spacer
3. Apply voltage steps: 0, 100, 200, 300, 400, 500 V
4. Record angular deflection at each voltage
5. Calculate expected force at each voltage
6. Fit: θ = k × F (determine sensitivity k)

### Example Calculation

For A = 100 mm², d = 1 mm, V = 500 V:

$$F = \frac{8.854 \times 10^{-12} \times 10^{-4} \times 500^2}{2 \times (10^{-3})^2} = 1.1 \text{ μN}$$

### Calibration Table

| Voltage (V) | Force (μN) |
|-------------|------------|
| 100 | 0.044 |
| 200 | 0.177 |
| 300 | 0.398 |
| 400 | 0.708 |
| 500 | 1.107 |

---

## Method 2: Gravitational Calibration

### Principle

Small known masses produce known gravitational torque.

### Procedure

1. Attach calibrated mass m to balance arm at radius r
2. Tilt balance slightly (angle α)
3. Horizontal force component: F = mg sin(α)
4. Record deflection
5. Repeat at multiple angles

### Example

For m = 100 mg, r = 10 cm, α = 0.1°:

$$F = 0.0001 \times 9.81 \times \sin(0.1° \times \pi/180) = 0.17 \text{ μN}$$

---

## Method 3: Photon Pressure Calibration

### Principle

Laser radiation pressure provides known force:

$$F = \frac{P}{c}(1 + R)$$

Where:
- P = laser power (W)
- c = speed of light
- R = surface reflectivity

### Procedure

1. Aim calibrated laser at balance mirror
2. For P = 100 mW, R ≈ 0.95:
   - F = 0.1 / (3×10⁸) × 1.95 = 0.65 nN
3. Use high-power laser for larger forces
4. Record deflection vs. power

### Note

Photon pressure calibration is useful because it's the primary background we need to distinguish from EPS.

---

## Calibration Schedule

| Calibration | Frequency | Method |
|-------------|-----------|--------|
| Initial | Once | Full electrostatic sweep |
| Daily | Before each run | Single-point check |
| Weekly | During campaign | Full recalibration |
| After any modification | Immediately | Full recalibration |

---

## Acceptance Criteria

- Calibration curve R² > 0.999
- Repeated measurements within ±5%
- Hysteresis < 2%
- Drift < 1%/hour after warmup

---

## Documentation

Record for each calibration:

```yaml
calibration:
  date: YYYY-MM-DD
  operator: [name]
  method: electrostatic | gravitational | photon
  temperature: [K]
  pressure: [mbar]
  data:
    - voltage_V: 100
      force_uN: 0.044
      deflection_urad: [measured]
    - voltage_V: 200
      ...
  fit:
    sensitivity_urad_per_uN: [value]
    uncertainty: [value]
    r_squared: [value]
  notes: [any anomalies]
```
