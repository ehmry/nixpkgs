#! @shell@ -e

# Shows the usage of this command to the user

showUsage() {
    exec man nixos-build-tor-guest
    exit 1
}

# Parse valid argument options

PARAMS=`getopt -n $0 -o h,I: -l no-out-link,show-trace,help -- "$@"`

if [ $? != 0 ]
then
    showUsage
    exit 1
fi

eval set -- "$PARAMS"

# Evaluate valid options

while [ "$1" != "--" ]
do
    case "$1" in
	--no-out-link)
	    noOutLinkArg="--no-out-link"
	    ;;
	--show-trace)
	    showTraceArg="--show-trace"
	    ;;
        -I)
            shift
            IArg="-I $1"
            ;;
	-h|--help)
	    showUsage
	    exit 0
	    ;;
    esac
    
    shift
done

shift

# Validate the given options

if [ "$1" = "" ]
then
    echo "ERROR: A nixos configuration must be specified!" >&2
    exit 1
else
    configFile=$(readlink -f $1)
fi

# Build the guest image and make a hosting script

nix-build '<nixos/modules/installer/tools/nixos-build-tor-guest/build-tor-guest.nix>' \
    --argstr configFile $configFile $noOutLinkArg $showTraceArg $IArg
