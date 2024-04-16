# CadQuery


# Prerequisites

Install [Miniforge](https://github.com/conda-forge/miniforge)

Example (MacOS):

```bash
cd /tmp
curl -L -o miniforge.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh"
chmod +x miniforge.sh
./miniforge.sh
```

# Installation

2. Install [CadQuery Editor](https://github.com/CadQuery/CQ-editor)

Use [nightly releases](https://github.com/CadQuery/CQ-editor/releases/tag/nightly)

```bash
cd /tmp
curl -LO https://github.com/CadQuery/CQ-editor/releases/download/nightly/CQ-editor-master-MacOSX-x86_64.sh
chmod +x CQ-editor-master-MacOSX-x86_64.sh
./CQ-editor-master-MacOSX-x86_64.sh
```


3. Install additional CQ libraries

```bash
source "$HOME/cq-editor/bin/activate"
conda install git

pip install git+https://github.com/JustinSDK/cqMore
```

Run editor:

```bash
cd $HOME/cq-editor
./run.sh
```


# Examples

https://github.com/JustinSDK/cqMore/blob/main/examples/voronoi_vase.py
