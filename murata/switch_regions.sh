#!/bin/sh

# Switching Tx power binary, edmac, bluetooth power, and regulatory.bin files based on module selection"

VERSION="1.0"
MODULE=1ZM
TYPE=`getconf LONG_BIT`
COUNTRY=US

function clean_up() {
  # Disable country code service
  if [ -e /etc/systemd/system/start_country.service ]; then
    systemctl stop start_country.service
    # Disable country code service
    systemctl disable start_country.service
  fi

  # if there is startup_setcountry, then delete
  if [ -e /usr/sbin/startup_setcountry.sh ]; then
    rm /usr/sbin/startup_setcountry.sh
  fi
}

function load_files() {
  # check for the existence of folder, "crda"
  if [ ! -d "/usr/lib/crda" ]
  then
    echo "Directory /usr/lib/crda does not exist."
    echo "Creating crda in /usr/lib/"
    mkdir /usr/lib/crda
    cp /lib/firmware/nxp/murata/files/regulatory.rules /etc/udev/rules.d/
  fi

  # Copy regulatory files
  cp /lib/firmware/nxp/murata/files/${MODULE}/regulatory.bin /usr/lib/crda
  cp /lib/firmware/nxp/murata/files/${TYPE}_bit/crda /usr/sbin/
  cp /lib/firmware/nxp/murata/files/${TYPE}_bit/regdbdump /usr/sbin/
  cp /lib/firmware/nxp/murata/files/${TYPE}_bit/libreg.so /usr/lib/

  # Copy Tx power, edmac and bluetooth power files to /lib/firmware/nxp
  cp /lib/firmware/nxp/murata/files/${MODULE}/txpower_*.bin /lib/firmware/nxp
  cp /lib/firmware/nxp/murata/files/${MODULE}/ed_mac.bin /lib/firmware/nxp

  # Copy bluetooth power config file
  if [ ! -f /lib/firmware/nxp/bt_power_config_1.sh ]; then
    cp /lib/firmware/nxp/murata/files/bt_power_config_1.sh /lib/firmware/nxp
  fi

  # Changing the country code internally for EU to set to "DE" instead of "EU"
  if [ ${COUNTRY} == "EU" ]; then
 	COUNTRY=DE
  fi

  # Create "startup_setcountry.sh" with the new country code
  cat <<EOT > /usr/sbin/startup_setcountry.sh
#!/bin/bash
iw reg set ${COUNTRY}
EOT

  # Copy start_country.service to /etc/systemd/system/
  cp /lib/firmware/nxp/murata/files/start_country.service /etc/systemd/system

  iw reg set ${COUNTRY}
  echo "Setup complete."
  echo ""

  iw reg get
  echo ""

  # Enable country code service
  systemctl enable start_country.service

  echo "Please reboot and then enter the following command for verification"
  echo "$ iw reg get"
}

function update_conf_file_1zm() {
  # Update the wifi_mod_para.conf file based on ${MODULE} and ${COUNTRY}. Keep a backup.
  if [ ! -f /lib/firmware/nxp/wifi_mod_para.conf.orig ]; then
    if [ -f /lib/firmware/nxp/wifi_mod_para.conf ]; then
      cp /lib/firmware/nxp/wifi_mod_para.conf /lib/firmware/nxp/wifi_mod_para.conf.orig
    fi
  fi

  cp /lib/firmware/nxp/murata/files/wifi_mod_para_murata.conf /lib/firmware/nxp/wifi_mod_para.conf

  case ${COUNTRY} in
    US)
      ;;
    EU)
      sed -i '83s/txpower_US/txpower_EU/' /lib/firmware/nxp/wifi_mod_para.conf
      sed -i '84 i muratainit_hostcmd_cfg=nxp/ed_mac.bin' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    JP)
      sed -i '83s/txpower_US/txpower_JP/' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    CA)
      sed -i '83s/txpower_US/txpower_CA/' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    *)
      ;;
  esac
  sed -i 's/murata/	/g' /lib/firmware/nxp/wifi_mod_para.conf
}

function update_conf_file_1ym() {
  # Update the wifi_mod_para.conf file based on ${MODULE} and ${COUNTRY}. Keep a backup.
  if [ ! -f /lib/firmware/nxp/wifi_mod_para.conf.orig ]; then
    if [ -f /lib/firmware/nxp/wifi_mod_para.conf ]; then
      cp /lib/firmware/nxp/wifi_mod_para.conf /lib/firmware/nxp/wifi_mod_para.conf.orig
    fi
  fi

  cp /lib/firmware/nxp/murata/files/wifi_mod_para_murata.conf /lib/firmware/nxp/wifi_mod_para.conf

  case ${COUNTRY} in
    US)
      ;;
    EU)
      sed -i '39s/txpower_US/txpower_EU/' /lib/firmware/nxp/wifi_mod_para.conf
      sed -i '103s/txpower_US/txpower_EU/' /lib/firmware/nxp/wifi_mod_para.conf
      sed -i '40 i muratainit_hostcmd_cfg=nxp/ed_mac.bin' /lib/firmware/nxp/wifi_mod_para.conf
      sed -i '105 i muratainit_hostcmd_cfg=nxp/ed_mac.bin' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    JP)
      sed -i '39s/txpower_US/txpower_JP/' /lib/firmware/nxp/wifi_mod_para.conf
      sed -i '103s/txpower_US/txpower_JP/' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    CA)
      sed -i '39s/txpower_US/txpower_CA/' /lib/firmware/nxp/wifi_mod_para.conf
      sed -i '103s/txpower_US/txpower_CA/' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    *)
      ;;
  esac
  sed -i 's/murata/	/g' /lib/firmware/nxp/wifi_mod_para.conf
}

