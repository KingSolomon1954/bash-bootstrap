#!/usr/bin/env bash
#
# FILE
#     scriptName - briefly describe application of script
#
# SYNOPSIS
#     scriptName [options...] <file> ...
#
# OPTIONS
#     -h, --help               show this help
#     -v, --version            display version and exit
#     -p, --pretty-print       set pretty printing
#     -V, --verbose <level>    set verbosity to <level>
#
# DESCRIPTION
#     If there is a man page for the script, a reference can
#     be made to the man page. Otherwise, describe the application
#     of the script here.
#
# EXAMPLE
#     If there is a man page for the script, a reference can be
#     made to the man page. Otherwise, an example of script usage
#     can be provided here.
#
# ENVIRONMENT
#     If there is a man page for the script, a reference can be
#     made to the man page. Otherwise, describe any relevant
#     environment variables here.
#
# BUGS
#     If there is a man page for the script, a reference can be
#     made to the man page. Otherwise, describe any known bugs here.
#
# -----------------------------------------------------------

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace   # for debugging

# -----------------------------------------------------------
#
# Global variables. Actually, in a shell script, all variables in
# all functions are global, so be careful. The variables set here
# are those variables which are intended to be accessed globally.
#
scriptName=skeleton-no-deps.bash
readonly scriptName
readonly scriptVersion="1.0.0"
tmpFile="/tmp/${scriptName}.$$"
declare -i verbosityLevel=0
resourceReserved=false
prettyPrint=false
filesToProcess=

# -----------------------------------------------------------
#
# Main body of script.
#
main()
{
    # Set to call exitClean on SIGINT(2) or SIGTERM(15)
    trap 'exitClean 1' 2 15

    commandLine "$@"  # Parse command line
    showConfig        # Review config
    processFiles      # Perform the work
    exitClean 0       # Clean up and exit
}

# -----------------------------------------------------------
#
# After parsing command line, args are available as globals.
#
commandLine()
{
    while [ $# -gt 0 ]; do        # parse arguments
        case $1 in
        -h|--help)
            usage
            exitClean 0;;
        -v|--version)
            printVersion
            exitClean 0;;
        -p|--pretty-print)
            # Example of handling an option which doesn't require an argument
            prettyPrint=true;;
        -V|--verbose)
            # Example of handling an option which requires an argument
            if [ $# -lt 2 ]; then
                usage "No argument specified along with \"$1\" option."
                exitClean 1
            fi
            local pat='^[+-]?[[:digit:]]+$'
            if [[ ! $2 =~ ${pat} ]]; then
                usage "Bad argument \"$2\", specified along with \"$1\" option."
                exitClean 1
            fi
            if [[ $2 -gt 3 ]]; then
                usage "Bad verbosity level: $2, valid values [0..3]"
                exitClean 1
            fi
            verbosityLevel=$2
            shift;;
        -*)
            usage "Invalid option \"$1\"".
            exitClean 1;;
        "") ;;  # Ignore empty arg or filename
        *)
            # Example of handling non-flag arguments which may be
            # repeated. Gather names (file names in this case) into a
            # colon ":" separated list.
            if [ -z "${filesToProcess}" ]; then
                filesToProcess="$1"
            else
                filesToProcess="${filesToProcess}":"$1"
            fi
            
            ;;
        esac
        shift
    done

    if [ -z "${filesToProcess}" ]; then
        usage "Must specify at least one file to process."
        exitClean 1
    fi
}

# -----------------------------------------------------------
#
# Show the passed message $1 (if a message was specified),
# followed by usage.
#
usage()
{
    # First output any passed message
    if [ $# -gt 0 ]; then stdErr "$@"; fi

    # Extract usage from prolog at top of script and output it. The first
    # "sed" outputs from the first line up to the "# DESCRIPTION" line (to
    # limit how much of the script is parsed, for speed). The second "sed"
    # extracts everything between SYNOPSIS and DESCRIPTION. The third "sed"
    # eliminates the lines which begin with SYNOPSIS, DESCRIPTION, and
    # OPTIONS. The last "sed" strips any '#' off the beginning of each
    # line and eliminates blank lines.
    #
    stdErr "${scriptName} Usage:"
    sed "/^# *DESCRIPTION/q" "$0" | \
        sed -n "/^# *SYNOPSIS/,/^# *DESCRIPTION/p" | \
        sed -e "/^# *SYNOPSIS/d" -e "/^# *DESCRIPTION/d" -e "/^# *OPTIONS/d" | \
        sed -e "s/^#//" -e "/^ *$/d" 1>&2
}

# -----------------------------------------------------------

stdOut()
{
    echo -e "$*"
}

# -----------------------------------------------------------

stdErr()
{
    echo -e "$*" 1>&2
}

# -----------------------------------------------------------

printVersion()
{
    stdOut "${scriptName} v${scriptVersion}"
}

# -----------------------------------------------------------

showConfig()
{
    stdOut "prettyPrint:    ${prettyPrint}"
    stdOut "verbosityLevel: ${verbosityLevel}"
    stdOut "filesToProcess: ${filesToProcess}"
}

# -----------------------------------------------------------
#
# Clean up any resources that were reserved (temporary files, etc),
# then exit with the passed exit status.
#
exitClean()
{
    # Example of making sure a temporary file is deleted
    rm -f "${tmpFile}"

    # Example of checking if a resource was reserved, and if so, freeing it
    if ${resourceReserved}; then
        : # Logic to free resource would replace this line
    fi

    # Exit with passed exit status (if not specified, default to 0)
    exit "${1:-0}"
}

# -----------------------------------------------------------

processFiles()
{
    SAVE_IFS="${IFS}"; IFS=":"
    for f in ${filesToProcess}; do
        processOneFile "${f}"
    done
    IFS="${SAVE_IFS}"
}

# -----------------------------------------------------------

processOneFile()
{
    stdOut "Processing file: \"$1\""
    if ${prettyPrint}; then
        stdOut "Using pretty formatting on file: ${f}"
    fi
}

# -----------------------------------------------------------

# Invoke main body of script. Doest not return. This appears
# at the bottom of the script, so all functions which main()
# calls are visible to main().

main "$@"

# -----------------------------------------------------------
