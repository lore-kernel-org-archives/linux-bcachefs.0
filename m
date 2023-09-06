Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCD5EE14D0
	for <linux-bcachefs@archiver.kernel.org>; Wed,  6 Sep 2023 19:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjIFTIu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 6 Sep 2023 15:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243627AbjIFTIt (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 6 Sep 2023 15:08:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5231B7
        for <linux-bcachefs@vger.kernel.org>; Wed,  6 Sep 2023 12:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694027274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VAYQ+cTi7hLhD7vrr0e4kCFHm76rUWgsRG2wekpdYR0=;
        b=Xg+20r6E/WmUgypNcK4cfAFJ6Kx3LJYs/gJDiHgxb/m6izJHdD21Se5QxpTJGNDpIn+10R
        vGTOSlLbG/CJKxlPa41cNu1ElQEEaSH8HE9eZbOCxki7JeEZhzrJpfWvqInBn97JBsRwjz
        PbQFW/ZcYfXAMUxKuG654UcsAVMK4CI=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-aoG3NZmBOE-f3ez4sUyz4w-1; Wed, 06 Sep 2023 15:07:52 -0400
X-MC-Unique: aoG3NZmBOE-f3ez4sUyz4w-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-187959a901eso218277fac.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Sep 2023 12:07:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694027271; x=1694632071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VAYQ+cTi7hLhD7vrr0e4kCFHm76rUWgsRG2wekpdYR0=;
        b=XvgY1HIfoitw4eT2wSk66rpbl2k/u5lipjFXtDAuNr9CEhdA3fZEhdvNi9uzsIvsIC
         4FTNEkh8kFmjIjfSNZBOK7gbbrvOciSrbNlF4hGjsXZLmz7Dq1UIrqyRZ/Vn+mneD0SI
         cxFVR/VCvdoFAcpA3M9QBl/Gonyj3XiVuNOXrHCG8zr0KA9UgOyWXsz1fYg5N8MSIVjg
         1q+KWhJs4Tf79g7sxMDxAieETz0MV4+GoAbf0pnEB7H3AUhODRQyw58+r+WaE0lUkCpI
         x09CvPyO+lV9nhX8xcyPe2jH0CRsC0spYfCKwt90BYEhJeRe99t+jAXdFEcZM6GBotc5
         XJkw==
X-Gm-Message-State: AOJu0YzaJxWfWaaFJj091xEnLj4gJ4EQkwRmvl8Pn3WqHNXSfDEY5Jqx
        fHDlRS1+F2MO1KuWn3+CygqP4XFVyo3ThBS039j0GkiZDE9G2R8fNVlTCd4kuiTd44ivgDmjEni
        LsCNbrD7z2jxpUtWO4sA/BvUTjro=
X-Received: by 2002:a05:6870:40ce:b0:1be:f0b4:b9bc with SMTP id l14-20020a05687040ce00b001bef0b4b9bcmr21482431oal.39.1694027271478;
        Wed, 06 Sep 2023 12:07:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJhLlqOh8oMwOdqScI5fTdYFdjJgSqMVecwqsN12m9y5SyvawBlZ5rp9aQvswVZ+TZzNILLQ==
X-Received: by 2002:a05:6870:40ce:b0:1be:f0b4:b9bc with SMTP id l14-20020a05687040ce00b001bef0b4b9bcmr21482412oal.39.1694027271145;
        Wed, 06 Sep 2023 12:07:51 -0700 (PDT)
Received: from bfoster (c-24-60-61-41.hsd1.ma.comcast.net. [24.60.61.41])
        by smtp.gmail.com with ESMTPSA id q13-20020ae9e40d000000b0076f319acaedsm5168243qkc.48.2023.09.06.12.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 12:07:49 -0700 (PDT)
Date:   Wed, 6 Sep 2023 15:07:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 3/3] bcachefs: fix race between journal entry close and
 pin set
Message-ID: <ZPjODscrfsdXcgPf@bfoster>
References: <20230831110734.787212-1-bfoster@redhat.com>
 <20230831110734.787212-4-bfoster@redhat.com>
 <20230903211812.kh7paaa5z25lwbd4@moria.home.lan>
 <20230904022928.x64kp2vhtxxzvcal@moria.home.lan>
 <ZPcmFqnjouET8rqa@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPcmFqnjouET8rqa@bfoster>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Sep 05, 2023 at 08:59:02AM -0400, Brian Foster wrote:
> On Sun, Sep 03, 2023 at 10:29:28PM -0400, Kent Overstreet wrote:
> > On Sun, Sep 03, 2023 at 05:18:12PM -0400, Kent Overstreet wrote:
> > > On Thu, Aug 31, 2023 at 07:07:34AM -0400, Brian Foster wrote:
> > > > bcachefs freeze testing via fstests generic/390 occasionally
> > > > reproduces the following BUG from bch2_fs_read_only():
> > > > 
> > > >   BUG_ON(atomic_long_read(&c->btree_key_cache.nr_dirty));
> > >
> > > Your fix makes sense, but I wonder if it might be simpler and better to
> > > fix this in bch2_journal_reclaim_fast().
...
> 
> FWIW, one thing I disliked about the original patch was the need to
> mostly duplicate the buf put helper due to the locking context quirk. I
> was trying to avoid that, but I ran out of ideas before I wanted to move
> on actually fixing the bug. My preference would be to address the
> reference counting issue as is (to preserve design simplicity), and then
> maybe think a bit harder about cleaning up the res put implementation if
> the primary concern is that we feel like this starts to make things a
> bit convoluted..
> 

Another thought that comes to mind is to perhaps allow the journal_res
to hold a reference to the pin fifo for the associated seq.. The idea
would be we could continue to hold a reference during the open/close
journal buffer lifecycle, but a res of the same seq would acquire an
additional reference as well to keep the tail from popping before a
transaction can actually set a pin (i.e. essentially parallel to the
buffer reference).

In a sense the behavior in this patch is kind of an optimization of that
approach, but I think implementing it directly would eliminate the need
to mostly duplicate the put helper, perhaps making things a bit more
natural. We could still fall into bch2_journal_reclaim_fast() from
res_put(), but now only for cases where the reservation outlives the
active journal buffer (due to a journal flush or whatever). That also
still addresses the race by properly using the reference count. I'd
probably have to try it to be sure I'm not missing something, but...
thoughts?

Brian

