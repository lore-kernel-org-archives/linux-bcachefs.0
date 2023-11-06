Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63F0C4167D
	for <linux-bcachefs@archiver.kernel.org>; Mon,  6 Nov 2023 03:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjKFDIK (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 22:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjKFDIK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 22:08:10 -0500
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77130FB
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 19:08:07 -0800 (PST)
Date:   Sun, 5 Nov 2023 22:08:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1699240085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cPB+gQULftzdxrXbYK+nTuNYwE28bOhzjLLNlNRU7tc=;
        b=e7OoKvB4mHNMqZpzcNRZjvkdmVp+mpZ6DiAuSYmfMfDC7YyD1jYiG68AAvEM9okKQoRzwG
        DQ4aTwmbRmDQ9BS7qSsVfyW4edLr/OKQE6S7NxklgFoxJEWSwdnn2TRUxX2vaWTfHZ/Omh
        L7p5KwYdeV5fY72ZrGkhYo/lARVDdWg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     bfoster@redhat.com, linux-bcachefs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] bcachefs: make bch2_target_to_text_sb static
Message-ID: <elba3jjtl7ftiq5ey37u2t27xokab7n2ulbynl4gev2dpzyfr5@gjkv3hrkgt26>
References: <20231106023401.28196-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231106023401.28196-1-jiapeng.chong@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Nov 06, 2023 at 10:34:01AM +0800, Jiapeng Chong wrote:
> The bch2_target_to_text_sb are not used outside the file disk_groups.c,
> so the modification is defined as static.
> 
> fs/bcachefs/disk_groups.c:583:6: warning: no previous prototype for ‘bch2_target_to_text_sb’.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7144
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Thanks, applied
