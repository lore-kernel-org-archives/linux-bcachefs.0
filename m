Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CAACE79A8
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Sep 2023 20:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjISUyD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 16:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbjISUyC (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 16:54:02 -0400
Received: from out-226.mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF43BF
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 13:53:51 -0700 (PDT)
Date:   Tue, 19 Sep 2023 16:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695156829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KQ9SnVQR0ev2rRpFFyXcwg3OT+7mPuajRg1/AFqHDzE=;
        b=rW8Qh/dj/Kdb0RdB34BMKvHEQUKyWwxEEGeAOrIG16Tyi6NBCYeGDrJYnhhjuQejbCMCd2
        FOCbOwc/UoeJ1CogiUEw73ECBpEecqhEEGFr5TbN3K9T82WTKsdLUrLcyqX3aapC55qWag
        NqNdM3+mCPAfvLWQosoqhwmwgTAXevk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] bcachefs: Fix -Wself-assign
Message-ID: <20230919205347.qfof2omdw6tyedfe@moria.home.lan>
References: <20230919-bcachefs_self_assign-v1-1-830936792fc9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230919-bcachefs_self_assign-v1-1-830936792fc9@google.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 19, 2023 at 01:38:31PM -0700, Nick Desaulniers wrote:
> Fixes the following observed error reported by Nathan on IRC.
> 
>   fs/bcachefs/io_misc.c:467:6: error: explicitly assigning value of
>   variable of type 'int' to itself [-Werror,-Wself-assign]
>     467 |         ret = ret;
>         |         ~~~ ^ ~~~
> 
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Applied, thanks!
