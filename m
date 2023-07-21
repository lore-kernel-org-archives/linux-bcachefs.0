Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94B5C001DC
	for <linux-bcachefs@archiver.kernel.org>; Fri, 21 Jul 2023 13:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjGUNHg (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 21 Jul 2023 09:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjGUNHf (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 21 Jul 2023 09:07:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B08186
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jul 2023 06:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689944813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=giwlzKun7NmafHOlAcW91X189NfaMkOpGXbw2vSaAuQ=;
        b=G1hfnX86TBWvulOlI3Yaq/jCW834b54Wx6889+lrUWA3nnzfCXDF4zoCX09w2V8DifiFOE
        nhOH/2W6baYwoBaWKPLbNrFv3ZQl92yWaKNulgu+q4ZWSlaYwlbOuq9FilJ+vNzTRGE1CR
        FvlNToW1IkEeexm4+3NnUCHnzUy9Uv0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-aWOIvfBcP1q_OWT9UP9p6g-1; Fri, 21 Jul 2023 09:06:51 -0400
X-MC-Unique: aWOIvfBcP1q_OWT9UP9p6g-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-765de3a3404so276212385a.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jul 2023 06:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689944810; x=1690549610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=giwlzKun7NmafHOlAcW91X189NfaMkOpGXbw2vSaAuQ=;
        b=ijBFDPfQqVF1zkGqeE3RS48nZbJgYiqZY4k8Yo1Iiv8B7GG/ODRbV6Qt2WTXwTZIHT
         FkHhZV39lqZxdXhnCAH+CPwOVDPKFIAKQcpXTgNLNfQN8W8Ud+/OHbuBwqaLE23vPzC+
         YF3+ooC8xZHiXNmctSSoWSB17lwIHoBUkyOm1VcdoNDYWYgIrRI10JcRjJDVKDaOtMQv
         X3j2ZH1WtjgSPlUgaiBicrU2+ArT6kO2kthr+RkOx7HHYmIifrbzp1k7MAjgd9VyxrgX
         Y9u4ZSU9SKQ0simbtytpQxmndhtn2PtkbKFecdXCxpVeRKM3+TV1oh8gLyW96tTH1OsO
         iqGw==
X-Gm-Message-State: ABy/qLZsin6KlwQ3eKIpS2aAYx3VNnuQYONJtYDPxdSWiYtNOCKX/qXh
        gMku8c7Ga4UTEaTJsLwPHj0AW0Es60pUoHiIXq52i3NiihAW7dn5zVwiGznMwDp6LepckarCjNy
        yvQeYb3bXzvZSzvFDWE5ab2KitSpY0y0yuOk=
X-Received: by 2002:a05:620a:2809:b0:76a:dd4f:a61 with SMTP id f9-20020a05620a280900b0076add4f0a61mr1998534qkp.22.1689944810716;
        Fri, 21 Jul 2023 06:06:50 -0700 (PDT)
X-Google-Smtp-Source: APBJJlErr7ga/Cm47m96Df/trhFOrVnWwpzDJJjCASSJCz3vI0Ixw4Xew8sSY+HEGqZ6Cexd+0XBpQ==
X-Received: by 2002:a05:620a:2809:b0:76a:dd4f:a61 with SMTP id f9-20020a05620a280900b0076add4f0a61mr1998517qkp.22.1689944810452;
        Fri, 21 Jul 2023 06:06:50 -0700 (PDT)
Received: from bfoster (c-98-217-90-195.hsd1.ma.comcast.net. [98.217.90.195])
        by smtp.gmail.com with ESMTPSA id oq15-20020a05620a610f00b007676658e369sm1085478qkn.26.2023.07.21.06.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 06:06:50 -0700 (PDT)
Date:   Fri, 21 Jul 2023 09:09:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 5/5] bcachefs: use prejournaled key updates for write
 buffer flushes
Message-ID: <ZLqDmGvvkc8ZtBTa@bfoster>
References: <20230719125306.109342-1-bfoster@redhat.com>
 <20230719125306.109342-6-bfoster@redhat.com>
 <20230720212657.tfiootulv3aksq7f@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720212657.tfiootulv3aksq7f@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Jul 20, 2023 at 05:26:57PM -0400, Kent Overstreet wrote:
> On Wed, Jul 19, 2023 at 08:53:06AM -0400, Brian Foster wrote:
> > The write buffer mechanism journals keys twice in certain
> > situations. A key is always journaled on write buffer insertion, and
> > is potentially journaled again if a write buffer flush falls into
> > either of the slow btree insert paths. This has shown to cause
> > journal recovery ordering problems in the event of an untimely
> > crash.
> > 
> > For example, consider if a key is inserted into index 0 of a write
> > buffer, the active write buffer switches to index 1, the key is
> > deleted in index 1, and then index 0 is flushed. If the original key
> > is rejournaled in the btree update from the index 0 flush, the (now
> > deleted) key is journaled in a seq buffer ahead of the latest
> > version of key (which was journaled when the key was deleted in
> > index 1). If the fs crashes while this is still observable in the
> > log, recovery sees the key from the btree update after the delete
> > key from the write buffer insert, which is the incorrect order. This
> > problem is occasionally reproduced by generic/388 and generally
> > manifests as one or more backpointer entry inconsistencies.
> > 
> > To avoid this problem, never rejournal write buffered key updates to
> > the associated btree. Instead, use prejournaled key updates to pass
> > the journal seq of the write buffer insert down to the btree insert,
> > which updates the btree leaf pin to reflect the seq of the key.
> > 
> > Note that tracking the seq is required instead of just using
> > NOJOURNAL here because otherwise we lose protection of the write
> > buffer pin when the buffer is flushed, which means the key can fall
> > off the tail of the on-disk journal before the btree leaf is flushed
> > and lead to similar recovery inconsistencies.
> 
> Fairly simple, and it looks like this fixes all the backpointers errors
> - nice, applied.
> 

Thanks!

> So journal replay does something similar, where we're doing a btree
> update for a key that already lives in a particular journal entry and
> the dependency needs to be recorded. Could you have a quick look to see
> if there's any cleanups/unification worth doing there? Or if not, just
> leave a note.
> 

Interesting. IIRC, one of the purposes of generic/388 was to test
crashes during recovery itself, so we should have at least some coverage
in that area.

Can you point to an example or area of code where this occurs with
recovery? (Or do you mean recovery in general has this rejournaling
behavior?)

> Also, did you look at adding the tracepoint we talked about, for when
> we're doing btree updates that are already at the end of the journal and
> immediately need to be flushed?
> 

Not yet.. I wanted to get this worked out first and then ran into some
sort of contention issue during some fstests that I had to dig into
before I got a chance to think about it. I'll send a separate mail on
that one and will probably have to pick up both once I'm back..

Brian

