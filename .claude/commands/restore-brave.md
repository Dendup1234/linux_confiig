---
description: Restore Brave browser profile (bookmarks, history, extensions, passwords) from the external backup drive
---

Restore Dendup's Brave browser profile from the external drive onto this Omarchy machine.

## Backup location
A single archive `brave-backup-2026-10-29.tar.zst` (~900 MB). It is on the external USB drive (NTFS, label **D**,
`udisksctl mount -b /dev/disk/by-label/D`) in `Ubuntu_backup_2026-10-29/`. If it's not there, ask the user where they
put it. It contains paths relative to `$HOME`:

| In archive | Contents |
|---|---|
| `.config/BraveSoftware/Brave-Browser/` | Full profile: `Default/` = history, extensions, settings, saved passwords (encrypted), cookies. (The user had no bookmarks.) |
| `.local/share/keyrings/` | GNOME keyring holding "Brave Safe Storage" — the key that decrypts saved passwords/cookies |

The archive keeps Unix permissions, so no chmod fixing is needed. Extract to a temp dir first, never straight over `$HOME`:
`mkdir -p /tmp/brave-restore && tar --zstd -xf <archive> -C /tmp/brave-restore`

## Steps
1. **Install Brave**: `yay -S --needed brave-bin`. Launch it **once** and quit, so the folder exists, then make sure it's
   fully closed: `pkill -f brave; sleep 2; pgrep brave` must print nothing.
2. **Back up** whatever is there: `mv ~/.config/BraveSoftware/Brave-Browser ~/.config/BraveSoftware/Brave-Browser.fresh-bak`.
3. **Copy**: `mkdir -p ~/.config/BraveSoftware && cp -a /tmp/brave-restore/.config/BraveSoftware/Brave-Browser ~/.config/BraveSoftware/`
4. **Remove stale lock files** copied from the old machine:
   `rm -f ~/.config/BraveSoftware/Brave-Browser/Singleton{Lock,Socket,Cookie}`.
5. **Passwords/cookies keyring** — ask the user first:
   - Check Omarchy has `gnome-keyring` running (`pgrep gnome-keyring`); install `gnome-keyring libsecret seahorse` if not.
   - If `~/.local/share/keyrings/` is empty or only has a fresh keyring, back it up to `keyrings.fresh-bak`, then copy
     `/tmp/brave-restore/.local/share/keyrings/*` into `~/.local/share/keyrings/` and `chmod 700 ~/.local/share/keyrings; chmod 600 ~/.local/share/keyrings/*`.
   - The old `login.keyring` unlocks only with the user's **old login password**. If their new login password differs,
     they can open `seahorse` and unlock the "Login" keyring with the old password, or change it to match.
   - Log out and back in so the keyring is unlocked at login.
6. **Launch Brave** with the keyring backend: `brave --password-store=gnome-libsecret`. If passwords work, make it permanent:
   add `--password-store=gnome-libsecret` to `~/.config/brave-flags.conf`.
7. **Verify** with the user: bookmarks bar present, extensions listed in `brave://extensions`, history in `brave://history`,
   saved passwords visible in `brave://password-manager/passwords`, and sites still logged in.
   If passwords show as empty/broken: the keyring didn't match — fall back to **Brave Sync** (Settings → Sync, using the
   sync code from the old machine / phone) or a password CSV the user exported. Don't delete the backup.
8. Report what was restored and what wasn't, then `rm -rf /tmp/brave-restore`.
