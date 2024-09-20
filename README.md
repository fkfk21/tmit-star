# tmit-star

This repo provides an implementation of TMIT*, a practical almost-surely asymptotically optimal integrated task and motion planner, as initially presented in ["Task and Motion Informed Trees (TMIT*): Almost-Surely Asymptotically Optimal Integrated Task and Motion Planning"](https://ieeexplore.ieee.org/document/9869707/).

If you use this software in your research, please cite the following publication:

```bibtex
@article{thomason_tmit_star_2022,
  author={Thomason, Wil and Strub, Marlin P. and Gammell, Jonathan D.},
  journal={IEEE Robotics and Automation Letters}, 
  title={Task and Motion Informed Trees (TMIT*): Almost-Surely Asymptotically Optimal Integrated Task and Motion Planning}, 
  year={2022},
  volume={7},
  number={4},
  pages={11370-11377},
  doi={10.1109/LRA.2022.3199676}
}
```
## Building

You'll need to manually install the following dependencies (also listed in `meson.build`):
- The [Meson](https://mesonbuild.com/) build system
- [CMake](https://cmake.org/)
- A modern C++ compiler (we use C++20 features; `clang++ 14.0.6` is known to work)
- [Boost](https://www.boost.org/)
- [Glew](https://glew.sourceforge.net/) (for debug visualizer)
- [GLFW3](https://www.glfw.org/) (for debug visualizer)
- [GLM](https://github.com/g-truc/glm) (for debug visualizer)
- [LuaJIT](https://luajit.org/)
- [NLopt](https://github.com/stevengj/nlopt)
- [Z3](https://github.com/Z3Prover/z3)

All other dependencies are automatically downloaded and configured in `subprojects/` using Meson's Wrap system.

Once all dependencies are installed, run the `./build.sh` script with `zsh`.
For the basic optimized build, use `./build.sh release --lto`; the script also supports debug, sanitizer, and PGO builds (see the script source for relevant args).

This will result in a binary `build/tmit-star`.

### Dependency installation

<details>
<summary>
bash scripts
</summary>
```bash
sudo apt install -y libglew-dev
sudo apt install -y libglfw3 libglfw3-dev
sudo apt install -y libglm-dev
```

#### install z3

must install z3 latest tag (https://github.com/Z3Prover/z3/tree/z3-4.13.0)
and make install 

```bash
git clone https://github.com/Z3Prover/z3 -b z3-4.13.0 --depth 1
cd z3
python3 scripts/mk_make.py --prefix=/usr/local
cd build
make -j 24
sudo make install
```
add following file as /usr/local/lib/pkgconfig/z3.pc
```
prefix=/usr/local
exec_prefix=/usr/local
libdir=${exec_prefix}/lib
sharedlibdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: z3
Description: The Z3 Theorem Prover
Version: 4.13.0

Requires:
Libs: -L${libdir} -L${sharedlibdir} -lz3
Cflags: -I${includedir}
```



#### install autodiff

install autodiff in advance

```bash
git clone git@github.com:autodiff/autodiff
```
after cloning, modify "python/package/CMakeLists.txt" to change as following:
${PYTHON_EXECUTABLE} -> ${PythonEXECUTABLE}

see details [here](https://github.com/autodiff/autodiff/issues/305#issuecomment-2028248898)

```bash
cd autodiff
mkdir .build && cd .build
cmake ..
sudo cmake --build . --target install
```



</details>




## Usage

You can run the planner directly, but the `run.sh` script provides a more convenient interface.
For basic usage, run `./run.sh {PATH_TO_PROBLEM_SPECIFICATION} {ADDITIONAL PLANNER ARGS}`.
The script also supports running with `perf record`, `lldb`, and `rr` for debugging.
To see a listing of planner args, run `./run.sh --help`.
Example problem specifications live in the `problems/` directory - try `./run.sh problems/clutter/problems/clutter_pb_3.json` for a basic example.
Example Lua predicate implementations are provides in `lua/predicates.lua` - you can easily tailor these to your needs.
PDDL files, robot, and object/obstacle geometry models for the example problems are provided in the `problems` and `models` subdirectories.

## Notice

This software is provided as-is, with no guarantees of correctness, continued maintenance, etc.
Feel free to file an issue/PR if you find a problem or would like to contribute.
