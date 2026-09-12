# Dependencies

No specific MATLAB version is recorded. The scripts use `imshow` and
`edge` (in `fsmPrepScaleSpace.m`), which require MATLAB's **Image
Processing Toolbox**. Everything else (`imread`, `imfinfo`, `filter2`,
`colormap`, `waitbar`) is core MATLAB.

## Input/output

Unlike other repositories in this account, the scripts here do not have
hardcoded paths to the original author's machine: `textureFilter.m`,
`accumulator.m`, and `fsmPrepScaleSpace.m` all prompt interactively for
their input image(s) via `uigetfile` (and `accumulator.m` for its output
via `uiputfile`). Sample images to try them on are included in
`media/`.
