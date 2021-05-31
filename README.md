# nvidia-jetson-setup

The configs are still experimental and not yet final, this is a bunch of random commands that are scattered around in header2's.

We are using the [NVidia Jetson Xavier NX Developer Kit](https://developer.nvidia.com/embedded/jetson-xavier-nx-devkit) for computing.

We can create an SD card image and just reuse that (basically a clone of the entire system)

- [official documentation](https://docs.nvidia.com/jetson/l4t/index.html)
- [Medium article: The Newbie Guide to Setting Up a Jetson Nano on JP4.4 Part 1: Running Jupyter Lab Headless Using SSH](https://medium.com/swlh/the-newbie-guide-to-setting-up-a-jetson-nano-on-jp4-4-230449346258)

## Flashing the Jetson

You must flash it using the SDK manager Jetpack 4.4.1 (for compatibility with the camera)

### Communicating using USB cable

To connect it using the USB on Linux, use

```bash
sudo minicom -D /dev/ttyACM0 -8 -b 115200
```

### Backing up SD card

 (replace `/dev/sdX` with proper device, use `sudo fdisk -l` to check)

```bash
# write image from SD card to file
sudo dd bs=32M if=/dev/sdX of="jetson_backup_$(date).img" status=progress

# write image from file to SD card
sudo dd bs=32M if="<jetson_backup>.img" of=/dev/sdX status=progress
```

### Adding swap

```bash
# adding swap space
gbswp=20
sudo fallocate -l ${gbswp}G /mnt/${gbswp}GB.swap
sudo chmod 600 /mnt/${gbswp}GB.swap
sudo mkswap /mnt/${gbswp}GB.swap
echo "/mnt/${gbswp}GB.swap swap swap defaults 0 0" | sudo tee -a /etc/fstab
sudo swapon /mnt/${gbswp}GB.swap

## set swapiness
#sudo sh -c 'echo 1 > /proc/sys/vm/swappiness'

```

## Installing packages

### installing nodejs (for Jupyter)

```bash
#nodejs
wget https://nodejs.org/dist/v12.21.0/node-v12.21.0-linux-arm64.tar.xz tar
tar -xJf node-v12.21.0-linux-arm64.tar.xz
cd ./node-v12.21.0-linux-arm64 && sudo cp -R * /usr/local/
node -v
npm -v
```

```bash
sudo apt install -y libffi-dev libssl1.0-dev

#sudo apt install -y nodejs npm
sudo -H pip3 install jupyter jupyterlab
sudo jupyter labextension install @jupyter-widgets/jupyterlab-manager

### jupyter remote access:
# on the workstation:sudo -H pip3 install jupyter jupyterlabsudo -H pip3 install jupyter jupyterlab
yes|jupyter notebook --generate-config
yes|jupyter lab --generate-config
echo 'c.NotebookApp.ip = "localhost"
c.ServerApp.allow_remote_access = True' | tee -a ~/.jupyter/jupyter_notebook_config.py ~/.jupyter/jupyter_lab_config.py
# (optional)
jupyter notebook password; jupyter lab password 

```
### Installing OpenCV 4.1.1

[install_opencv4.1.1.sh](files/install_opencv4.1.1.sh)

### Installing python packages

Be very careful and only install what is needed, be especially careful with `OpenCV`, `tensorflow`, `numpy`, `scipy` versions.


To choose TensorFlow version, see [compatibility matrix](https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform-release-notes/tf-jetson-rel.html).


```bash
# the general stuff
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip
sudo -H pip3 install -U pip testresources setuptools==49.6.0

# working: numpy==1.19.4 scipy==1.5.4
sudo apt install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran
sudo -H pip3 install -U numpy==1.19.4 future==0.18.2 mock==3.0.5 h5py==2.10.0 gast==0.2.2 keras_preprocessing==1.1.2 keras_applications==1.0.8 futures protobuf pybind11 scipy==1.4.1
JP_VERSION=44

# check this page for compatibility matrix:
#   https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform-release-notes/tf-jetson-rel.html
sudo -H pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow==2.3.1+nv20.12

sudo apt install -y libcanberra-gtk-module libcanberra-gtk3-module

sudo apt install -y nano qemu-user-static v4l-utils

sudo add-apt-repository universe
sudo add-apt-repository multiverse
sudo apt update
sudo apt install -y gstreamer1.0-tools gstreamer1.0-alsa gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav
sudo apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-good1.0-dev libgstreamer-plugins-bad1.0-dev
gst-inspect-1.0 --version

sudo -H pip3 install -U jetson-stats

sudo nvpmodel -m 2 # setting to 15 watt mode
sudo jetson_clocks # disable throttling
```

## Remote access

using ssh port forwarding

```bash
echo "[daemon]
AutomaticLoginEnable=true
AutomaticLogin=$USER" | sudo tee -a /etc/gdm3/custom.conf/etc/gdm3/custom.conf/etc/gdm3/custom.conf

echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

```

Download the .pem file and the corresponding tunneling file and put them in the home directory (user home, meaning `/hom/$USER` and you should see them when you type `ls` from home)


Place [tunneling.sh](files/tunneling.sh) in the home directory (`~`).

```bash
sudo apt install -y autossh
chmod 400 nommas_tunneling.pem

#NOTE: PEM_FILE and AWS_PUBLIC_IP must be changed based on the server

mkdir ~/log
echo "
export PEM_FILE=~/nommas_tunneling.pem
export AWS_PUBLIC_IP=ec2-xxx-xxx-xxx-xxx.xxx.compute.amazonaws.com
cd ~ && sh ~/tunneling.sh >> ~/log/tunneling.sh.log 2>&1 &
(jupyter lab list|grep :8888) || cd ~ && jupyter lab --no-browser --port 8888 >> ~/log/jupyterlab.log 2>&1 &
source /etc/profile &
gsettings set org.gnome.nautilus.preferences executable-text-activation 'launch' & # allow user to execute by double-clicking
export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1
" >> ~/.profile
echo "
sudo nvpmodel -m 2 & # setting to 15 watt mode
sudo jetson_clocks & # disable throttling
" | sudo tee -a /etc/profile

echo '
#!/usr/bin/bash
source ~/.profile &
xdg-open "http://localhost:8888/notebooks/defect_detection/deployment.ipynb" &
' > ~/Desktop/nommas_inspector
sudo chmod +x ~/Desktop/nommas_inspector.sh

```

put both files in the user's home directory (`/home/$USER`)

## Camera drivers (AKA hell :fire:)

We are using the [e-CAM217_CUMI0234_MOD - Full HD Color Global Shutter Camera Module](https://www.e-consystems.com/camera-modules/ar0234-global-shutter-camera-module.asp) (1280 x 720)120fps UYVY

For documentation, see the website, the docs in the release packages, and also the emails attached [camera_vendor_installation_email.md](./camera_vendor_installation_email.md)


### Commands to use camera

```bash
# gstreamer command to view what camera sees
/usr/local/ecam_tk1/bin/ecam_tk1_guvcview --device=/dev/video0
```

To use in python, use the following:

```python
# this works nicely, but to reach high FPS, you must use threaded queues like imutils.video.FileVideoStream
# ~32fps

# autobrightness ON
spec = 'v4l2src device=/dev/video0 ! video/x-raw, format=(string)UYVY, width=(int)1280, height=(int)720, framerate=120/1! nvvidconv ! video/x-raw(memory:NVMM), format=(string)BGRx ! nvvidconv ! video/x-raw, format=BGRx ! videoconvert ! video/x-raw, format=BGR ! appsink'
# autobrightness OFF (, --aeantibanding=2)
spec = 'v4l2src device=/dev/video0 ! video/x-raw, --aeantibanding=2, format=(string)UYVY, width=(int)1280, height=(int)720, framerate=120/1! nvvidconv ! video/x-raw(memory:NVMM), format=(string)BGRx ! nvvidconv ! video/x-raw, format=BGRx ! videoconvert ! video/x-raw, format=BGR ! appsink'
cam = cv2.VideoCapture(spec, cv2.CAP_GSTREAMER)
```

----

## [extras](extras.md)

---

## TODO

- [ ] add a `Resources` section
- [ ] add jetson flash instructions
