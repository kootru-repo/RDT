# EPS Phase 1: Bill of Materials

**Complete hardware specification for laboratory detection of entropic thrust**

> For machine-readable version, see [BOM.yaml](BOM.yaml)

---

## Cost Summary

| Configuration | Total Cost | Notes |
|--------------|------------|-------|
| **Minimal** (university lab) | $42,000 - $55,000 | Uses existing vacuum/isolation |
| **Standalone** | $88,000 - $120,000 | All new equipment |
| **Research-grade** | $180,000 - $250,000 | Commercial thrust stand |

---

## 1. Measurement System

### 1.1 Torsion Balance

The core of the experiment. Measures forces at the nano-Newton level.

#### Option A: Custom Build (Recommended for cost)

| Item | Specification | Source | Cost |
|------|---------------|--------|------|
| Tungsten fiber | 25 μm diameter, 50 cm long | [Goodfellow W005150](https://www.goodfellow.com) | $200 |
| Balance arm | Aluminum, 40 cm span | Custom machining | $500 |
| First-surface mirrors | 10 mm diameter (×2) | [Thorlabs PF10-03-P01](https://www.thorlabs.com) | $100 |
| Mounting hardware | Precision stages | McMaster-Carr | $300 |
| **Subtotal** | | | **$1,100 + labor** |

**Specifications achieved:**
- Sensitivity: 10-50 nN
- Natural period: 300-600 s
- Q factor: > 1000

See [torsion-balance.md](torsion-balance.md) for detailed design.

#### Option B: Commercial Thrust Stand

| Model | Sensitivity | Range | Source | Cost |
|-------|-------------|-------|--------|------|
| Plasma Controls μN Stand | 0.1 μN | 0-1000 μN | [plasmacontrols.com](https://plasmacontrols.com) | $80,000-$120,000 |

### 1.2 Optical Readout

| Item | Model | Specification | Source | Cost |
|------|-------|---------------|--------|------|
| HeNe Laser | Thorlabs HNL050LB | 632.8 nm, 5 mW | [Thorlabs](https://www.thorlabs.com) | $1,200 |
| Position Detector | Thorlabs PDP90A | 9 mm active, 0.5 μm resolution | Thorlabs | $800 |
| Optical mounts | Posts, mirrors, holders | — | Thorlabs | $500 |
| **Subtotal** | | | | **$2,500** |

### 1.3 Data Acquisition

| Model | Resolution | Sample Rate | Source | Cost |
|-------|------------|-------------|--------|------|
| NI USB-6289 | 18-bit | 625 kS/s | [ni.com](https://www.ni.com) | $3,000 |
| *Alternative:* MC USB-1808X | 18-bit | 200 kS/s | [mccdaq.com](https://www.mccdaq.com) | $1,500 |

---

## 2. Entropy Generator

### 2.1 Compute Hardware

Generate entropy via irreversible hash computation.

| Configuration | Components | Power | Cost |
|--------------|------------|-------|------|
| **GPU Cluster** | 4× NVIDIA RTX 4090 | 1,800 W | $8,000 |
| *Mid-range* | 4× NVIDIA RTX 4070 | 800 W | $4,000 |
| *ASIC* | Bitmain Antminer S19 | 3,250 W | $3,000 (used) |

**Notes:**
- GPUs preferred for controllability
- ASIC provides higher power density but less flexibility
- Mining software (T-Rex, lolMiner) provides consistent, measurable entropy rate

### 2.2 Power Supply

| Option | Specification | Quantity | Cost |
|--------|---------------|----------|------|
| HP 1200W Server PSU | 12V, 94% efficient | 5 | $1,250 total |
| EVGA 1600W ATX | 80+ Titanium | 4 | $1,600 total |

### 2.3 Cooling System

**CRITICAL:** Heat must exit through the designated radiator surface.

| Item | Purpose | Cost |
|------|---------|------|
| GPU water blocks (×4) | Extract heat from GPUs | $600 |
| Pump/reservoir | Circulate coolant | $200 |
| Tubing, fittings | Connect components | $200 |
| **External radiator** | THRUST SURFACE | $500 |
| **Subtotal** | | **$1,500** |

---

## 3. Thermal Asymmetry

The key to the experiment: radiate heat asymmetrically.

### 3.1 High-Emissivity Radiator (Thrust Side)

| Option | Emissivity | Source | Cost |
|--------|------------|--------|------|
| **Vantablack VBx2** | 0.99+ | [Surrey NanoSystems](https://www.surreynanosystems.com) | $2,500 |
| Acktar Metal Velvet | 0.98 | [Acktar](https://www.acktar.com) | $800 |
| Black anodize + texture | 0.90-0.95 | DIY | $200 |

**Substrate:** Aluminum plate, 30×30 cm, 3 mm thick

### 3.2 Low-Emissivity Insulation (Anti-Thrust Side)

| Item | Emissivity | Purpose | Cost |
|------|------------|---------|------|
| Multi-Layer Insulation (MLI) | < 0.02 | IR reflection | $500 |
| Aerogel blanket | — | Conduction blocking | $300 |
| Gold foil (inner layer) | 0.02 | Maximum reflection | $400 |
| **Subtotal** | | | **$1,200** |

**Target asymmetry ratio:** 100:1 (ε_thrust / ε_anti)

---

## 4. Vacuum System

Eliminates convection; enables clean thermal radiation measurement.

### 4.1 Chamber

| Option | Volume | Source | Cost |
|--------|--------|--------|------|
| **Used (recommended)** | 200-500 L | eBay, surplus | $3,000-$10,000 |
| New commercial | 300 L | Kurt J. Lesker | $15,000-$40,000 |

**Check for:** Adequate ports (ISO-K or CF), leak-tightness

### 4.2 Pump System

| Item | Model | Specification | Cost |
|------|-------|---------------|------|
| Turbo pump station | Pfeiffer HiCube 80 Eco | 67 L/s, 10⁻⁷ mbar | $8,000 |
| *Alternative* | Edwards nEXT85 | Similar | $7,000 |

### 4.3 Gauges & Feedthroughs

| Item | Purpose | Cost |
|------|---------|------|
| Wide-range gauge (PKR 361) | Pressure monitoring | $1,500 |
| Electrical feedthrough (×2) | Signal/power into chamber | $400 |
| Liquid feedthrough (×2) | Cooling lines | $300 |
| **Subtotal** | | **$2,200** |

---

## 5. Shielding & Isolation

### 5.1 Faraday Cage

| Item | Specification | Cost |
|------|---------------|------|
| Copper mesh (100 mesh) | 15 m² | $800 |
| Aluminum frame | 1.5×1.5×2 m | $400 |
| EMI gaskets, connectors | — | $800 |
| **Total** | >60 dB @ 1 GHz | **$2,000** |

### 5.2 Vibration Isolation

| Option | Natural Freq | Cost |
|--------|--------------|------|
| Newport RS2000 optical table | 1.5 Hz | $12,000 |
| Minus-K passive isolators | 0.5 Hz | $1,500 |

---

## 6. Calibration Equipment

| Item | Purpose | Cost |
|------|---------|------|
| Electrostatic calibrator | Known force standard | $500 |
| Precision masses (E2 class) | Gravitational calibration | $200 |
| Thermocouples (×6) + DAQ | Temperature monitoring | $300 |
| **Total** | | **$1,000** |

---

## 7. Software (Free/Open Source)

| Package | Purpose |
|---------|---------|
| Python 3.10+ | Analysis environment |
| NumPy, SciPy, Matplotlib | Numerical analysis |
| h5py | HDF5 data storage |
| PyVISA | Instrument control |
| emcee | MCMC for κ extraction |
| Jupyter | Interactive analysis |

See [software/requirements.txt](../software/requirements.txt)

---

## Vendor Quick Reference

| Vendor | Products | URL |
|--------|----------|-----|
| Thorlabs | Optics, lasers, mounts | thorlabs.com |
| Kurt J. Lesker | Vacuum components | lesker.com |
| Pfeiffer Vacuum | Pumps, gauges | pfeiffer-vacuum.com |
| National Instruments | DAQ | ni.com |
| Goodfellow | Materials (tungsten wire) | goodfellow.com |
| McMaster-Carr | Hardware, materials | mcmaster.com |
| eBay | Used vacuum equipment | ebay.com |

---

## Notes

1. **Start minimal** — Custom torsion balance + used vacuum equipment is sufficient for detection
2. **Upgrade path** — Commercial thrust stand only after confirming signal
3. **Lead times** — Vantablack requires license; turbo pumps have 4-8 week lead
4. **Safety** — See [docs/safety.md](../docs/safety.md) for vacuum, electrical, thermal hazards
