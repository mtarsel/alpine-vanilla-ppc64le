profile_razor() {
	title="Razor"
	desc="Standard build with Ruby Facter
		Network connection is required."
	profile_standard
	image_ext="iso"
	arch="x86 x86_64 ppc64le"
	output_format="iso"
	kernel_cmdline="nomodeset"
	kernel_addons="xtables-addons"
	apks="$apks
		bkeymaps alpine-base alpine-mirrors network-extras openssl openssh
		chrony tzdata ruby ruby-rake ruby-bundler net-tools
	"
	apkovl="genapkovl-razor.sh"
}
