{ config, pkgs, ... }:

let
	username = config.username;
	group = config.users.users.${username}.group or "users";
	home = config.users.users.${username}.home;
in {
	system.activationScripts.ssh = ''
		# no rm for keeping credentials, adding -p
		mkdir -p ${home}/.ssh/known_hosts.d
		chown ${username}:${group} ${home}/.ssh
		chmod 700 ${home}/.ssh -R

		cp ${./config} ${home}/.ssh/config
		chown ${username}:${group} ${home}/.ssh/config
		chmod 600 ${home}/.ssh/config

		cp ${./allowed_signers} ${home}/.ssh/allowed_signers
		chown ${username}:${group} ${home}/.ssh/allowed_signers
		chmod 600 ${home}/.ssh/allowed_signers
	'';

	environment.systemPackages = with pkgs; [
		openssh
	];

	# Enable the OpenSSH daemon.
	services.openssh = {
		enable = true;
	#   ports = 22;
		allowSFTP = true;
		settings = {
		PermitRootLogin = "yes" ;
		PasswordAuthentication = true;
		};
	};

	#services.openssh.enable = true;
	
	
}
