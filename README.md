# Musical Root

## Wwise

### Prerequisites

Do these **before** pulling the repository version with Wwise integration.

* Install git lfs (git Large File Storage) from [here](https://git-lfs).com/.
  * Only need to download and run the file, ignore the `Getting started` section, as I will write the relevant steps here.
  * Open `Git Bash`, paste `git lfs install` (paste with right click -> paste, as `ctrl+V` will not work), and press enter. If it worked, you should get a message like `Git LFS initialized.`
* In order for Wwise integration to work, install `Visual Studio 2019 Build Tools` or `Visual Studio 2019` (the former is smaller than the latter, so if you have neither, it will be faster to install the former).
  * When installing it, go to `Individual Components` tab (see [here](https://learn.microsoft.com/en-us/visualstudio/install/modify-visual-studio?view=vs-2022#change-workloads-or-individual-components) how that looks) and select `MSVC v142 - VS 2019 C++ x64/x86 build tools (Latest)` (can paste this name into the search box).
* Install Wwise version 2021.1.13.
* Now, pull the latest changes.
* Open Wwise, open the Wwise project which is in `GGJ2023\wwise\project`.

### Workflow

1. Do sound stuff in Wwise.
2. [Generate soundbanks](https://www.audiokinetic.com/en/library/edge/?source=Help&id=generating_soundbanks_for_project). The paths should be set up already, so only need to choose platforms and languages.
3. [Generate Wwise IDs in Godot](https://github.com/alessandrofama/wwise-godot-integration/wiki/Getting-Started#3-generating-the-wwise-ids-in-godot).
4. Restart Godot editor.
5. Adapt the project to sound changes if necessary, e.g. by calling new events.
6. Try the game.

### Profiling

To see the game communicating with Wwise, follow [Wwise 101 | Profiling game](https://www.audiokinetic.com/en/courses/wwise101/?source=wwise101&id=profiling_game#read). In the `Remote Connections` window, this game will have empty `Application Name`.
