Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B3EEE0217
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 02:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbjINC1C (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Sep 2023 22:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbjINC1B (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Sep 2023 22:27:01 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99572196
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 19:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1694658416;
        bh=xlSTiurgLaBQNpc+vQK3oWsZWhS8BblwTkgUV7ZsG1g=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lKq8i0OoDT58sd0z3lTD7epUzKU/LoG7/siGug5Tqo0G5Z6+MGn+ydajR/7DNZM5h
         xCXjwMW9w0za5cN9EkyJfMdFRTKNyXKTYxLwOJJx5ZDjpwlgjw/fSi3dkKTrvJR/44
         Y38/MtamXO43LySywo5AdmKkc5sboDpfJucvrCnEDbUOY1nf19du9628bTKkf9SKt7
         fEkV3uuIa8r3QMxslPdjZLR4kYtZe73zC/DzWsTvwqetMBSnAWBNHy9i8TDjV595XF
         OOSF2hm23VWE6buknC6WSbc3un6yoXRDK6y3c/a/Zuye0e5bWr4FTjd3F23BQh05rN
         e4UWz4t/JKf9w==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RmLmw2mRxz4wxg;
        Thu, 14 Sep 2023 12:26:56 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: Export kvm_guest static key, for bcachefs six
 locks
In-Reply-To: <20230914000115.1035594-1-kent.overstreet@linux.dev>
References: <20230914000115.1035594-1-kent.overstreet@linux.dev>
Date:   Thu, 14 Sep 2023 12:26:53 +1000
Message-ID: <87a5tp8p76.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Kent Overstreet <kent.overstreet@linux.dev> writes:
> bcachefs's six locks need kvm_guest, via
>  ower_on_cpu() ->  vcpu_is_preempted() -> is_kvm_guest()
>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/powerpc/kernel/firmware.c | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

I'm happy for you to take this via your tree.

cheers

> diff --git a/arch/powerpc/kernel/firmware.c b/arch/powerpc/kernel/firmware.c
> index 20328f72f9f2..8987eee33dc8 100644
> --- a/arch/powerpc/kernel/firmware.c
> +++ b/arch/powerpc/kernel/firmware.c
> @@ -23,6 +23,8 @@ EXPORT_SYMBOL_GPL(powerpc_firmware_features);
>  
>  #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_KVM_GUEST)
>  DEFINE_STATIC_KEY_FALSE(kvm_guest);
> +EXPORT_SYMBOL_GPL(kvm_guest);
> +
>  int __init check_kvm_guest(void)
>  {
>  	struct device_node *hyper_node;
> -- 
> 2.40.1
