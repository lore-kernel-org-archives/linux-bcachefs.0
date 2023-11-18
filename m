Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JHoJLcY7"
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [IPv6:2001:41d0:203:375::ba])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345CE192
	for <linux-bcachefs@vger.kernel.org>; Sat, 18 Nov 2023 12:10:57 -0800 (PST)
Date: Sat, 18 Nov 2023 15:10:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700338255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8X1epWaJycDC6LeQV9c8UKa3feRXYlvcSusjCzAd3Xw=;
	b=JHoJLcY79lVs4RrlCT92WfzKL1D98nWUIA5CMfwQkV2LbrF63hBot2WxsGBoZzwXOuvmVE
	Qwxfhnr6ctpPKxFDJjfbN8zKFSRso3jFtOjs7MEF3OeBkKrkvOIYna+BxKU3SSn89jLRcm
	4UvOuyEWwXvqVlPwp6Bdk5wO8siCT9g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Janpieter Sollie <janpieter.sollie@edpnet.be>
Cc: linux-bcachefs@vger.kernel.org,
	Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: Re: [PATCH v4 03/10] ktest: upgrade to debian trixie channel
Message-ID: <20231118201053.7r627yjgvv6zh7pl@moria.home.lan>
References: <20231118194453.41324-1-janpieter.sollie@kabelmail.de>
 <20231118194453.41324-4-janpieter.sollie@kabelmail.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231118194453.41324-4-janpieter.sollie@kabelmail.de>
X-Migadu-Flow: FLOW_OUT

On Sat, Nov 18, 2023 at 08:38:42PM +0100, Janpieter Sollie wrote:
> Due to bcachefs being mainlined,
> it's worth considering a more recent update channel,
> which may include bcachefs features in the future.
> 
> Necessary adjustments have been made for the packages,
> but kernel requirements may still need some extra tweaks
> 
> Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
> ---
>  lib/common.sh      |  8 +++++---
>  lib/libktest.sh    |  2 +-
>  root_image         | 12 +++++++-----
>  tests/test-libs.sh |  2 +-
>  4 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/lib/common.sh b/lib/common.sh
> index b94557d..353bb36 100644
> --- a/lib/common.sh
> +++ b/lib/common.sh
> @@ -83,7 +83,7 @@ join_by()
>  parse_arch()
>  {
>      case $1 in
> -	x86|i386)
> +	x86|i386|i686)
>  	    ktest_arch=x86
>  	    DEBIAN_ARCH=i386
>  	    ARCH_TRIPLE=${ARCH_TRIPLE_X86}
> @@ -92,7 +92,7 @@ parse_arch()
>  	    BITS=32
>  
>  	    QEMU_PACKAGE=qemu-system-x86
> -	    QEMU_BIN=qemu-system-x86_64
> +	    QEMU_BIN=qemu-system-i386
>  	    ;;
>  	x86_64|amd64)
>  	    ktest_arch=x86_64
> @@ -188,7 +188,8 @@ parse_arch()
>      if [[ $ktest_arch != $(uname -m) ]]; then
>  	CROSS_COMPILE=1
>      fi
> -
> +    #special case: x86_64 is able to run i386 code.  this isn't always the case for armv8 -> armv7 (cortex A35)
> +    [[ $DEBIAN_ARCH == "i386" && "$(uname -m)" == "x86_64" ]] && unset CROSS_COMPILE
>      export DEBIAN_ARCH
>      export MIRROR
>      export ARCH_TRIPLE
> @@ -196,6 +197,7 @@ parse_arch()
>      export QEMU_PACKAGE
>      export QEMU_BIN
>      export ktest_arch
> +    export BITS
>  }
>  
>  find_command() {
> diff --git a/lib/libktest.sh b/lib/libktest.sh
> index 8ead78b..0b2704b 100644
> --- a/lib/libktest.sh
> +++ b/lib/libktest.sh
> @@ -309,7 +309,7 @@ start_vm()
>      local qemu_cmd=("$QEMU_BIN" -nodefaults -nographic)
>      local accel=kvm
>      local cputype=host
> -    [[ $(uname -m) == $ktest_arch ]] || accel=tcg && cputype=max
> +    [[ ${CROSS_COMPILE+x} ]] && accel=tcg && cputype=max
>      case $ktest_arch in
>  	x86|x86_64)
>  	    qemu_cmd+=(-cpu $cputype -machine type=q35,accel=$accel,nvdimm=on)
> diff --git a/root_image b/root_image
> index a881714..e36a4f1 100755
> --- a/root_image
> +++ b/root_image
> @@ -45,6 +45,7 @@ if [[ $# = 0 ]]; then
>  fi
>  
>  ktest_image=""
> +ktest_arch="$(uname -m)"
>  CMD="cmd_$1"
>  shift
>  
> @@ -100,7 +101,7 @@ PACKAGES+=(libudev-dev libldap2-dev)
>  PACKAGES+=(acct bsdextrautils xfsprogs xfslibs-dev quota libcap2-bin)
>  PACKAGES+=(libattr1-dev libaio-dev libgdbm-dev libacl1-dev gettext)
>  PACKAGES+=(libssl-dev libgdbm-dev libgdbm-compat-dev liburing-dev)
> -PACKAGES+=(duperemove thin-provisioning-tools fsverity)
> +PACKAGES+=(duperemove fsverity)
>  
>  # xfsprogs:
>  PACKAGES+=(libinih-dev)
> @@ -123,7 +124,7 @@ PACKAGES+=("linux-headers-generic")
>  # DKMS needs to cross-compile the module,
>  # against a different kernel on a different CPUarchitecture.
>  # this has to cause errors
> -[[ -n $CROSS_COMPILE ] && PACKAGES+=(dkms zfsutils-linux zfs-dkms)
> +[[ ${CROSS_COMPILE+x} ]] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)

Delete this change

>  
>  # suspend testing:
>  # [[ $KERNEL_ARCH = x86 ]] && PACKAGES+=(uswsusp)
> @@ -241,6 +242,7 @@ update_packages()
>      chmod 755 "$MNT"/tmp/rustup.sh
>  
>      _chroot "$MNT" /tmp/rustup.sh -y
> +    echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
>  }
>  
>  trim_image()
> @@ -304,10 +306,10 @@ cmd_create()
>  	--arch="$DEBIAN_ARCH"				\
>  	--exclude=$(join_by , "${EXCLUDE[@]}")		\
>  	--foreign					\
> -	--components='main,contrib,non-free,bullseye-backports' \
> -	bullseye "$MNT" "$MIRROR"
> +	--components='main,contrib,non-free' \
> +	trixie "$MNT" "$MIRROR"
>  
> -    [[ -n ${CROSS_COMPILE} ]] || cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})
> +    [[ ${CROSS_COMPILE+x} ]] && cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})

Stop changing these if statements - we don't need workarounds for the
test command when we're using [[.

>      _chroot "$MNT" /debootstrap/debootstrap --second-stage
>      _chroot "$MNT" dpkg --configure -a
>  
> diff --git a/tests/test-libs.sh b/tests/test-libs.sh
> index 3cacda2..d172e4c 100644
> --- a/tests/test-libs.sh
> +++ b/tests/test-libs.sh
> @@ -7,7 +7,7 @@
>  . $(dirname $(readlink -e ${BASH_SOURCE[0]}))/prelude.sh
>  . $(dirname $(readlink -e ${BASH_SOURCE[0]}))/kconfig.sh
>  
> -config-mem 4G
> +config-mem 8G
>  
>  (($ktest_cpus > 16)) && ktest_cpus=16
>  
> -- 
> 2.42.1
> 
