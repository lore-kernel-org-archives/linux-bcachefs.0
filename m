Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC45C636CC
	for <linux-bcachefs@archiver.kernel.org>; Sat,  4 Feb 2023 21:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjBDVdW (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 4 Feb 2023 16:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjBDVdV (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 4 Feb 2023 16:33:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496189EF2
        for <linux-bcachefs@vger.kernel.org>; Sat,  4 Feb 2023 13:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675546350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V9TbZHsuECEDmtNaXQrAOksm36sNp5beUtzz5lPuUcw=;
        b=VTKWktXxQpjFVu26WRz14O5O9qRTt9mwoJPq/2xvqFYPHf16IGWrzsQSQWFSBG83zHQQR7
        MQKtHAe/AWsWTQ3NmxcKtbHh0d9avkYnhl7htwLPbQzaWTO06lWRy7FXPIcRGy2MREiQya
        K3JYwWfDexFxlR3wNej3Ubieca15GPo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-159-VPUYrdBJOjm_GAFUT0g4YQ-1; Sat, 04 Feb 2023 16:32:28 -0500
X-MC-Unique: VPUYrdBJOjm_GAFUT0g4YQ-1
Received: by mail-qk1-f198.google.com with SMTP id q13-20020a37f70d000000b007283b33bfb3so5519740qkj.4
        for <linux-bcachefs@vger.kernel.org>; Sat, 04 Feb 2023 13:32:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9TbZHsuECEDmtNaXQrAOksm36sNp5beUtzz5lPuUcw=;
        b=sy0tp+Hc3qVxHhMQuRPHS99aMSSZLksq32IGx+jbvVTKJJ5novLXgM2fjtQ7HrSshp
         LFJfujlu5ZtEAHBvtZZAYxfrOlnj1M2+iIzCZJrqqaB0Na6CZ+eBKVOchUoeffggHRfP
         he8w4i8fq1b4HnH9fpPphriLsNsQaZdJUikStPnufj+K29hptp1vWxGpUWjKDwhZLcoz
         iQkU3nDAflKbaNjWXflhjAx3XGFhesGIXJElWOaXK2kROYKSeBYygKhXNwrcRaC5VkyG
         6wtbqpQbtJNaQLI4IDVUlci2zo8B/VTQ+FyNeWv3jZakAN7vNmySrRTHUYCimUIvuBs3
         1f4A==
X-Gm-Message-State: AO0yUKXRS/viHdRHeXZYn02aOe6p/Zoyu5sUVgEqns/DoNuEexnpbQlR
        A5E5bXwXFCwT9KByaCsPK+KkgibhXRN7Zpnm79I4ZNgGzvkSkmFKZRS65qstZW4LMBou2IcBb09
        uuBJYKKQJ24Knt9zt6sJK5hNXhsc=
X-Received: by 2002:a05:622a:189f:b0:3b8:6ae9:b107 with SMTP id v31-20020a05622a189f00b003b86ae9b107mr28332850qtc.17.1675546347579;
        Sat, 04 Feb 2023 13:32:27 -0800 (PST)
X-Google-Smtp-Source: AK7set+Utbcnsn3GY7WhjMo8UcGoWK1Y9batRHfUnaa2HfakdfIuGotsj4R4TxajGsl1v7WlQ1iJFA==
X-Received: by 2002:a05:622a:189f:b0:3b8:6ae9:b107 with SMTP id v31-20020a05622a189f00b003b86ae9b107mr28332832qtc.17.1675546347291;
        Sat, 04 Feb 2023 13:32:27 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id bk42-20020a05620a1a2a00b006fa16fe93bbsm4563690qkb.15.2023.02.04.13.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 13:32:26 -0800 (PST)
Date:   Sat, 4 Feb 2023 16:33:41 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y97PNdqx82rot2WC@bfoster>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9w/oMzjVp90c/Pk@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9w/oMzjVp90c/Pk@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Feb 02, 2023 at 05:56:32PM -0500, Kent Overstreet wrote:
> On Tue, Jan 31, 2023 at 11:04:11AM -0500, Brian Foster wrote:
> > On Mon, Jan 30, 2023 at 12:06:34PM -0500, Kent Overstreet wrote:
> > > On Fri, Jan 27, 2023 at 09:50:05AM -0500, Brian Foster wrote:
> > > > Something else that occurred to me while looking further at this is we
> > > > can also avoid the error in this case fairly easily by bailing out of
> > > > bch2_fsync() if page writeback fails, as opposed to the unconditional
> > > > flush -> sync meta -> flush log sequence that returns the first error
> > > > anyways. That would prevent marking the inode with a new sequence number
> > > > when I/Os are obviously failing. The caveat is that the test still
> > > > fails, now with a "Read-only file system" error instead of EIO, because
> > > > the filesystem is shutdown by the time the vfs write inode path actually
> > > > runs.
> > > 
> > > If some pages did write successfully we don't want to skip the rest of
> > > the fsync, though.
> > > 
> > 
> > What does it matter if the fsync() has already failed? ISTM this is
> > pretty standard error handling behavior across major fs', but it's not
> > clear to me if there's some bcachefs specific quirk that warrants
> > different handling..
> > 
> > FWIW, I think I've been able to fix this test with a couple small
> > tweaks:
> > 
> > 1. Change bch2_fsync() to return on first error.
> 
> I suppose it doesn't make sense to flush the journal if
> file_write_and_wait_range() didn't successfully do anything - but I
> would prefer to keep the behaviour where we do flush the journal on
> partial writeback.
> 

That seems reasonable to me in principle...

> What if we plumbed a did_work parameter through?
> 

... but I'm not sure how that is supposed to work..? Tracking submits
from the current flush wouldn't be hard, but wouldn't tell us about
writeback that might have occurred in the background before fsync was
called. It also doesn't give any information about what I/Os succeeded
or failed.

I was thinking about whether we could look at PageError pages or perhaps
sample errseq or something in the error case, but the fdatawait can
clear page errors and errseq only bumps the sequence value if it's been
sampled since the last update (so no way to distinguish between "one
failure" and "everything failed").

The only other thing that comes to mind is explicit
submit/completion/error counting and tracking somewhere in the mapping
or inode or some such, but that seems like overkill given fsync error
semantics. I.e.  when fsync returns an error, we're basically telling
the user "data loss somewhere in the file," without indication of where
or how much, so the user basically has to recreate the file or toss it
anyways. It would be nice to improve on that, but that's a much bigger
problem than I'm trying to address here. ;P

So I dunno.. I'll try to think a bit more about it but atm I'm not
seeing any sort of elegant way to fix this test and also preserve the
inode flush in the event of writeback failure. Thoughts? ISTM that it's
reasonable to skip the flush on wb error given fsync behavior and error
semantics seem common across all major fs', and as background writeback
should still try to handle it in short order anyways, but it's your
tree.. :)

Brian

