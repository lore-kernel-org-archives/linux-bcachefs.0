Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC8AC678D5
	for <linux-bcachefs@archiver.kernel.org>; Tue,  7 Mar 2023 14:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCGO03 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 7 Mar 2023 09:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjCGO0J (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 7 Mar 2023 09:26:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CFE92BCE
        for <linux-bcachefs@vger.kernel.org>; Tue,  7 Mar 2023 06:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678198829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wepJf7J7JjGpC2K/jXFj+DIdIWoSrxyc+0uRUaMaXr8=;
        b=T9PtNbNut7JVu6cL4G1j45bYAto/+P4xvOErkwVu37d3aTNc9ofaftGUjY4dJti1EFnDI2
        FnYvx2e2ATSeN6ES1WYjKpcULySWnyiPy96au6w2Sn5xnezB38jvhYe95ZoL/wQWva9ZdS
        85eNjEYeeTgB3BwLEUoPmbWLEtm6GAw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-ups0YTo8PFSFPXMuLai9_Q-1; Tue, 07 Mar 2023 09:20:25 -0500
X-MC-Unique: ups0YTo8PFSFPXMuLai9_Q-1
Received: by mail-qk1-f199.google.com with SMTP id dw26-20020a05620a601a00b0074300c772c0so7457583qkb.11
        for <linux-bcachefs@vger.kernel.org>; Tue, 07 Mar 2023 06:20:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678198824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wepJf7J7JjGpC2K/jXFj+DIdIWoSrxyc+0uRUaMaXr8=;
        b=M8r+uKs2nTtvIjs3P3PpzLbUWYLdE+adV3REE1a37ZD+MyNIuhwspI3NTwISp0KrAW
         LwhA2NBqx23tnbuX13nbJzEy2cY/YQuSaqLriIfwf9QH8QYnR4pxxNvac3Rly0wizbTW
         /yXgQ9z9t/32DijE9BRogRsQ8TLMi+sd+T/rs8Pyka6rvQ2/BpvM/VBerLED7pnETqZm
         JzfJ5AGuMmeZMSe7O0//gq16U484jJX8pEjiRg8QQ46tU3680HH2Awe8kFveRM/uvKWe
         4DBMYD/Lm7hT37JudI1TKqXJOPnBXa/EKru/i9C5M0io5+H6EjP10zsb4ptQmU0RYKhg
         Z6Gw==
X-Gm-Message-State: AO0yUKVB47MGb7blFXdtU0c3kh0ZXrW+GfNd9iNYZu8PL/0grDgzImj7
        EtoJ3XWYpTFjnIW+OaAlPXp5w5WCaB+ZpQv/uqrS6Y0iMkvi2E7sKFGaSuwQN/ksA8FL4Eg8fEW
        JloFyofXHRbCGnwyqEZksTirtGPd7blO5y8M=
X-Received: by 2002:ac8:7d4c:0:b0:3bf:a5e2:79af with SMTP id h12-20020ac87d4c000000b003bfa5e279afmr23864735qtb.37.1678198824106;
        Tue, 07 Mar 2023 06:20:24 -0800 (PST)
X-Google-Smtp-Source: AK7set9xwK+O+DSTvovADOj2R36Rv2v/QrhE9rjjroQTajPMgoIG8WT9laPApAT0gl8BY99Z83qcpg==
X-Received: by 2002:ac8:7d4c:0:b0:3bf:a5e2:79af with SMTP id h12-20020ac87d4c000000b003bfa5e279afmr23864708qtb.37.1678198823825;
        Tue, 07 Mar 2023 06:20:23 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id l6-20020ac84a86000000b003ba11bfe4fcsm9562446qtq.28.2023.03.07.06.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 06:20:23 -0800 (PST)
Date:   Tue, 7 Mar 2023 09:22:07 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: don't bump key cache journal seq on
 nojournal commits
Message-ID: <ZAdIj7loB1hdsKCz@bfoster>
References: <20230302195110.217282-1-bfoster@redhat.com>
 <ZAKwp52iF2v8Okqz@moria.home.lan>
 <ZAXoP29b/QVq3Onn@bfoster>
 <ZAcSpXjwUeAchhMn@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAcSpXjwUeAchhMn@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Mar 07, 2023 at 05:32:05AM -0500, Kent Overstreet wrote:
> On Mon, Mar 06, 2023 at 08:18:55AM -0500, Brian Foster wrote:
> > I ran with the following logic over the weekend and it seemed to avoid
> > any problems:
> > 
> >         if (!(insert_entry->flags & BTREE_UPDATE_NOJOURNAL) ||
> >             !journal_pin_active(&ck->journal)) {
> >                 ck->seq = trans->journal_res.seq;
> >         }
> >         bch2_journal_pin_add(&c->journal, trans->journal_res.seq,
> >                              &ck->journal, bch2_btree_key_cache_journal_flush);
> > 
> > This addresses the scenario above by updating ck->seq when the key cache
> > pin happens to be inactive, which is presumably (?) safe because that
> > means the cache doesn't hold any previous updates. FWIW, I suspect there
> > are probably multiple ways to fix this, such as allowing pin_add() to
> > return whether it actually added a pin, or perhaps resetting ck->seq
> > somewhere on key cache flush so the callback doesn't think it's valid,
> > etc. Thoughts?
> 
> It took me a bit to work out why this is the correct fix, so it'll
> definitely need some documenting (and the blame is on me;
> BTREE_UPDATE_NOJOURNAL was clearly more subtle than I recognized at the
> time) - but yeah, looks good.
> 
> To recap what we discussed on IRC, for anyone else who's reading:
> naively one might assume that in BTREE_UPDATE_NOJOURNAL mode we
> shouldn't do anything here and skip adding the journal pin, except that
> NOJOURNAL updates _do_ need to be written back to the btree and it's
> journal reclaim that is also responsible for that.
> 
> The reason for BTREE_UPDATE_NOJOURNAL is that sometimes we're doing
> inode updates that are only updating bi_journal_seq, nothing else: these
> updates are only needed so that fsync() later knows which journal
> sequence number has to be flushed.
> 
> We have to record this in the btree, because if it was stored in the VFS
> inode that's just a cache and reclaim would break fsync - but we're not
> going to need it after a crash, hence no need to journal it.
> 
> So BTREE_UPDATE_NOJOURNAL updates are really this super rare, special
> purpose performance hack that knowingly break our sequential consistency
> model and should be regarded with suspicion :)
> 

