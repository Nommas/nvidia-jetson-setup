# Extras

## Failed gstreamer camera commands

Bellow are failed attempts of gstreamer commands:

```sh
### Bellow are all failures
gst-launch-1.0 v4l2src device=/dev/video0 ! "video/xraw, format=(string)UYVY, width=(int)1920,height=(int)1200" ! nvvidconv ! "video/xraw(memory:NVMM), format=(string)I420, width=(int)1920,height=(int)1080" ! nvoverlaysink overlay-w=1920 overlay-h=1080 sync=false
gst-launch-1.0 -v videotestsrc ! 'video/x-raw, format=(string)UYVY, width=(int)1920, height=(int)1080' ! nvvidconv ! 'video/x-raw(memory:NVMM), format=(string)NV12' ! nvegltransform ! nveglglessink -e
gst-launch-1.0 -v videotestsrc ! 'video/x-raw, format=(string)UYVY, width=(int)1280, height=(int)720'  ! nvvidconv ! 'video/x-raw(memory:NVMM), format=(string)UYVY' ! nvegltransform ! nveglglessink -e
gst-launch-1.0 v4l2src device=/dev/video0 ! "video/xraw, format=(string)UYVY, width=(int)1920,height=(int)1080" ! nvvidconv ! "video/xraw(memory:NVMM), format=(string)I420" ! omxh264enc qprange=20,20:20,20:-1,-1 ! matroskamux ! queue ! filesinklocation=file.mkv
gst-launch-1.0 v4l2src device=/dev/video0 ! "video/xraw, format=(string)UYVY, width=(int)1920,height=(int)1200" ! nvvidconv ! "video/xraw(memory:NVMM), format=(string)I420, width=(int)1920,height=(int)1080" ! nvoverlaysink overlay-w=1920 overlay-h=1080 sync=false
gst-launch-1.0 v4l2src device=/dev/video0 ! "video/xraw, format=(string)UYVY, width=(int)1920,height=(int)1080" ! nvvidconv ! "video/xraw(memory:NVMM), format=(string)I420" ! nvoverlaysinksync=false
#not working
gst-launch-1.0 -v videotestsrc ! 'video/x-raw, format=(string)UYVY, width=(int)1920, height=(int)1080' ! nvvidconv ! 'video/x-raw(memory:NVMM), format=(string)NV12' ! omxh264enc ! qtmux ! filesink location=test_1080p.mp4 -e
gst-launch-1.0 -v videotestsrc ! 'video/x-raw, format=(string)UYVY, width=(int)1920, height=(int)1080' ! nvvidconv
```

## installing conda (if needed)

```bash
wget https://github.com/Archiconda/build-tools/releases/download/0.2.3/Archiconda3-0.2.3-Linux-aarch64.sh
sudo sh Archiconda3-0.2.3-Linux-aarch64.sh -b -p $HOME/archiconda3
conda config --set auto_activate_base true
```

## Labeling

```bash
# https://github.com/tzutalin/labelImg
sudo apt-get install pyqt5-dev-tools
sudo -H pip3 install git+https://github.com/tzutalin/labelImg
```

## Setting resolution

```bash
#MODENAME=$(gtf 1920 1080 60 |tail -n 2|head -n 1|awk '{$1=""}1')
#xrandr --newmode $MODENAME

xrandr --newmode "1920x1080_60.00" 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -HSync +Vsync
xrandr --addmode DP-0 "1920x1080_60.00"
xrandr --output DP-0 --mode "1920x1080_60.00"
xrandr -s 1440x900
```

### installing tensorRT

It's very important but I'm pretty sure tensorRT comes preinstalled so that's why it's in extras

```bash
# open this and sign in and download this file
wget https://developer.nvidia.com/compute/machine-learning/tensorrt/secure/7.2.2/local_repos/nv-tensorrt-repo-ubuntu1804-cuda10.2-trt7.2.2.3-ga-20201211_1-1_amd64.deb
```
