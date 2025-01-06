#!/usr/bin/env bash
#
# FILE
#     prolog.bash - briefly describe application of script
#
# SYNOPSIS
#     ${FG_YELLOW}prolog.bash${CLEAR} [options...] \<file\> ...
#
# OPTIONS
#     \\t${FG_YELLOW}-h, --help              ${FG_MAGENTA}show this help
#     \\t${FG_YELLOW}-v, --version           ${FG_MAGENTA}display version and exit
#     \\t${FG_YELLOW}-p, --pretty-print      ${FG_MAGENTA}set pretty printing
#     \\t${FG_YELLOW}-V, --verbose \<level\> ${FG_MAGENTA}set verbosity to \<level\>${CLEAR}
#
# DESCRIPTION
#     If there is a man page for the script, a reference can
#     be made to the man page. Otherwise, describe the application
#     of the script here.
#
# -----------------------------------------------------------

source "${KSL_BASH_LIB}"/libColors.bash

# -----------------------------------------------------------

main()
{
    usage
}

# -----------------------------------------------------------

usage()
{
    # Extract usage from prologue at top of script and output it. The
    # first "sed" outputs from the first line up to the "# DESCRIPTION"
    # line (to limit how much of the script is parsed). The second "sed"
    # extracts everything between SYNOPSIS and DESCRIPTION. The third
    # "sed" eliminates the lines which begin with SYNOPSIS, DESCRIPTION,
    # and OPTIONS. The last "sed" strips any '#' off the beginning of
    # each line and eliminates blank lines.

    while IFS= read -r line; do
        eval echo -e ${line}
    done < <(sed "/^# *DESCRIPTION/q" "$0" |
             sed -n "/^# *SYNOPSIS/,/^# *DESCRIPTION/p" |
             sed -e "/^# *SYNOPSIS/d" -e "/^# *DESCRIPTION/d" -e "/^# *OPTIONS/d" |
             sed -e "s/^# //" -e "s/^#/ /" -e "/^ *$/d"
            )
}

# -----------------------------------------------------------

main "$@"

# -----------------------------------------------------------
