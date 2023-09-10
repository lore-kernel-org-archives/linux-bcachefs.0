Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF1EEE14C3
	for <linux-bcachefs@archiver.kernel.org>; Sun, 10 Sep 2023 01:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343515AbjIJBxz (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 9 Sep 2023 21:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbjIJBxz (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 9 Sep 2023 21:53:55 -0400
Received: from out-217.mta0.migadu.com (out-217.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D7C1BF
        for <linux-bcachefs@vger.kernel.org>; Sat,  9 Sep 2023 18:53:49 -0700 (PDT)
Date:   Sat, 9 Sep 2023 21:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694310827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CTKMGHglGWnqLJlltIpZGYu3O/B3I66UK+t/dbDjpv4=;
        b=dzRaLzFSIwSi0z2J4d6XipE8K6nIixUIwalo0uWA7CUUPdapTKLUtlfNwSb6oVos3Gg/5X
        UGhBUo4p1Qb0ixHd2mapjsHkSaBg6dV8oxmHO/rEv5S94LDUTzeEVkVbBmeCNRTMbXgchw
        +bPdPeuYevFw3Q9KDl0NmvCpXbnGQlQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Gabriel de Perthuis <g2p.code@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: UBSAN: index X is out of range for type 'btree_iter_set [4]'
Message-ID: <20230910015343.jmj4v2arenuxd25r@moria.home.lan>
References: <CAFEugPc5Qyvdd69NaQKYOyyaSD-0XcUjAg4FBP8z1=7RV6oOAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEugPc5Qyvdd69NaQKYOyyaSD-0XcUjAg4FBP8z1=7RV6oOAQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Sep 07, 2023 at 02:51:38PM +0200, Gabriel de Perthuis wrote:
> Hello,
> UBSAN reports some errors with bcachefs; it would be worthwhile to
> enable it in the ktest CI.
> I have UBSAN enabled because I started out from an Ubuntu kernel config:
> grep UBSAN .config
> CONFIG_ARCH_HAS_UBSAN_SANITIZE
> _ALL=y
> CONFIG_UBSAN=y
> # CONFIG_UBSAN_TRAP is not set
> CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
> CONFIG_UBSAN_BOUNDS=y
> CONFIG_UBSAN_BOUNDS_STRICT=y
> CONFIG_UBSAN_SHIFT=y
> # CONFIG_UBSAN_DIV_ZERO is not set
> CONFIG_UBSAN_BOOL=y
> CONFIG_UBSAN_ENUM=y
> # CONFIG_UBSAN_ALIGNMENT is not set
> CONFIG_UBSAN_SANITIZE_ALL=y
> # CONFIG_TEST_UBSAN is not set
> 
> Currently it reports the following:
> (bcachefs master (d0fb567ff8e045149050a1e8f6646fa9c61dab7a) + linux 6.5.1)
> 
> journalctl -k --grep UBSAN -ojson --output-fields=MESSAGE |jq -r .MESSAGE |uniq
> UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1098:3
> UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1207:3
> UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1152:4
> UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1150:4
> UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:291:4
> UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:281:4
> UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:291:4
> UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:36:18
> UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:281:4
> UBSAN: array-index-out-of-bounds in drivers/md/bcache/extents.c:301:5
> UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.h:29:13
> UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:25:47
> UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:25:30
> UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:27:3
> UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:25:47
> UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:27:3
> UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:25:30
> UBSAN: array-index-out-of-bounds in fs/bcachefs/bkey_sort.c:27:3
> 
> This started happening earlier, I have one boot based on 6.5.0
> (bcachefs master 493c276ead0e516ff3eca8d13b820d31afd62524) reporting
> similar errors, whereas the one based on 6.4 (bcachefs master
> 117cd823d2d77dd8db1ec35b5819e1668c736b31 merged with stable 6.4.12)
> didn't.
> 
> The errors are of the form (indices vary)
> index 44 is out of range for type 'sort_iter_set [4]'
> index 4 is out of range for type 'btree_iter_set [4]'
> 
> Uploaded a fuller log:
> journalctl -k -ojson --output-fields=MESSAGE |jq -r .MESSAGE |grep -B1
> -A100 UBSAN |grep -v '^Hardware name:' \
>   |awk '/UBSAN: array-index-out-of-bounds/,/=========/' >
> bcachefs-6.5.1.ubsan.errors
> 
> https://pb.envs.net/?399630cde0c62c76#4zUPPizf68bXGVoyxedZawKGVswrX4JaoeTJ5shKLvfJ

These should be fixed in master now.
