#!/bin/bash

## Environtment
export PATH="${PATH}:$HOME/.config/bspwm/bin"

## Get colors from .Xresources -------------------------------#
xrdb ~/.Xresources
getcolors () {
	FOREGROUND=$(xrdb -query | grep 'foreground:'| awk '{print $NF}')
	BACKGROUND=$(xrdb -query | grep 'background:'| awk '{print $NF}')
	BLACK=$(xrdb -query | grep 'color0:'| awk '{print $NF}')
	RED=$(xrdb -query | grep 'color1:'| awk '{print $NF}')
	GREEN=$(xrdb -query | grep 'color2:'| awk '{print $NF}')
	YELLOW=$(xrdb -query | grep 'color3:'| awk '{print $NF}')
	BLUE=$(xrdb -query | grep 'color4:'| awk '{print $NF}')
	MAGENTA=$(xrdb -query | grep 'color5:'| awk '{print $NF}')
	CYAN=$(xrdb -query | grep 'color6:'| awk '{print $NF}')
	WHITE=$(xrdb -query | grep 'color7:'| awk '{print $NF}')
}
getcolors

## Configurations -------------------------------#
bspc monitor -d '_>' 'files' 'music' 'www' 'work' 'etc'

bspc config border_width 1
bspc config window_gap 10
bspc config split_ratio 0.50

bspc config focused_border_color "$BLUE" 
bspc config normal_border_color "$BACKGROUND"
bspc config active_border_color "$MAGENTA"
bspc config presel_feedback_color "$GREEN"

bspc config borderless_monocle true
bspc config gapless_monocle true
bspc config paddingless_monocle true
bspc config single_monocle false
bspc config focus_follows_pointer true


## Window rules -------------------------------#

# remove all rules first
bspc rule -r *:*

# 1 > terminal
bspc rule -a Termite desktop='^1' follow=on focus=on

# 2 > files
bspc rule -a Thunar desktop='^2' follow=on focus=on

# 3 > music
bspc rule -a Rhythmbox desktop='^3' follow=on focus=on

# 4 > web
bspc rule -a firefox desktop='^4' follow=on focus=on

# 5 > office
declare -a office=(Gucharmap Evince \
libreoffice-writer libreoffice-calc libreoffice-impress \
libreoffice-startcenter libreoffice Soffice *:libreofficedev *:soffice)
for i in ${office[@]}; do
   bspc rule -a $i desktop='^5' follow=on focus=on; done
   
# 6 > etc
bspc rule -a Geany desktop='^6' follow=on focus=on

# special rules
bspc rule -a termite-float state=floating follow=on focus=on
bspc rule -a Pcmanfm state=floating follow=on focus=on
bspc rule -a Onboard state=floating follow=on focus=on
bspc rule -a Audacious state=floating follow=on focus=on
bspc rule -a Firefox:Places state=floating follow=on focus=on
bspc rule -a Viewnior state=floating follow=on focus=on
bspc rule -a Conky state=floating manage=off
bspc rule -a stalonetray state=floating manage=off

## Autostart -------------------------------#

# Kill if already running
killall -9 sxhkd xsettingsd dunst xfce4-power-manager

# Lauch notification daemon
dunst \
-geom "280x50-10+40" -frame_width "1" -font "Iosevka Custom 9" \
-lb "$BACKGROUND" -lf "$FOREGROUND" -lfr "$BLUE" \
-nb "$BACKGROUND" -nf "$FOREGROUND" -nfr "$BLUE" \
-cb "$BACKGROUND" -cf "$RED" -cfr "$RED" &

# Lauch keybindings daemon
sxhkd &

# Enable Super Keys For Menu
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

# Enable power management
xfce4-power-manager &

# Fix cursor
xsetroot -cursor_name left_ptr

# Restore wallpaper
bash $HOME/.fehbg

# Start bspwm scripts
bspcolors
bspcomp
bspbar
bspfloat &

# Issue Tracker (Don't Remove IT)
issue_tracker.sh
