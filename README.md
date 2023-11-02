# my-dot-files
> Vim-driven set up, the goal is to use the mouse as less as possible, based on vim, fzf, ripgrep usage.  
> ⭐️ Thanks everyone who has starred the project, it means a lot!

## How it looks:
![Picture of a screen](./screen.png)

## Display manager (SDDM)
![Picture of a SDDM](./blade-runner-theme.png)

## Rofi
![Picture of rofi](./rofi.png)

## Main info (get with neofetch)
```
                   -`                    dzmitry@megatron
                  .o+`                   ----------------
                 `ooo/                   OS: Arch Linux x86_64
                `+oooo:                  Host: 20QV0007US ThinkPad X1 Extreme 2nd
               `+oooooo:                 Kernel: 5.15.61-1-lts
               -+oooooo+:                Uptime: 48 mins
             `/:-:++oooo+:               Packages: 1911 (pacman)
            `/++++/+++++++:              Shell: zsh 5.9
           `/++++++++++++++:             Resolution: 1920x1080
          `/+++ooooooooooooo/`           DE: i3-with-shmlog
         ./ooosssso++osssssso+`          WM: i3
        .oossssso-````/ossssss+`         Theme: Arc-Dark [GTK2/3]
       -osssssso.      :ssssssso.        Icons: Papirus [GTK2], Papirus-Dark [GTK3]
      :osssssss/        osssso+++.       Terminal: st
     /ossssssss/        +ssssooo/-       Terminal Font: JoyPixels
   `/ossssso+/:-        -:/+osssso+-     CPU: Intel i7-9750H (12) @ 4.500GHz
  `+sso+:-`                 `.-/+oso:    GPU: NVIDIA GeForce GTX 1650 Mobile / Max-Q
 `++:.                           `-/+/   GPU: Intel CoffeeLake-H GT2 [UHD Graphics 630]
 .`                                 `/   Memory: 6693MiB / 15643MiB
```


## General
**OS:** Arch Linux x86_64 LTS

**Window Manager:** i3-gaps

**Screen Locker**: i3lock-fancy

**Status Bar**: Polybar

**Terminal:** [myst](https://github.com/funnydman/myst) (based on Luke Smith's build | vim key bindings)

**Shell:** zsh 

**Dropdown Terminal:** guake

**File Manager:** ranger, nautilus

**Package Manager:** yay

**Reader (pdf, epub, etc):** zathura

**Display Manager:** SDDM, [custom blade runner theme](https://github.com/funnydman/blade-runner-theme)

**Notification Daemon:** dunst 

**Browser:** Firefox (theme: Matte Black (blue)), plugins: 
 - tridactyl (like vimium but much better)
 - Privacy Badger
 - Joplin Web Clipper
 - Grammarly for Firefox
 - Awesome Emoji Picker
 - RESTer
 - uBlock Origin
 - Temp Mail - Disposable Temporary Email
 - Unhook YouTube (Remove YouTube Recommended Videos, Comments)
 - TempMail
 - Simple Translate
 - Redux DevTools
 - React Developer Tools
 - Youtube Watchmarker
 - Todoist: To-Do list and Task Manager
 - Tampermonkey

**Editor:** neovim ([gruvbox theme](https://www.google.com/search?client=firefox-b-d&q=gruvbox)), ideavim for Pycharm

**Window switcher:** Rofi

## Additional 

**Password Manager:** keepass

**Screenshoter:** flameshot

**Notes Taking:** Joplin (highly recommend), Obsidian (for Zettelkasten) - outdated, don't use that now -

**Image Viewer:** feh

**Media Player:** mpv

**Graphics Editor:** GIMP

**Bluetooth manager:** Blueman

## Fonts
Dealing with fonts is painfull, this helped me:
- https://gist.github.com/YoEight/d19112db56cd8f93835bf2d009d617f7
- https://wiki.archlinux.org/title/fonts

Note:  it should be Noto Sans Mono, **not** Noto Mono.

Some useful commands for debugging:
```
fc-list | grep "Noto Mono"
fc-match monospace
fc-match serif
fc-match sans-serif

# To update config
fc-cache 
```

Configuration `cat /etc/fonts/local.conf`:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
   <match>
      <edit mode="prepend" name="family">
         <string>Noto Sans</string>
      </edit>
   </match>
   <match target="pattern">
      <test qual="any" name="family">
         <string>serif</string>
      </test>
      <edit name="family" mode="assign" binding="same">
         <string>Noto Serif</string>
      </edit>
   </match>
   <match target="pattern">
      <test qual="any" name="family">
         <string>sans-serif</string>
      </test>
      <edit name="family" mode="assign" binding="same">
         <string>Noto Sans</string>
      </edit>
   </match>
   <match target="pattern">
      <test qual="any" name="family">
         <string>monospace</string>
      </test>
      <edit name="family" mode="assign" binding="same">
         <string>Noto Sans Mono</string>
      </edit>
   </match>
</fontconfig>
```

## Applications 
### Pycharm plugins
* Save Action
* Key promoter
* extra icons
* string manipulation
* AceJump
* Grep Console
* shellcheck
* Code Glance
* ideavim
