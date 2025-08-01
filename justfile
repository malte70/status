# 
#   _____________________________
#  / justfile for malte70/status \
#  |                             |
#  | - generate the status page  |
#  \ - Upload to GitHub Pages    /
#   -----------------------------
#         \   ,__,
#          \  (oo)____
#             (__)    )\
#                ||--|| *
# 

set ignore-comments

#SSH_KEY := home_dir() / ".ssh/id_tinystatus"
SSH_KEY := "~/.ssh/id_tinystatus"


_default:
	@#"{{ just_executable() }}" --choose

# List available commands
list:
	@"{{ just_executable() }}" --list --list-prefix=$'\tjust ' --list-heading=$'justfile Tasks for tinystatus:\n\n'

[private]
alias l := list

# Generate the status page
build:
	@echo " [just]  Generate status page"
	./tinystatus > status.html

[private]
alias b := build

# Upload using GitHub pages
upload: build
	@echo " [just]  Copy status.html to gh-pages"
	cp status.html gh-pages/index.html
	
	@echo " [just]  Git: Commit changes to index.html in gh-pages"
	cd gh-pages \
		&& git add index.html \
		&& git diff --cached --exit-code >/dev/null \
		&& git commit -m "status page updated." || true

	@echo " [just]  Git: Push gh-pages branch"
	cd gh-pages \
		&& GIT_SSH_COMMAND='ssh -i {{ SSH_KEY }}' git push

[private]
alias u := upload