function update_conf_file_1xk() {
  # Update the wifi_mod_para.conf file based on ${MODULE} and ${COUNTRY}. Keep a backup.
  if [ ! -f /lib/firmware/nxp/wifi_mod_para.conf.orig ]; then
    if [ -f /lib/firmware/nxp/wifi_mod_para.conf ]; then
      cp /lib/firmware/nxp/wifi_mod_para.conf /lib/firmware/nxp/wifi_mod_para.conf.orig
    fi
  fi

  cp /lib/firmware/nxp/murata/files/wifi_mod_para_murata.conf /lib/firmware/nxp/wifi_mod_para.conf

  case ${COUNTRY} in
    US)
      ;;
    EU)
      sed -i '163s/txpower_US/txpower_EU/' /lib/firmware/nxp/wifi_mod_para.conf
      sed -i '164 i muratainit_hostcmd_cfg=nxp/ed_mac.bin' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    JP)
      sed -i '163s/txpower_US/txpower_JP/' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    CA)
      sed -i '163s/txpower_US/txpower_CA/' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    *)
      ;;
  esac

  sed -i 's/murata/	/g' /lib/firmware/nxp/wifi_mod_para.conf
}

function update_conf_file_2ds() {
  # Update the wifi_mod_para.conf file based on ${MODULE} and ${COUNTRY}. Keep a backup.
  if [ ! -f /lib/firmware/nxp/wifi_mod_para.conf.orig ]; then
    if [ -f /lib/firmware/nxp/wifi_mod_para.conf ]; then
      cp /lib/firmware/nxp/wifi_mod_para.conf /lib/firmware/nxp/wifi_mod_para.conf.orig
    fi
  fi

  cp /lib/firmware/nxp/murata/files/wifi_mod_para_murata.conf /lib/firmware/nxp/wifi_mod_para.conf

  case ${COUNTRY} in
    US)
      ;;
    EU)
      sed -i '173s/txpower_US/txpower_EU/' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    JP)
      sed -i '173s/txpower_US/txpower_JP/' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    CA)
      sed -i '173s/txpower_US/txpower_CA/' /lib/firmware/nxp/wifi_mod_para.conf
      ;;
    *)
      ;;
  esac

  sed -i 's/murata/	/g' /lib/firmware/nxp/wifi_mod_para.conf
}

function switch_to_1zm() {
  echo ""
  echo "Setting up for 1ZM (${TYPE} bit):"
  echo "----------------------------"
  clean_up
  load_files
  update_conf_file_1zm
  echo ""
}

function switch_to_1ym() {
  echo ""
  echo "Setting up for 1YM (${TYPE} bit):"
  echo "----------------------------"
  clean_up
  load_files
  update_conf_file_1ym
  echo ""
}

function switch_to_1xk() {
  echo ""
  echo "Setting up for 1XK (${TYPE} bit):"
  echo "----------------------------"
  clean_up
  load_files
  update_conf_file_1xk
  echo ""
}

function switch_to_2ds() {
  echo ""
  echo "Setting up for 2DS (${TYPE} bit):"
  echo "----------------------------"
  clean_up
  load_files
  update_conf_file_2ds
  echo ""
}

function usage() {
  echo ""
  echo "Version: $VERSION"
  echo ""
  echo "Usage:"
  echo "  $0  <module> <country code>"
  echo ""
  echo "Where:"
  echo "  <module> is one of :"
  echo "     1zm, 1ym, 1xk, 2ds"
  echo ""
  echo "  <country code> is one of :"
  echo "     CA, EU, JP, US"
  echo "     CA - Canada"
  echo "     EU - European Union"
  echo "     JP - Japan"
  echo "     US - United States"
  echo "NOTE: Country code for EU will be displayed as DE when you use the command - iw reg get"
  echo "      For setting the country code EU, user should use : iw reg set DE"
  echo ""
}

if [[ $# -lt 2 ]]; then
  usage
  exit 1
fi

case ${2^^} in
  US)
    COUNTRY=US
    ;;
  EU)
    COUNTRY=EU
    ;;
  JP)
    COUNTRY=JP
    ;;
  CA)
    COUNTRY=CA
    ;;
  *)
    #current
    usage
    exit 1
    ;;
esac

case ${1^^} in
  ZM|1ZM)
    MODULE=1ZM
    switch_to_1zm
    ;;
  XK|1XK)
    MODULE=1XK
    switch_to_1xk
    ;;
  2DS)
    MODULE=2DS
    switch_to_2ds
    ;;
  YM|1YM)
    MODULE=1YM
    switch_to_1ym
    ;;
  *)
    #current
    usage
    exit 1
    ;;
esac
