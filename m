Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54213C7618D
	for <linux-bcachefs@archiver.kernel.org>; Thu,  6 Apr 2023 19:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbjDFTau (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjDFTap (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 6 Apr 2023 15:30:45 -0400
Received: from out-23.mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F055E7AA6
        for <linux-bcachefs@vger.kernel.org>; Thu,  6 Apr 2023 12:30:43 -0700 (PDT)
Date:   Thu, 6 Apr 2023 15:30:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680809441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DtT3lrOAqRiRb5qOJ2BtiIe8CSyFEtEHpAZJimRfSug=;
        b=ZGKW5HzfEDj9ftbdoQH/eImSNysbiEAbBMZDDt5QaurppqaCcEc+wNkxqRcTNuLgBQToQq
        UgXzXZtrqLmlUIYbe2VziJgpLccKXDJQlBMw6GF8XmZ9CV6Qmq1k67yTW9aGURRY4UIBAD
        s6tN7mSvvta+9eOukP12y7dhqHqIVVg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     cee1 <fykcee1@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Questions about struct btree
Message-ID: <ZC8d3nh0DEtpKpRd@moria.home.lan>
References: <CAGXxSxWrf8gy6zTeEGbqGxYSxfA5y9grqouUa9KYgwTuWF05dg@mail.gmail.com>
 <ZC0XmlhMK1bEE2lq@moria.home.lan>
 <CAGXxSxVWsoh6=Z039Wn8caXa+BJU7inL-Kg0i328=-jxa4r-BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXxSxVWsoh6=Z039Wn8caXa+BJU7inL-Kg0i328=-jxa4r-BA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Apr 07, 2023 at 12:09:23AM +0800, cee1 wrote:
> Hi Kent,
> 
> Thanks for the reply.
> 
> >
> > > b) struct btree::set
> > > How many effective bsets (or btree_node / btree_node_entry) referenced
> > > by btree::set?
> > > Two? one for written, one for in-memory?
> >
> > Up to three, decreasing in size geometrically.
> 
> Is btree::set[0] special? How is set[0] special comparing with the
> other two sets?

No, it's not particularly special, except that set[0] is always already
written out to disk. The other sets may or may not have been written.

The last set is special: we use a different kind of lookup table (not
eytzinger layout), that's not quite as efficient to search, but more
efficient to update.

> Two further questions:
> 1. btree_node::min_key and max_key, does it mean ALL keys start from
> min_key, end with max_key, exist in this btree_node? (assuming not an
> interior node)

Yes. That rule also holds for interior nodes.

> 2. Overwrite an existing key in a written set, a key of a different
> value will be inserted in a tailing set, am I right?

Yes.

> What if overwrite the same key many times, will this create many
> bsets? If so, how to keep "up to three bsets per struct btree"?

No, overwrites don't cause new bsets to be created. We create a new bset
when the last bset is getting too big and the memmove for inserting into
it is getting too expensive, or when we don't have any unwritten bsets.

> In
> struct btree {
>    ...
>    __BKEY_PADDED(key, BKEY_BTREE_PTR_VAL_U64s_MAX);
>   ...
> }
> 
> Can I say size of -- `struct bch_btree_ptr_v2` plus BCH_REPLICAS_MAX *
> `struct bch_extent_ptr` -- is big enough for holding any bch_val?

That's only true for btree node pointers.

> In other words, bch_vals are either some small metadata, or somewhat
> of pointers, e.g. pointing to a continuous of sectors?

Some may be much bigger - i.e. bch_inline_data
