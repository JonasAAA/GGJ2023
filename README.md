# Musical Root

## Wwise

### Prerequisites

* Download [Wwise Godot integration tool](https://github.com/alessandrofama/wwise-godot-integration/releases/download/1.5.0_Wwise2021.1.4.7707/Wwise.Godot.Integration.App.exe).
  * Run it. You will get a like "Windows protected your PC". As the message notes, running `.exe` files downloaded from the internet can be dangerous, only run trusted files. In this case, this should be trusted. Click on `More info` and the option `Run Anyway` will appear. Click that.
  * Choose integration version `1.5.0_Wwise2021.1.4.7707`, select all platforms, select Godot's project file (named `project.godot`), then click `Install`.
* In order for Wwise integration to work, install `Visual Studio 2019 Build Tools` or `Visual Studio 2019` (the former is smaller than the latter, so if you have neither, it will be faster to install the former).
  * When installing it, go to `Individual Components` tab (see [here](https://learn.microsoft.com/en-us/visualstudio/install/modify-visual-studio?view=vs-2022#change-workloads-or-individual-components) how that looks) and select `MSVC v142 - VS 2019 C++ x64/x86 build tools (Latest)` (can paste this name into the search box).
* Install Wwise version 2021.1.13.
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

Currently (as of 2023-07-01) when press `space` when playing a level, should get the `level complete` sound effect which is acually a Wwise event, so should be seen when profiling.
