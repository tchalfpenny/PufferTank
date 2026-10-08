Visit [puffer.ai](https://puffer.ai) for installation instructions

## Single-drone forest prototype

This checkout adds a reproducible patch on top of PufferLib 4.0's existing drone environment. It
keeps the quadrotor physics and four-motor action space, then adds procedural tree trunks, collision
termination, waypoint progress and clearance rewards, eight body-frame range sensors, logging, and
forest rendering. Each vectorized world contains one drone.

Build the Docker image as usual, enter it, and run:

```bash
puffer-forest train
```

The training mix uses forest worlds plus a smaller set of auxiliary hover worlds so the shared policy
continues learning basic stabilization. Evaluate only the forest task with:

```bash
puffer-forest eval --load-model-path latest
```

For a native installation, run `./install.sh` and then `./forest.sh train`. Set `PUFFERLIB_DIR` if the
PufferLib checkout is somewhere other than `./pufferlib` or `/puffertank/pufferlib`.

Forest density, sensing, reward, and episode settings live in the patched `config/drone.ini` and can
be overridden from the command line, for example:

```bash
puffer-forest train --env.forest-tree-count=16 --env.forest-sensor-range=6
```
