Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BFCC4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 03:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjKBDfD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 23:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbjKBDfB (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 23:35:01 -0400
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [IPv6:2001:41d0:203:375::af])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D693BD7
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 20:34:53 -0700 (PDT)
Date:   Wed, 1 Nov 2023 23:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698896092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m+s54p7hnGuket/W7aZgpE59zkKEmKuT57DL8xlDOA4=;
        b=C+Ya2v71cxCef5wk6SsbS7txBaMhPUN4wAOF1UVisMKRb/sm40WmGJqAQr+B46XHv3hx9v
        QQCKXh7PeGfjInM/s05LfXGUTj560xMpq+NYQddX9fOuO9ohik0xPKjH56YWonqWqXOOYY
        E4Wjn7ffQ+sDjfjTJotGvaabAfOL23E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     janpieter.sollie@kabelmail.de
Cc:     linux-bcachefs@vger.kernel.org,
        Janpieter Sollie <janpieter.sollie@edpnet.be>
Subject: Re: [PATCH v3 03/10] ktest-bcachefs: run tests on emulated
 architectures
Message-ID: <20231102033449.rnttij34c4c5nquy@moria.home.lan>
References: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
 <20231030151046.29827-4-janpieter.sollie@kabelmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231030151046.29827-4-janpieter.sollie@kabelmail.de>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Oct 30, 2023 at 03:58:14PM +0100, janpieter.sollie@kabelmail.de wrote:
> From: Janpieter Sollie <janpieter.sollie@edpnet.be>
> 
> Allow the tests to run on a non-ABI-compatible cpu,
> verify code when the architecture isn't physically available.
> in the future, bcachefs-tools should be cross-compiled,
> and the list of CPU types should be expanded
> 
> Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
> ---
>  build-test-kernel |  2 +-
>  lib/common.sh     | 11 ++++++++---
>  lib/libktest.sh   |  8 ++++++--
>  lib/testrunner    | 10 +++++++++-
>  root_image        |  8 +++++++-
>  tests/kconfig.sh  |  2 ++
>  6 files changed, 33 insertions(+), 8 deletions(-)
> 
> diff --git a/build-test-kernel b/build-test-kernel
> index 72990ba..9121fd1 100755
> --- a/build-test-kernel
> +++ b/build-test-kernel
> @@ -107,7 +107,7 @@ ktest_kernel_source=$(readlink -e "$ktest_kernel_source")
>  ktest_kernel_build="$ktest_out/kernel_build.$ktest_arch"
>  mkdir -p "$ktest_kernel_build"
>  
> -if [[ -n $CROSS_COMPILE ]]; then
> +if [[ -z ${CROSS_COMPILE:+x} ]]; then

???

This looks like a workaround for test, i.e. [ - [[ behaves better.

> diff --git a/lib/testrunner b/lib/testrunner
> index acbc45f..a8e8d17 100755
> --- a/lib/testrunner
> +++ b/lib/testrunner
> @@ -20,6 +20,10 @@ ktest_out="/host/$ktest_out"
>  ln -sf $ktest_dir /ktest
>  ln -sf $ktest_out /ktest-out
>  
> +. /ktest/lib/common.sh
> +
> +parse_arch $(uname -m)
> +
>  # Some home directories are in weird places:
>  mkdir -p $(dirname $home)
>  ln -sf /host/$home $home
> @@ -92,7 +96,11 @@ for i in "${ktest_make_install[@]}"; do
>      if [[ -f configure && ! -f Makefile ]]; then
>  	run_quiet "configure $(basename $i)" ./configure
>      fi
> -    run_quiet "building $(basename $i)" make -j $ktest_cpus
> +    #this won't make me popular - compiling bcachefs tools with rust support on a emulated machine is too heavy to be useful, so omit it:
> +    rustcompile="" && [[ "$(systemd-detect-virt)" == "qemu" ]] && rustcompile="NO_RUST=1"
> +    #bcachefs tools sometimes seems to use compiled files from previous runs, even if other architecture, so clean out:
> +    [ "bcachefs-tools" == "$(basename $i)" ] && [ "$(objdump -f bcachefs.o | grep architecture | cut -d' ' -f 2)" == "$(objdump -f /bin/bash | grep architecture | cut -d' ' -f 2)" ] || make clean
> +    run_quiet "building $(basename $i)" make $rustcompile -j $ktest_cpus
>      run_quiet "installing $(basename $i)" make -j $ktest_cpus install
>      popd > /dev/null

Nope, don't put bcachefs-tools specific stuff in testrunner.

>  done
> diff --git a/root_image b/root_image
> index 26c99fe..87add22 100755
> --- a/root_image
> +++ b/root_image
> @@ -118,7 +118,12 @@ PACKAGES+=(cryptsetup)
>  PACKAGES+=(multipath-tools sg3-utils srptools)
>  
>  # ZFS support
> -PACKAGES+=("linux-headers-generic" dkms zfsutils-linux zfs-dkms)
> +PACKAGES+=("linux-headers-generic")
> +# unless no other option when cross-compiling, ignore ZFS
> +# DKMS needs to cross-compile the module,
> +# against a different kernel on a different CPUarchitecture.
> +# this has to cause errors
> +[ $CROSS_COMPILE == 1 ] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)

CROSS_COMPILE isn't for root_image - not sure what you're trying to do
here.
