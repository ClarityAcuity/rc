# Careful about copy/pasting, Makefiles want tabs!
.PHONY:	update
update:
	home-manager switch --flake .#villager

.PHONY:	upgrade
upgrade:
	nix flake update
	home-manager switch --flake .#villager

.PHONY:	backup
backup:
	home-manager switch --flake .#villager -b backup

.PHONY:	clean
clean:
	nix-collect-garbage	-d