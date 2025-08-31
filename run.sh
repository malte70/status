#!/usr/bin/env bash

cd $(dirname $0)


SSH_KEY="$HOME/.ssh/id_tinystatus"


do_build() {
	echo " [run.sh]  Generate status page"
	./tinystatus \
		2>/dev/null \
		> status.html
}

do_test() {
	# echo ">>> FEATURE DISABLED <<<" >&2
	# return 9
	
	# Check for requirements
	if ! command -v links 2>&1 >/dev/null; then
		echo " [run.sh]  [test]  Error: Command not found: links"
		return 1
	elif ! command -v po-notify.pyz 2>&1 >/dev/null; then
		echo " [run.sh]  [test]  Error: Command not found: po-notify.pyz"
		return 1
	fi
	
	# do_build || return 2
	
	# echo " [run.sh]  [test]  Create a backup of status.html"
	# cp status.html status.$(date +%Y-%m-%d_%H-%M).html

	echo " [run.sh]  [test]  Send status.html using Pushover"
	(
		echo -e "A plain text version of status.html:\n\n"
		links -dump status.html
	) | \
		sed 's/^[ \t]*//;s/[ \t]*$//g' | \
		env \
			PUSHOVER_PRIORITY=-1 \
			po-notify.pyz \
			"Update for status.rolltreppe3.de"

}

do_upload() {
	do_build || return 1
	
	if [[ ! -s status.html ]]; then
		echo " [run.sh]  Error: status.html has no content" >&2
		return 1
	fi
	
	pushd gh-pages >/dev/null
	
	echo " [run.sh]  Git: Revert changes to gh-pages and pull from origin"
	git restore --staged .
	git clean -f
	git restore .
	git pull
	
	echo " [run.sh]  Copy status.html to gh-pages"
	cp ../status.html index.html
	
	echo " [run.sh]  Git: Commit changes to index.html in gh-pages"
	git add index.html
	if git diff --cached --exit-code >/dev/null; then
		# Only run git commit if changes to index.html where made
		git commit --quiet -m "status page updated."
	# else
	# 	# DEBUG
	# 	echo "git diff --cached --exit-code \!= 0" \
	# 		~/bin/po-notify.pyz "status :: run.sh"
	# 	git commit --quiet -m "status page updated."
	fi
	
	echo " [run.sh]  Git: Push gh-pages branch"
	env \
		GIT_SSH_COMMAND="ssh -i ${SSH_KEY}" \
		git push --quiet
	
	popd >/dev/null
}


if [[ "$1" == "--help" || "$1" == "-h" || "$1" == "help" ]]; then
	echo "status.rolltreppe3.de :: run.sh"
	echo "Usage:"
	echo -e "\t./run.sh [build|upload|test|help]"
	exit 0
fi

case "$1" in
	""|"build")
		do_build
		;;
	"test")
		do_build
		do_test
		;;
	"upload")
		#[ -f ~/tinystatus.lock ] 
		printf "PID=$$\nPWD=$PWD\nargv0=$0\nARGS=$@\n" > ~/tinystatus.lock
		do_upload
		rm -f ~/tinystatus.lock
		;;
	*)
		echo "Error: Unknown action \"$1\"" >&2
		exit 1
		;;
esac


