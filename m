Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2F1C77B73
	for <linux-bcachefs@archiver.kernel.org>; Thu, 27 Apr 2023 23:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjD0XWj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 27 Apr 2023 19:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjD0XWi (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 27 Apr 2023 19:22:38 -0400
Received: from out-36.mta1.migadu.com (out-36.mta1.migadu.com [95.215.58.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4701F10DC
        for <linux-bcachefs@vger.kernel.org>; Thu, 27 Apr 2023 16:22:36 -0700 (PDT)
Date:   Thu, 27 Apr 2023 19:22:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682637755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lRlyVmVkcBN6aTv7IYBiPX6nBL21z4aCF+z/uUhmQzQ=;
        b=lz87/FfA3J84DqYhFA2EBPEnmuFXfgEXHPC+2INU33y9CSdROy3hxKdy1m7qEEdJcr5pRV
        fKE5S74/Wkl/uw+AkwB9zcb48B1OJKqi/WTMt4yDP/KqjRIJ3kkxyBstoNM8owhcpVjkky
        3wscZq302ARYOvH014kNZjEy7B/vRFc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     TruongSinh Tran-Nguyen <i@truongsinh.pro>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] chore(rust): add opt_get! and expose some FMODE_* as
 Rust const
Message-ID: <ZEsDt3aNak/9DD24@moria.home.lan>
References: <20230427180200.18965-1-i@truongsinh.pro>
 <ZErYAKiCYD3nv3za@moria.home.lan>
 <CAMy36z4U_CkFqY1OnvMD7wJOy1TPYV0yb=xgcvSAmPOGoTBq5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMy36z4U_CkFqY1OnvMD7wJOy1TPYV0yb=xgcvSAmPOGoTBq5w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Apr 27, 2023 at 02:17:15PM -0700, TruongSinh Tran-Nguyen wrote:
> The prefix is during the process only, but it will be stripped out by
> `.parse_callbacks(Box::new(Fix753 {}))`. In other words, in Rust,
> it would be used like this:
> 
> ```
> sb.mode &= !FMODE_WRITE;
> ```

Weird, but ok.
