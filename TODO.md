# malte70's Tinystatus TODO

- [x] Add a justfile for common tasks
- [x] Skip upload if `status.html` is empty
- [ ] Make sure pushing to GitHub does not fail:
   - No newer commits in origin
   - Ignore merge conflicts by force-pulling from origin
     before adding `status.html`
- Webpage design improvements:
   - [ ] Sort services in alphabetical order
   - [ ] Add a favicon
- [ ] Replace `README.md` with one describing only the
      changes I made, and referencing the upstream one
- [ ] Move configuration inside `tinystatus` to a separate file (maybe .env?)
- [ ] Automatic configuration deployment
   - Change `.env`, `checks.csv` & `incidents.txt` without direct access to the system running the Cronjob
   - Stored in a new git branch
   - Download from the GitHub website and overwrite previous files

