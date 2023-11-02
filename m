Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC2BC4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 03:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbjKBDhg (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 23:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjKBDhf (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 23:37:35 -0400
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231069F
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 20:37:28 -0700 (PDT)
Date:   Wed, 1 Nov 2023 23:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698896246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RiujPMJ0RtsMAZ4BCy7Zs1aUPsWx9wuJ51DaDKe7dbU=;
        b=mFKr96H4hfarnefs5eRjW2FD0Amn+NIgqQcIMkfJnjLV4guXdmxLT/TZD2WRnUxd+WFRBH
        P2ao7onBhhm4xdD7oLhBz1vuBi1r+FSNOgazWZGxfpQ+lArc/tL2d0gkXHAZyNxg8txBT9
        jL6hwAVzaAjqApM0/NdgDM75yW0/k+k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     janpieter.sollie@kabelmail.de
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: Re: [PATCH v3 04/10] ktest: upgrade to debian trixie channel
Message-ID: <20231102033723.ct53ozcnqe2fdxws@moria.home.lan>
References: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
 <20231030151046.29827-5-janpieter.sollie@kabelmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231030151046.29827-5-janpieter.sollie@kabelmail.de>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Oct 30, 2023 at 03:58:15PM +0100, janpieter.sollie@kabelmail.de wrote:
> From: Janpieter Sollie <janpieter.sollie@edpnet.be>
> 
> Due to bcachefs being mainlined soon (hopefully),
> it's worth considering a more recent update channel,
> which may include bcachefs features in the future.
> 
> Necessary adjustments have been made for the packages,
> but kernel requirements may still need some extra tweaks
> 
> Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
> ---
>  build-test-kernel  |  8 +++-----
>  lib/common.sh      |  8 +++++---
>  lib/libktest.sh    |  2 +-
>  root_image         | 15 ++++++++-------
>  tests/test-libs.sh |  4 ++--
>  5 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/build-test-kernel b/build-test-kernel
> index 9121fd1..38cfd25 100755
> --- a/build-test-kernel
> +++ b/build-test-kernel
> @@ -121,10 +121,8 @@ run_ktest()
>  
>  do_make()
>  {
> -    if [[ -n $CROSS_COMPILE ]]; then
> -	export ARCH="$KERNEL_ARCH"
> -	export CROSS_COMPILE="$ARCH_TRIPLE-"
> -    fi
> +	local ARCH="$KERNEL_ARCH"
> +	local CROSS_COMPILE="$ARCH_TRIPLE-"

!?!?

How does this change have anything to do with what's in the commit
message?

>  
>      make --jobs="$ktest_njobs"			\
>  	--directory="$ktest_kernel_source"    	\
> @@ -192,7 +190,7 @@ build_kernel()
>  
>      log_verbose "kernel_config_require: ${ktest_kernel_config_require[@]}"
>  
> -    MAKEARGS+=("LOCALVERSION=-ktest")
> +    MAKEARGS+=("LOCALVERSION=-ktest" ARCH="$KERNEL_ARCH" CROSS_COMPILE="$ARCH_TRIPLE-")
>  
>      for opt in "${ktest_kernel_config_require[@]}"; do
>  	[[ -n $opt ]] && kernel_opt set "$opt"
> diff --git a/lib/common.sh b/lib/common.sh
> index b94557d..8629e9f 100644
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
> +    [[ $DEBIAN_ARCH == "i386" ]] && [[ "$(uname -m)" == "x86_64" ]] && CROSS_COMPILE=0
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
> index 8ead78b..9e8f4db 100644
> --- a/lib/libktest.sh
> +++ b/lib/libktest.sh
> @@ -309,7 +309,7 @@ start_vm()
>      local qemu_cmd=("$QEMU_BIN" -nodefaults -nographic)
>      local accel=kvm
>      local cputype=host
> -    [[ $(uname -m) == $ktest_arch ]] || accel=tcg && cputype=max
> +    [[ "${CROSS_COMPILE:-0}" == "1" ]] && accel=tcg && cputype=max
>      case $ktest_arch in
>  	x86|x86_64)
>  	    qemu_cmd+=(-cpu $cputype -machine type=q35,accel=$accel,nvdimm=on)
> diff --git a/root_image b/root_image
> index 87add22..5d9c767 100755
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
> @@ -123,10 +124,9 @@ PACKAGES+=("linux-headers-generic")
>  # DKMS needs to cross-compile the module,
>  # against a different kernel on a different CPUarchitecture.
>  # this has to cause errors
> -[ $CROSS_COMPILE == 1 ] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)
> +[ -z ${CROSS_COMPILE:-0} ] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)
> +
>  
> -# suspend testing:
> -# [[ $KERNEL_ARCH = x86 ]] && PACKAGES+=(uswsusp)
>  
>  EXCLUDE=(dmidecode nano rsyslog logrotate cron		\
>      iptables nfacct					\
> @@ -241,6 +241,7 @@ update_packages()
>      chmod 755 "$MNT"/tmp/rustup.sh
>  
>      _chroot "$MNT" /tmp/rustup.sh -y
> +    echo 'export PATH="$HOME/.cargo/bin:$PATH"' > $MNT/etc/profile.d/rustup.sh
>  }
>  
>  trim_image()
> @@ -304,10 +305,10 @@ cmd_create()
>  	--arch="$DEBIAN_ARCH"				\
>  	--exclude=$(join_by , "${EXCLUDE[@]}")		\
>  	--foreign					\
> -	--components='main,contrib,non-free,bullseye-backports' \
> -	bullseye "$MNT" "$MIRROR"
> +	--components='main,contrib,non-free' \
> +	trixie "$MNT" "$MIRROR"
>  
> -    [ ${CROSS_COMPILE} == 1 ] && cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})
> +    [ ${CROSS_COMPILE:-0} == 1 ] && cp $(which qemu-${ktest_arch}) ${MNT}$(which qemu-${ktest_arch})

Another weird [ workaround? Just use [[

>      _chroot "$MNT" /debootstrap/debootstrap --second-stage
>      _chroot "$MNT" dpkg --configure -a
>  
> diff --git a/tests/test-libs.sh b/tests/test-libs.sh
> index 3cacda2..518682c 100644
> --- a/tests/test-libs.sh
> +++ b/tests/test-libs.sh
> @@ -7,9 +7,9 @@
>  . $(dirname $(readlink -e ${BASH_SOURCE[0]}))/prelude.sh
>  . $(dirname $(readlink -e ${BASH_SOURCE[0]}))/kconfig.sh
>  
> -config-mem 4G
> +config-mem 8G
>  
> -(($ktest_cpus > 16)) && ktest_cpus=16
> +(($ktest_cpus > 8)) && ktest_cpus=8

These changes also don't belong in this patch, just drop them
>  
>  # Usage:
>  # setup_tracing tracepoint_glob
> -- 
> 2.42.0
> 
