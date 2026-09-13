## TextureFlowAnalysis

Matlab code I wrote for an orientational sensitive texture filter.

## Quick start

This repository implements an orientation-sensitive texture filter for
local motion analysis in Matlab. See [DEPENDENCIES.md](DEPENDENCIES.md)
for the Image Processing Toolbox requirement. Each script prompts
interactively for its input image(s); sample images to try them on are
in [`media/`](media/).

## Repository contents

- `textureFilter.m` -- the main function; computes local motion
  orientation based on the Jacobian matrix and displays it with streaks
  and a directional color-coded map.
- `accumulator.m` -- builds a streak-accumulator image over a stack of
  images, using `defineStackNames.m` and `getFilenameBody.m`.
- `fsmPrepScaleSpace.m` -- a standalone scale-space / edge-detection
  script.
- `Gauss2D1.m` -- a Gaussian-filter helper used by `textureFilter.m`.
- [`media/`](media/) -- sample/example images.
- **License:** see [LICENSE](LICENSE) -- research/educational use.

## About

The textureFilter.m function computes the local motion orientation based on the Jacobian matrix and displays it with streaks, and a directional color-coded map.

For detailed information, see: https://www.frontiersin.org/journals/cell-and-developmental-biology/articles/10.3389/fcell.2025.1681065