Ack, makes sense.

I added some comments around the updated ck->seq logic and pushed the
patch to my testing branch. It looks like the CI sees it, but hasn't
started on it yet..

> > I have a bigger picture question, however. The key cache is intended to
> > hold updates to multiple different keys that land in the same btree
> > node, right? If so, is it safe to update the key cache pin on later
> > updates like this in general? Specifically I was thinking about the
> > example of two inodes that happen to land in the same key cache (inode
> > A, A+1) but under different journal seqs.
> 
> Yes.
> 
> Originally, on every key cache update we'd call
> bch2_journal_pin_update() - dropping our old journal pin and pinning the
> journal entry of the new update.
> 
> See the patch "bcachefs: Btree key cache optimization" where we switched
> to the new behaviour - it's an optimization to avoid hitting the journal
> lock.
> 

Yeah, I got my wires crossed wrt to the relevant data structures and was
thinking of bkey_cached as "bkey cache," saw the seq associated with
that, and then naturally started to wonder how we manage a set of cached
keys with a single sequence value. Sometime after writing this up I
realized that bkey_cached is a single cached key, and there's a higher
level btree_key_cache data stucture. I still need to poke through that
code a bit more to grok it, but that explains my confusion. :)

> > For example, suppose inode A commits, logs, adds the ck pin, and sets
> > ck->seq (A). Then inode A+1 commits, logs to seq+1, and updates ck->seq
> > again. At this point if journal reclaim flushes the cache with the
> > original pin, we update the pin to the A+1 ck->seq value and return.  If
> > this moves the pin from the front of the journal, what prevents last_seq
> > from being updated to A+1 on disk and introducing the same sort of
> > window where in-core updates aren't covered by the active range of the
> > journal? I.e., if last_seq updates and the filesystem crashes, ISTM we
> > potentially lose the inode A key update, even if it was journaled.
> 
> That's completely fine, provided inode A1 was journalled and is still
> pinned in the journal - in your example, since the pin is updated to the
> sequence number for A1 it will be.
> 
> That is, the journal is very much allowed to drop redundant updates. The
> journal exists to guarantee time ordering, but that guarantee only
> applies after we've finished replaying everything that was in the
> journal.
> 
> If we're only partway through journal replay (say, after inode A but
> before A1), then the btree is going to be complete nonsense in terms of
> consistency - not just because stuff may have been dropped from the
> journal, but because things in the journal maybe be flushed in any
> order, so if we're only halfway through journal replay we fully expect
> to find updates in the btree that are newer than where we're at in the
> journal.
> 

Ok.

> This is touching on the topic of how we guarantee sequential consistency
> after crashes - which is an interesting and lengthy topic, but
> fortunately we don't need to understand it for the problem at hand. The
> only relevant thing for now is that yes, the journal can drop redundant
> updates and it's completely fine.
> 

Indeed. Thanks for the explanation.

Brian

