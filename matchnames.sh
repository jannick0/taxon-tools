#! /usr/bin/sh

## wrapper script for matchnames.awk allowing to optionally
#  load gawk extensions
do_version=0
while test x$1 != x; do
  case $1 in
    (-V|--version) do_version=1 ;;
    (-l) shift; gargs="$gargs -l $1" ;;
    (-l*) gargs="$gargs $1" ;;
    (--DEBUG) set -xe ;;
    (*) args="$args $1" ;;
  esac
  shift
done

if test $do_version = 1; then
  gawk $gargs --version | sed '/^Copyright/,$d'
  exit
fi

gawk $gargs -f matchnames $args
