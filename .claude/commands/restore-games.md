---
description: Restore all games and save files from the external backup drive onto this Omarchy machine
---

Restore Dendup's games and saves from the external drive. Work carefully — save files are irreplaceable.

## Where the backup is
External USB drive, NTFS partition labelled **D**. Mount it (`udisksctl mount -b /dev/disk/by-label/D`)
and find the folder `Ubuntu_backup_2026-10-29/`. Layout:

| Backup path | Restore to | Contents |
|---|---|---|
| `games/Games/` | `~/Games/` | Wine prefixes (Lutris games). Windows saves live in `*/drive_c/users/*/` |
| `games/windows games/` | `~/windows games/` | Hollow Knight Silksong |
| `games/Switch/` | `~/Switch/` | Zelda TOTK .nsp + update |
| `games/eden/share/` | `~/.local/share/eden/` | Eden (Switch emulator): `nand/` = saves, `keys/` = prod.keys |
| `games/eden/config/` | `~/.config/eden/` | Eden settings |
| `games/steam/steamapps/` | `~/.local/share/Steam/steamapps/` | Celeste, Terraria, Sky + appmanifests + Proton prefixes (compatdata) |
| `games/steam/userdata/` | `~/.local/share/Steam/userdata/` | Steam local saves / controller configs |
| `games/lutris-flatpak/` | `~/.var/app/net.lutris.Lutris/` | Lutris game entries (`data/lutris/games/*.yml`), cover art, Wine runners |
| `games/shadps4-flatpak/` | `~/.var/app/net.shadps4.shadPS4/` | shadPS4 saves (`user/` / `home/`), keys, config |
| `games/.minecraft/` | `~/.minecraft/` | Minecraft worlds, mods, launcher profiles |
| `Documents/games/` | `~/Documents/games/` | Hades II, Stardew Valley, God of War Ragnarök files + saved games |
| `Documents/PvZ.Fusion...`, `Documents/TLOU-Part-II-SteamRIP.com(1)/` | `~/Documents/` | game files referenced by Lutris |
| `Downloads/Dead Cells`, `Devil May Cry 5`, `Sekiro`, `Undertale` | `~/Downloads/` | game files referenced by Lutris |

(If the user already restored Documents/Downloads in full, skip those rows.)

## Steps
1. **Confirm** the drive is mounted and print `du -sh` of each backup folder. Check free space on `~` (`df -h ~`); need ~60 GB. Stop and tell the user if there isn't enough.
2. **Never overwrite newer saves blindly.** If a destination already exists, ask the user before replacing it; otherwise move it to `<name>.pre-restore-bak`.
3. **Install the apps first** (ask before large installs):
   - Steam: enable `[multilib]` in `/etc/pacman.conf` if needed, then `sudo pacman -S --needed steam`. Launch it once and close it so `~/.local/share/Steam` exists, then restore steamapps/userdata.
   - Lutris + shadPS4: install as **flatpaks** (`flatpak install -y flathub net.lutris.Lutris net.shadps4.shadPS4`) so the restored `~/.var/app/...` paths match exactly.
   - Wine deps for Lutris: `sudo pacman -S --needed wine winetricks lib32-vulkan-icd-loader` plus the 32-bit GPU driver (`lib32-nvidia-utils` on NVIDIA, `lib32-vulkan-radeon` / `lib32-vulkan-intel` otherwise) — detect the GPU with `lspci`.
   - Eden: search `yay -Ss eden` for the Switch emulator (or AppImage from the upstream project). Don't guess — confirm with the user.
   - Minecraft: ask which launcher they use (official `minecraft-launcher` AUR or Prism `prismlauncher`).
4. **Copy** with `rsync -rtv --info=progress2 "<backup>/" "<dest>/"` (trailing slashes!). NTFS has no Unix permissions, so afterwards fix them: `chmod -R u+rwX <dest>` and make executables runnable (`find <dest> -name '*.exe' -o -name '*.sh' | xargs chmod +x` is fine).
5. **Wine prefixes use symlinks** (`pfx -> .`, `dosdevices/`, `drive_c/windows/system32/*.dll`) which NTFS couldn't store. Recreate them: for each `~/Games/<game>`, ensure `pfx` symlink exists (`ln -sfn . pfx`), then run `WINEPREFIX=~/Games/<game> wineboot -u` (or let Lutris do it on first launch) to regenerate missing system DLL links and `dosdevices`. Saves in `drive_c/users/` are untouched by this.
6. **Fix paths if the username changed**: Lutris yml files and Steam libraryfolders hardcode `/home/dendup/`. If `$HOME` is not `/home/dendup`, `sed -i "s#/home/dendup#$HOME#g"` on `~/.var/app/net.lutris.Lutris/data/lutris/games/*.yml` and `~/.local/share/Steam/steamapps/libraryfolders.vdf` (back them up first).
7. **Verify**: open Lutris and confirm all games are listed (Dead Cells, DMC5, Hades II, PvZ Fusion, Sekiro, Silksong, TLOU, Undertale…); in Steam confirm Celeste/Terraria/Sky show as installed (Steam may "verify" files — fine). Launch one game per launcher if the user agrees.
8. **Report** a table: game → files restored? saves restored? launches? and anything that failed.
