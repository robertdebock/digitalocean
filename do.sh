#!/bin/bash

# A script to read information from Digital Ocean.

usage() {
  echo "Usage: $0 [-t TOKEN] list [droplets|images|keys]"
  echo
  echo "  -t TOKEN"
  echo "    The token to authenticate with."
  echo "    Either use -t or set DO_API_TOKEN."
  echo "  list images"
  echo "    Show images."
  echo "  list droplets"
  echo "    Show droplets."
  echo "  list keys"
  echo "    Show keys."
  
  exit 1
}

readargs() {
  while [ "$#" -gt 0 ] ; do
    case "$1" in
      -t)
        if [ "$2" ] ; then
          token="$2"
          shift ; shift
        else
          echo "Missing a value for $1."
          echo
          shift
          usage
        fi
      ;;
      list)
        action=list
        if [ "$2" ] ; then
          resource="$2"
          shift ; shift
        else
          echo "Missing a value for $1."
          echo
          shift
          usage
        fi
      ;;
      *)
        echo "Unknown option, argument or switch: $1."
        echo
        shift
        usage
      ;;
    esac
  done
}

checkargs() {
  if [ "${DO_API_TOKEN}" ] ; then
    token="${DO_API_TOKEN}"
  fi
  if [ ! "${token}" ] ; then
    echo "Missing token."
    usage
  fi
  if [ ! "${action}" ] ; then
    echo "No action specified."
    usage
  fi
  if [ ! "${resource}" ] ; then
    echo "No resource specified."
    usage
  fi

}

main() {
  curl \
    --request GET \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer ${token}" \
    https://api.digitalocean.com/v2/"${object}"
}

readargs "$@"
checkargs
main
