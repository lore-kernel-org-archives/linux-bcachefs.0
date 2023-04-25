Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B76C77B61
	for <linux-bcachefs@archiver.kernel.org>; Tue, 25 Apr 2023 15:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjDYPb5 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 25 Apr 2023 11:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjDYPb5 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 25 Apr 2023 11:31:57 -0400
Received: from out-8.mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024D8100
        for <linux-bcachefs@vger.kernel.org>; Tue, 25 Apr 2023 08:31:52 -0700 (PDT)
Date:   Tue, 25 Apr 2023 11:31:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682436709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVecaTBlP8raCYrNjK/2dVMKcA/QNJwpKOc0Utv+cs8=;
        b=uwz6l9Ciylw3WTxZ36AjuyvuQ3y9VTt9F5Z/msGgL/qthW+f0iQhYSTuOf/sUghFtQsrCC
        MugW2pKTsKAF/cK3r/laXti/5mUvEzQU1fykwKTQ1NyzbOkmjRazu6lgfJjKmYzzmOQui7
        FMgBFDAfgo5ErQQq9+yivixlS+SHScI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Janpieter Sollie <janpieter.sollie@kabelmail.de>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] add --data_types for bcachefs device add
Message-ID: <ZEfyYmEWGZ83tB9e@moria.home.lan>
References: <09ee430c-9ef3-74cf-1738-3cbf96577af5@kabelmail.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09ee430c-9ef3-74cf-1738-3cbf96577af5@kabelmail.de>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Apr 25, 2023 at 11:08:59AM +0200, Janpieter Sollie wrote:
> Hi everyone,
> 
> bcachefs format allows to specify data types allowed on a specific device
> (eg: to enforce caching on cheap SSDs while btree info is kept for SSDs with higher TBW),
> but this currently is not available when adding a device with bcachefs format.
> 
> The patch below adds this functionality.  It is kept as minimal as possible,

git am said this was corrupt - were you using git send-email? If that's
not an option, just include a git request-pull style link to your git
repo.

> but in the future maybe the OPTS from bcachefs format can be imported
> instead of the specific opts of device add

Yeah that's the right thing to do.

> 
> Kind regards,
> 
> Janpieter Sollie
> 
> diff --git a/cmd_device.c b/cmd_device.c
> index c59d370..1e8137b 100644
> --- a/cmd_device.c
> +++ b/cmd_device.c
> @@ -41,6 +41,16 @@int device_usage(void)
>        return 0;
> }
> 
> +static u64 read_flag_list_or_die(char *opt, const char * const list[],
> +                          const char *msg)
> +{
> +        u64 v = bch2_read_flag_list(opt, list);
> +        if (v == (u64) -1)
> +                die("Bad %s %s", msg, opt);
> +
> +        return v;
> +}

Don't cut and paste, move the existing version of this to the
appropriate utility/lib file.

Rest of the patch is fine.
