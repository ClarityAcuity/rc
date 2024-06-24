# Careful about copy/pasting, Makefiles want tabs!
.PHONY:	update
update:
	home-manager	switch	--flake	.#villager

.PHONY:	clean
clean:
	nix-collect-garbage	-d