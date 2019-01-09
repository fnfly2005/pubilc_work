#!/bin/bash
#sudo rm ${private_home}/.git/FETCH_HEAD ${public_home}/.git/FETCH_HEAD
cd ${private_home} && git pull
cd ${public_home} && git pull
