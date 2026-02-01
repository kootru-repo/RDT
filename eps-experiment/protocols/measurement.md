# EPS Measurement Protocol

**Step-by-step procedure for Phase 1 thrust detection**

---

## Overview

| Parameter | Value |
|-----------|-------|
| Expected signal | ~1 μN/kW |
| Noise floor | < 0.1 μN |
| Power level | 5 kW nominal |
| Expected thrust @ 5 kW | ~5 μN |
| Detection margin | 50× above noise |

---

## Pre-Experiment Checklist

### Equipment Verification

- [ ] Torsion balance calibrated (see [calibration.md](calibration.md))
- [ ] Vacuum system leak-checked (< 10⁻⁶ mbar achieved)
- [ ] Optical readout aligned and tested
- [ ] DAQ channels verified
- [ ] Faraday cage grounded
- [ ] Vibration isolation active
- [ ] Cooling system filled and tested
- [ ] All thermocouples reading correctly

### Software Verification

- [ ] DAQ drivers installed and tested
- [ ] Data logging script running
- [ ] Real-time display functioning
- [ ] Disk space adequate (>100 GB)

---

## Measurement Procedure

### Phase 1: Baseline (No Power)

**Duration:** 4 hours minimum

1. Ensure entropy generator is OFF
2. Pump chamber to operating pressure (< 10⁻⁵ mbar)
3. Allow system to thermally equilibrate (2+ hours)
4. Begin continuous data recording
5. Record for 4 hours with no intervention
6. **Output:** Baseline noise characterization, drift rate

**Success criteria:**
- RMS noise < 0.1 μN
- Drift < 0.5 μN/hour

### Phase 2: Symmetric Control

**Duration:** 4 hours

1. Keep radiator covered with symmetric insulation (both sides equal emissivity)
2. Power ON entropy generator to 5 kW
3. Monitor temperatures (should rise symmetrically)
4. Record for 4 hours
5. **Expected result:** NO thrust (photon pressure cancels)

**Purpose:** Verify no systematic artifacts from power, vibration, or EM

### Phase 3: Asymmetric Test

**Duration:** 4 hours per run, multiple runs

1. Remove insulation from thrust-side radiator
2. Verify asymmetric temperature profile:
   - Thrust side: High temperature, high emissivity
   - Anti-thrust side: Low temperature, low emissivity
3. Power ON entropy generator to 5 kW
4. Record for 4 hours
5. Power OFF
6. Record 2 hours cooldown
7. **Expected result:** Measurable thrust of ~5 μN

**Critical data:**
- Force vs. time during power ON
- Force vs. time during power OFF
- Correlation with hash rate
- Correlation with temperature

### Phase 4: Power Variation

**Duration:** 6 hours

Vary power to test F ∝ P relationship:

| Step | Power (kW) | Duration | Expected Thrust |
|------|------------|----------|-----------------|
| 1 | 0 | 30 min | 0 |
| 2 | 1 | 60 min | ~1 μN |
| 3 | 2 | 60 min | ~2 μN |
| 4 | 5 | 60 min | ~5 μN |
| 5 | 2 | 60 min | ~2 μN |
| 6 | 0 | 60 min | 0 |

**Analysis:** Plot F vs. P. Should be linear if EPS is real.

### Phase 5: Temperature Test (CRITICAL)

**Duration:** 8 hours

This distinguishes EPS from photon pressure.

**Protocol:**

1. **Run A: T = 300 K, P = 5 kW**
   - Standard operating temperature
   - Record thrust F₁
   - Duration: 2 hours

2. **Run B: T = 400 K, P = 5 kW**
   - Reduce cooling flow to increase temperature
   - Maintain SAME electrical power
   - Record thrust F₂
   - Duration: 2 hours

3. **Run C: T = 250 K, P = 5 kW**
   - Increase cooling to reduce temperature
   - Maintain SAME electrical power
   - Record thrust F₃
   - Duration: 2 hours

4. **Run D: Return to T = 300 K**
   - Verify reproducibility of F₁
   - Duration: 2 hours

**Predictions:**

| Hypothesis | F₁ | F₂ | F₃ |
|------------|----|----|----|
| Photon pressure only | F | F | F |
| EPS (F ∝ T) | F | 1.33F | 0.83F |

**Decision criterion:**
- If F₂/F₁ = 1.0 ± 0.1 → Photon pressure only, EPS null
- If F₂/F₁ = 1.33 ± 0.2 → EPS confirmed

---

## Data Recording

### File Format

```
eps_run_YYYYMMDD_HHMMSS.h5
├── metadata/
│   ├── run_id
│   ├── operator
│   ├── configuration
│   └── notes
├── timeseries/
│   ├── time (s)
│   ├── force (N)
│   ├── power (W)
│   ├── hash_rate (H/s)
│   ├── T_radiator (K)
│   ├── T_insulation (K)
│   ├── pressure (mbar)
│   └── balance_angle (rad)
└── events/
    ├── power_on_times
    ├── power_off_times
    └── anomalies
```

### Sampling Rates

| Channel | Rate | Notes |
|---------|------|-------|
| Force | 10 Hz | Primary measurement |
| Temperatures | 1 Hz | Thermal monitoring |
| Power | 1 Hz | Electrical |
| Pressure | 0.1 Hz | Vacuum |
| Hash rate | 1 Hz | Entropy rate |

---

## Systematic Error Checks

### Run these controls periodically:

1. **Gravity gradient**
   - Rotate entire apparatus 180°
   - Signal should reverse if real thrust
   - Artifact would stay same direction

2. **Power cable forces**
   - Route cables differently
   - Should not affect thrust

3. **Magnetic interference**
   - Add/remove magnetic shielding
   - Should not affect thrust

4. **Acoustic coupling**
   - Change cooling pump location
   - Should not affect thrust

5. **Thermal expansion**
   - Compare ON/OFF transients
   - Thrust should correlate with steady-state, not transient

---

## Quick Reference: Expected Results

| Scenario | Observed Thrust | Conclusion |
|----------|-----------------|------------|
| Baseline (power off) | 0 ± 0.1 μN | System working |
| Symmetric control | 0 ± 0.1 μN | No artifacts |
| Asymmetric, 5 kW | 5 ± 1 μN | Possible EPS signal |
| F ∝ P linear | Yes | Consistent with EPS |
| F ∝ T scaling | Yes | EPS confirmed vs photon |
| F ∝ T scaling | No (F constant) | Photon pressure only |

---

## If You Detect a Signal

1. **Don't celebrate yet** — Run more controls
2. Document everything
3. Check for:
   - Thermal expansion artifacts
   - Outgassing pressure imbalance
   - Electrical interference
   - Convection (despite vacuum)
4. Vary parameters systematically
5. Contact other groups for independent replication
6. **Open your raw data** — Post to this repository

---

## If Null Result

A null result is still valuable:

1. Calculate upper bound on κ
2. Document sensitivity achieved
3. Publish as constraint on thermodynamic gravity
4. Share data and methods for others to improve

**Null result format:**
```
κ < [value] at 95% confidence
Sensitivity achieved: [value] μN
Power tested: [value] kW
Temperature range: [value] K
```
