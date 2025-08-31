#!/usr/bin/env bash

cd $(dirname $0)


SSH_KEY="$HOME/.ssh/id_tinystatus"


do_build() {
	echo " [run.sh]  Generate status page"
	./tinystatus > status.html
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
	#cp status.html gh-pages/index.html
	cp ../status.html index.html
	
	echo " [run.sh]  Git: Commit changes to index.html in gh-pages"
	git add index.html
	if git diff --cached --exit-code >/dev/null; then
		# Only run git commit if changes to index.html where made
		git commit -m "status page updated."
	fi
	
	echo " [run.sh]  Git: Push gh-pages branch"
	env \
		GIT_SSH_COMMAND="ssh -i ${SSH_KEY}" \
		git push
	
	popd >/dev/null
}


if [[ "$1" == "--help" || "$1" == "-h" || "$1" == "help" ]]; then
	echo "status.rolltreppe3.de :: run.sh"
	echo "Usage:"
	echo -e "\t./run.sh [build|upload|help]"
	exit 0
fi

if [[ "$#" -eq 0 ]]; then
	echo "Startibg default action ..."
	do_upload
fi

case "$1" in
	build)
		do_build
		;;
	upload)
		do_upload
		;;
	*)
		echo "Error: Unknown action \"$1\"" >&2
		exit 1
		;;
esac


