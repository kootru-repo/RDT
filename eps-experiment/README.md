# EPS Experiment: Entropic Propulsion System Test

**Open-source experimental specification for testing RDT's entropic thrust prediction**

[![License: CERN-OHL-S-2.0](https://img.shields.io/badge/License-CERN--OHL--S--2.0-blue.svg)](https://ohwr.org/cern_ohl_s_v2.txt)

## Overview

This repository contains complete specifications for building and operating a Phase 1 test of the Entropic Propulsion System (EPS) — a predicted consequence of Relational Drainage Theory (RDT).

**The Prediction:** Asymmetric entropy generation produces thrust at ~1 μN/kW, distinguishable from photon pressure via temperature scaling.

**Theory:** See [relationaldrainage.org](https://relationaldrainage.org) for full RDT framework.

## Quick Start

| What | Where |
|------|-------|
| Bill of Materials | [hardware/BOM.md](hardware/BOM.md) |
| Machine-readable BOM | [hardware/BOM.yaml](hardware/BOM.yaml) |
| Assembly Guide | [docs/assembly-guide.md](docs/assembly-guide.md) |
| Measurement Protocol | [protocols/measurement.md](protocols/measurement.md) |
| Analysis Software | [software/](software/) |

## The Experiment

### Principle

1. Generate entropy via irreversible computation (GPU hashing)
2. Radiate heat asymmetrically (high-emissivity radiator on one side, insulation on other)
3. Measure resulting force with torsion balance
4. Distinguish from photon pressure via temperature scaling test

### Expected Signal

| Power | Predicted Thrust | Detection Margin |
|-------|------------------|------------------|
| 1 kW | ~1 μN | 10× above noise floor |
| 5 kW | ~5 μN | 50× above noise floor |

### Key Distinguishing Test

**Photon pressure:** Force independent of temperature at constant power
**EPS (if real):** Force ∝ Temperature at constant power (Verlinde scaling)

```
Protocol:
1. Measure F₁ at T = 300 K, P = 5 kW
2. Measure F₂ at T = 600 K, P = 5 kW (same power)
3. Measure F₃ at T = 150 K, P = 5 kW (same power)

Null hypothesis: F₁ = F₂ = F₃ (photon pressure only)
RDT prediction:  F₂ = 2×F₁, F₃ = 0.5×F₁
```

## Budget Estimates

| Configuration | Estimated Cost | Notes |
|---------------|----------------|-------|
| Minimal (university lab) | $50,000 - $80,000 | Uses existing vacuum/isolation |
| Standalone | $100,000 - $150,000 | All new equipment |
| Research-grade | $200,000 - $500,000 | Commercial thrust stand |

## Directory Structure

```
eps-experiment/
├── README.md                 # This file
├── hardware/
│   ├── BOM.md               # Human-readable bill of materials
│   ├── BOM.yaml             # Machine-readable specification
│   ├── torsion-balance.md   # Balance design details
│   ├── thermal-shroud.md    # Asymmetric radiator design
│   └── entropy-generator.md # GPU compute unit specs
├── software/
│   ├── requirements.txt     # Python dependencies
│   ├── daq/                 # Data acquisition scripts
│   └── analysis/            # κ extraction analysis
├── protocols/
│   ├── calibration.md       # Balance calibration procedure
│   ├── measurement.md       # Main experimental protocol
│   ├── temperature-test.md  # F ∝ T distinguishing test
│   └── controls.md          # Null hypothesis tests
└── docs/
    ├── assembly-guide.md    # Full build instructions
    ├── theory-summary.md    # Physics background
    ├── troubleshooting.md   # Common issues
    └── safety.md            # Hazard warnings
```

## Contributing

This is an open experiment. Contributions welcome:

- **Hardware improvements:** Better thermal asymmetry designs
- **Software:** DAQ drivers, analysis tools
- **Protocols:** Refined calibration procedures
- **Results:** If you run this experiment, please share data!

## License

Hardware designs: [CERN Open Hardware License v2 - Strongly Reciprocal](https://ohwr.org/cern_ohl_s_v2.txt)
Software: [MIT License](https://opensource.org/licenses/MIT)
Documentation: [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

## Contact

- **Theory:** [relationaldrainage.org](https://relationaldrainage.org)
- **Issues:** Use GitHub Issues for questions/discussion
- **Author:** Andrew Craton

## Disclaimer

This experiment tests a speculative prediction from a non-mainstream theoretical framework. The probability of detecting a positive result is honestly low. However:

1. The experiment is inexpensive relative to most physics research
2. Null results are scientifically valuable (constrain thermodynamic gravity theories)
3. The prediction is specific and falsifiable
4. All equipment has standard uses if EPS fails

**This is real science, not perpetual motion.** Energy is consumed (electricity → computation → heat). Momentum is conserved (via M⁺/M⁻ dual manifold, if RDT is correct). The question is whether entropic gradients couple to spacetime in the way Jacobson-Verlinde thermodynamic gravity suggests.
