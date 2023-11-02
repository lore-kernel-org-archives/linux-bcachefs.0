Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE2FC4332F
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 07:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbjKBH4t (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Nov 2023 03:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjKBH4s (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Nov 2023 03:56:48 -0400
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86959102
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Nov 2023 00:56:41 -0700 (PDT)
X-ASG-Debug-ID: 1698911797-24639c0564e7590001-qsCQDO
Received: from LXmail01.edpnet.net (lxmail01.edpnet.net [212.71.0.135]) by relay-b03.edpnet.be with ESMTP id jJxCLExYvoFxn5KG (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO); Thu, 02 Nov 2023 08:56:37 +0100 (CET)
X-Barracuda-Envelope-From: janpieter.sollie@edpnet.be
X-Barracuda-Effective-Source-IP: lxmail01.edpnet.net[212.71.0.135]
X-Barracuda-Apparent-Source-IP: 212.71.0.135
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=edpnet.be; s=default;
        t=1698911797; bh=R/2XZ6N8wxks8DTyiOLy8L4LBPmfS/ma3dWxJvaNta4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=FXhpA+W6MM/NXkAwYwYB3MJwhsACu4/5IECYyH74K+Cg6wu8c6y061x5p/iE24Prd
         IVAZ5N0hUPPNUFtMaPA+1UeCUN+EqeVKfCXn2Bf+zviugcxWzhnYevJsDdpjRf3hM+
         k3+d8f0VOoZzRBMP5+3AxnC1TS/JFeiZZiA05fN4=
Received: from webmail.edpnet.be (unknown [212.71.0.141])
        (Authenticated sender: janpietersol1.m1@edpnet.org)
        by LXmail01.edpnet.net (Postfix) with ESMTPA id 4SLbmj0zvgz11NP;
        Thu,  2 Nov 2023 08:56:37 +0100 (CET)
MIME-Version: 1.0
Date:   Thu, 02 Nov 2023 08:56:36 +0100
From:   janpieter.sollie@edpnet.be
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     janpieter.sollie@kabelmail.de, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v3 03/10] ktest-bcachefs: run tests on emulated
 architectures
In-Reply-To: <20231102033449.rnttij34c4c5nquy@moria.home.lan>
X-ASG-Orig-Subj: Re: [PATCH v3 03/10] ktest-bcachefs: run tests on emulated
 architectures
References: <20231030151046.29827-1-janpieter.sollie@kabelmail.de>
 <20231030151046.29827-4-janpieter.sollie@kabelmail.de>
 <20231102033449.rnttij34c4c5nquy@moria.home.lan>
User-Agent: edpnet Webmail/1.6.3
Message-ID: <8260932dc270bbb6073a5af5b58a37cc@edpnet.be>
X-Sender: janpieter.sollie@edpnet.be
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: lxmail01.edpnet.net[212.71.0.135]
X-Barracuda-Start-Time: 1698911797
X-Barracuda-Encrypted: TLS_AES_256_GCM_SHA384
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 3992
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=NO_REAL_NAME
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.116199
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
        0.00 NO_REAL_NAME           From: does not include a real name
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 2023-11-02 04:34, Kent Overstreet wrote:

> On Mon, Oct 30, 2023 at 03:58:14PM +0100, janpieter.sollie@kabelmail.de 
> wrote:
> 
>> From: Janpieter Sollie <janpieter.sollie@edpnet.be>
>> 
>> Allow the tests to run on a non-ABI-compatible cpu,
>> verify code when the architecture isn't physically available.
>> in the future, bcachefs-tools should be cross-compiled,
>> and the list of CPU types should be expanded
>> 
>> Signed-off-by: jpsollie <janpieter.sollie@edpnet.be>
>> ---
>> build-test-kernel |  2 +-
>> lib/common.sh     | 11 ++++++++---
>> lib/libktest.sh   |  8 ++++++--
>> lib/testrunner    | 10 +++++++++-
>> root_image        |  8 +++++++-
>> tests/kconfig.sh  |  2 ++
>> 6 files changed, 33 insertions(+), 8 deletions(-)
>> 
>> diff --git a/build-test-kernel b/build-test-kernel
>> index 72990ba..9121fd1 100755
>> --- a/build-test-kernel
>> +++ b/build-test-kernel
>> @@ -107,7 +107,7 @@ ktest_kernel_source=$(readlink -e 
>> "$ktest_kernel_source")
>> ktest_kernel_build="$ktest_out/kernel_build.$ktest_arch"
>> mkdir -p "$ktest_kernel_build"
>> 
>> -if [[ -n $CROSS_COMPILE ]]; then
>> +if [[ -z ${CROSS_COMPILE:+x} ]]; then
> 
> ???
> 
> This looks like a workaround for test, i.e. [ - [[ behaves better.


Ah, missed that, thx

> 
>> diff --git a/lib/testrunner b/lib/testrunner
>> index acbc45f..a8e8d17 100755
>> --- a/lib/testrunner
>> +++ b/lib/testrunner
>> @@ -20,6 +20,10 @@ ktest_out="/host/$ktest_out"
>> ln -sf $ktest_dir /ktest
>> ln -sf $ktest_out /ktest-out
>> 
>> +. /ktest/lib/common.sh
>> +
>> +parse_arch $(uname -m)
>> +
>> # Some home directories are in weird places:
>> mkdir -p $(dirname $home)
>> ln -sf /host/$home $home
>> @@ -92,7 +96,11 @@ for i in "${ktest_make_install[@]}"; do
>> if [[ -f configure && ! -f Makefile ]]; then
>> run_quiet "configure $(basename $i)" ./configure
>> fi
>> -    run_quiet "building $(basename $i)" make -j $ktest_cpus
>> +    #this won't make me popular - compiling bcachefs tools with rust 
>> support on a emulated machine is too heavy to be useful, so omit it:
>> +    rustcompile="" && [[ "$(systemd-detect-virt)" == "qemu" ]] && 
>> rustcompile="NO_RUST=1"
>> +    #bcachefs tools sometimes seems to use compiled files from 
>> previous runs, even if other architecture, so clean out:
>> +    [ "bcachefs-tools" == "$(basename $i)" ] && [ "$(objdump -f 
>> bcachefs.o | grep architecture | cut -d' ' -f 2)" == "$(objdump -f 
>> /bin/bash | grep architecture | cut -d' ' -f 2)" ] || make clean
>> +    run_quiet "building $(basename $i)" make $rustcompile -j 
>> $ktest_cpus
>> run_quiet "installing $(basename $i)" make -j $ktest_cpus install
>> popd > /dev/null
> 
> Nope, don't put bcachefs-tools specific stuff in testrunner.
> 

This may not be needed anymore, but bcachefs-tools tended to accept code 
compiled for another target.
In meantime, the needed functionality can be made using the mount via 
fuse2fs to verify the target architecture - so I'll rewrite it that way.

>> done
>> diff --git a/root_image b/root_image
>> index 26c99fe..87add22 100755
>> --- a/root_image
>> +++ b/root_image
>> @@ -118,7 +118,12 @@ PACKAGES+=(cryptsetup)
>> PACKAGES+=(multipath-tools sg3-utils srptools)
>> 
>> # ZFS support
>> -PACKAGES+=("linux-headers-generic" dkms zfsutils-linux zfs-dkms)
>> +PACKAGES+=("linux-headers-generic")
>> +# unless no other option when cross-compiling, ignore ZFS
>> +# DKMS needs to cross-compile the module,
>> +# against a different kernel on a different CPUarchitecture.
>> +# this has to cause errors
>> +[ $CROSS_COMPILE == 1 ] || PACKAGES+=(dkms zfsutils-linux zfs-dkms)
> 
> CROSS_COMPILE isn't for root_image - not sure what you're trying to do
> here.

omit ZFS: during install, the ZFS installer compiles the modules for the 
running kernel.
This is the kernel installed on the host, as the installer runs in qemu 
user.

Kind regards,

Janpieter Sollie
