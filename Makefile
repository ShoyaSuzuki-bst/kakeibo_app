DIR := $(shell pwd)
MAKEFILE_PATH := ${DIR}/Makefile

make := make -f ${MAKEFILE_PATH}

simulator: #シミュレータ起動
	open -a Simulator