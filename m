Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933B9EB64DA
	for <linux-bcachefs@archiver.kernel.org>; Thu, 20 Jul 2023 21:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjGTV1Q (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 20 Jul 2023 17:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjGTV1P (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 20 Jul 2023 17:27:15 -0400
Received: from out-13.mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4B0271D
        for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jul 2023 14:27:03 -0700 (PDT)
Date:   Thu, 20 Jul 2023 17:26:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689888421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rDJqpSxV2Vo06be+nT0rbnICs5UL+Qu2oyd8D39Yt8A=;
        b=cGDHWgqkv+qWMqhzYuZiqQIf3pqnkm+HKNadENypeggpd6ryDdODMyhXC+SymQFUc8phDm
        oP9AitiY6DLuqBdEHHwfmzdh0GODWdiUGbku0S1vlvnnjS9lxqy5FjNLekgpmfkd8unnFX
        B9YXYM/4bjlAKHjNI9DI28ykMU+2is0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 5/5] bcachefs: use prejournaled key updates for write
 buffer flushes
Message-ID: <20230720212657.tfiootulv3aksq7f@moria.home.lan>
References: <20230719125306.109342-1-bfoster@redhat.com>
 <20230719125306.109342-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719125306.109342-6-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, Jul 19, 2023 at 08:53:06AM -0400, Brian Foster wrote:
> The write buffer mechanism journals keys twice in certain
> situations. A key is always journaled on write buffer insertion, and
> is potentially journaled again if a write buffer flush falls into
> either of the slow btree insert paths. This has shown to cause
> journal recovery ordering problems in the event of an untimely
> crash.
> 
> For example, consider if a key is inserted into index 0 of a write
> buffer, the active write buffer switches to index 1, the key is
> deleted in index 1, and then index 0 is flushed. If the original key
> is rejournaled in the btree update from the index 0 flush, the (now
> deleted) key is journaled in a seq buffer ahead of the latest
> version of key (which was journaled when the key was deleted in
> index 1). If the fs crashes while this is still observable in the
> log, recovery sees the key from the btree update after the delete
> key from the write buffer insert, which is the incorrect order. This
> problem is occasionally reproduced by generic/388 and generally
> manifests as one or more backpointer entry inconsistencies.
> 
> To avoid this problem, never rejournal write buffered key updates to
> the associated btree. Instead, use prejournaled key updates to pass
> the journal seq of the write buffer insert down to the btree insert,
> which updates the btree leaf pin to reflect the seq of the key.
> 
> Note that tracking the seq is required instead of just using
> NOJOURNAL here because otherwise we lose protection of the write
> buffer pin when the buffer is flushed, which means the key can fall
> off the tail of the on-disk journal before the btree leaf is flushed
> and lead to similar recovery inconsistencies.

Fairly simple, and it looks like this fixes all the backpointers errors
- nice, applied.

So journal replay does something similar, where we're doing a btree
update for a key that already lives in a particular journal entry and
the dependency needs to be recorded. Could you have a quick look to see
if there's any cleanups/unification worth doing there? Or if not, just
leave a note.

Also, did you look at adding the tracepoint we talked about, for when
we're doing btree updates that are already at the end of the journal and
immediately need to be flushed?
