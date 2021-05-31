# Camera Vendor Instructions from email:

The SDK manager is used to flash the Jetpack 4.4.1 version to the Xavier NX dev kit. To install the camera drivers you need to download it from our developer website by using the Sales Order number.

Please find the FTP login credentials to download the camera drivers of e-CAM24_CUNX
Use Firefox because chrome doesn't seem to allow ftp:// links
Host: ftp://ftp.e-consystems.com/
User Name : `e-CAM24-CUNX@ftp.e-consystems.com`
Password : `Mecxn2920*$`

Note: Download the Release file: e-CAM24_CUNX_JETSON_L4T32.4.4_08-FEB-2020_R01_RC2.tar.xz

4. Copy the e-CAM24_CUNX Release package into the HOME directory of the flashed Jetson Xavier NX development kit.

5. Extract the release package in the Jetson Xavier NX development kit to obtain the binaries.

        tar -xaf e-CAM24_CUNX_JETSON_<L4T_version>_<release_date>_<release_version>.tar.gz
        cd e-CAM24_CUNX_JETSON_<L4T_version>_<release_date>_<release_version>

6. Run the following commands in the Jetson kit:

        sudo chmod +x ./install_binaries_<version>.sh
        sudo ./install_binaries_<version>.sh

7. This script will automatically reboot the Jetson kit after flashing the binaries successfully.

8. Run the following command to set the power mode to maximum for better performance.

        sudo nvpmodel -m 0
        sudo jetson_clocks

1. After Booting, run the following command to check the presence of camera video node.

        ls /dev/video*

2.  The output message appears as shown below:

        video0

3.  Run the following command to launch the sample camera application.

        ecam_tk1_guvcview

Please try the above steps and if you still face any issues, kindly get back to us with the following information to assist you further,

Run the below command to check the L4T version and share the output log for the same

    cat /etc/nv_tegra_release