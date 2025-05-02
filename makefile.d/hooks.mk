hooks: FORCE .git/hooks/post-commit .git/hooks/post-merge

.git/hooks/post-commit .git/hooks/post-merge: /etc/slashfiles/git-hooks/pull-merged-lineageo
	mkdir -p $(dir $@)
	ln -sf $< $@
