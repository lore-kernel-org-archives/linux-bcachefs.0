Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C67C7618E
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 18:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjDZSqu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 14:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234635AbjDZSqr (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 14:46:47 -0400
Received: from out-35.mta1.migadu.com (out-35.mta1.migadu.com [IPv6:2001:41d0:203:375::23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B2B9009
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 11:46:21 -0700 (PDT)
Date:   Wed, 26 Apr 2023 14:46:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682534777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eALC2BWpJlAyZfrfdu0p+l794nS0hnu07ZoyRd9dHEc=;
        b=DxnJ9pP1HOh7vukWJzkBlWNziHlzePR0ka1lCjDTcTvoOKYmeAGiM9EHEsETogmqVPJSBp
        UdwluOLl+psYAsL3sLoGxUEfmENh430gCjl2Tg4mO+qrLtuy52/LnLn0VZhA6XzDZMYCE5
        uMVWdqM1PKKRvRcDZgygx7ZB1Q7djaM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] feat(cmd_mount): Add support for magic keyword
 `OLD_BLKID_UUID`
Message-ID: <ZElxdu/ssy/vnkiR@moria.home.lan>
References: <20230426171512.89139-1-i@truongsinh.pro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426171512.89139-1-i@truongsinh.pro>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Apr 26, 2023 at 10:15:12AM -0700, TruongSinh Tran-Nguyen wrote:
> This commit enhances mount sub command by allowing it to accept
> `OLD_BLKID_UUID=xxx` as the device, enabling whole fs mounting without relying
> on colon-separated devices.
> 
> Using colon-separated devices in fstab is discouraged due to potential device
> reference issues after reboot. Additionally, using `UUID=xxx` in fstab or with
> `mount -t bcachefs` is currently infeasible as it depends on blkid, which prior
> to v2.39, does not recognize bcachefs. This update enables mounting via fstab
> using `OLD_BLKID_UUID=xxx` as obtained from `bcachefs show-super` "External
> UUID".

That looks good, can you give me a cleaned up version of the previous
patch too? Thanks
