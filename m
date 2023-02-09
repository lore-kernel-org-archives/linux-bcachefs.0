Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD9AC05027
	for <linux-bcachefs@archiver.kernel.org>; Thu,  9 Feb 2023 12:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjBIM45 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 9 Feb 2023 07:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjBIM44 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 9 Feb 2023 07:56:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74795774A
        for <linux-bcachefs@vger.kernel.org>; Thu,  9 Feb 2023 04:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675947370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XDfly63fJ4M4WgqB4xLuodKCBO5dDoG43DlALvy1TBs=;
        b=gPaW/EYszNSgLgu/umWX4PX4wJniakrku8DXH9+WBAvGt3USicLmEzFS8Kd06Pr3pBnKjW
        wFZ8cVPAguhDGpD7gjA5w03WA3laHDkHndMhDOCp1Vw0dCO/TwTDoTpr/T8nU+5C3hPaj7
        qSCa6lg6U0a5TbL9+Iil2dQ3fzwzoF8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-172-8QTN2EhSOe6T_9BJmYldkQ-1; Thu, 09 Feb 2023 07:56:09 -0500
X-MC-Unique: 8QTN2EhSOe6T_9BJmYldkQ-1
Received: by mail-qv1-f70.google.com with SMTP id l6-20020ad44446000000b00537721bfd2dso1192761qvt.11
        for <linux-bcachefs@vger.kernel.org>; Thu, 09 Feb 2023 04:56:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XDfly63fJ4M4WgqB4xLuodKCBO5dDoG43DlALvy1TBs=;
        b=KUrdlTnz67x10Ttr6Pnja14cRUZJYhavPQherzFRiFP8TG0zEt0vGcvKyxF0OGDIbd
         L8L9C5SpfuDVFAR4lfo2GZheQqZ5XdUM8t3vNO4/Lb8A/o8hxCRNbSacTbOuallCAuUw
         H3LyVfOkH34/P6xI4q/LCL3n0FPNNoQ4+FEwU6kGsnRTZDNkSSmtj7MXBri65w1/ri2N
         Gb+Yhq1tJ+iD5xMV80Woo7mTkZ+4fq0sm+xT+ydRyL48cBl5wO7Pu8LM2oitBq+q2UXS
         s46fOzpNjuUZuEztf+Dgn/9LwIIw5ciuevvpO3iFhexVv5+zwTs7ALoRZB76UiAv8y8/
         vsnA==
X-Gm-Message-State: AO0yUKX7tiDURgh7MiG+gqRTHg9Ttxy2fzo2U5Bb7NMnliEBXobUMSff
        WDmbLR8UHipkVEZQjAjo+y/uj5fX0R3Wr+DEdU9KdYFuvDydeNvfYsWRYur3sNq9HIsT91cJkFA
        G7egWXt/HkqUAkuVUF2NtxLhAEPcdJcY8
X-Received: by 2002:a05:6214:2466:b0:56c:1e71:cda0 with SMTP id im6-20020a056214246600b0056c1e71cda0mr9763078qvb.29.1675947367926;
        Thu, 09 Feb 2023 04:56:07 -0800 (PST)
X-Google-Smtp-Source: AK7set8nVlk8AT+7fhe2T8xlxDBlacHsdU8yKCrzue31bIOvIgsIRU6CXw1VHUvnEzR1dqeOxROKmA==
X-Received: by 2002:a05:6214:2466:b0:56c:1e71:cda0 with SMTP id im6-20020a056214246600b0056c1e71cda0mr9763050qvb.29.1675947367594;
        Thu, 09 Feb 2023 04:56:07 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id l63-20020a378942000000b0071d3e432c9bsm1297253qkd.28.2023.02.09.04.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 04:56:06 -0800 (PST)
Date:   Thu, 9 Feb 2023 07:57:31 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: fstests generic/441 -- occasional bcachefs failure
Message-ID: <Y+Ttu34uCf4tn3jM@bfoster>
References: <Y9FOlMILXFcNFsSW@bfoster>
 <Y9KXaSkuMZM663Vi@moria.home.lan>
 <Y9PkndpTQcHrZ+im@bfoster>
 <Y9f5GjOocd7Cq7V7@moria.home.lan>
 <Y9k7+6io64IpHlQh@bfoster>
 <Y9w/oMzjVp90c/Pk@moria.home.lan>
 <Y97PNdqx82rot2WC@bfoster>
 <Y97Y76dSCVkF0WIE@moria.home.lan>
 <Y+EduoshRHXec+XU@bfoster>
 <Y+F8u7AJ2K4vwpDq@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+F8u7AJ2K4vwpDq@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Feb 06, 2023 at 05:18:35PM -0500, Kent Overstreet wrote:
> On Mon, Feb 06, 2023 at 10:33:14AM -0500, Brian Foster wrote:
> > So yes, it seems the sync_inode_metadata() path is what bumps the
> > journal seq and the explicit journal flush is what shuts down the fs,
> > but I assume sync_inode_metadata() attempts the inode flush simply
> > because the buffered write that precedes it works perfectly fine. This
> > is what had me thinking that bch2_fsync() is being more aggressive than
> > it really needs to be here. With the proposed logic tweak, the second
> > issue is resolved because bcachefs no longer attempts the inode flush
> > when page writeback has failed. So what happens in the test is that it
> > switches back over to the functional dm table, the vfs inode flush
> > occurs then and succeeds, and so the test sees no (unexpected) errors
> > and the fs has survived without shutting down.
> 
> So, sync_inode_metadata() is just writing out timestamp updates.
> 

Yeah.. I hadn't confirmed, but that's what I figured.

> But, there's no reason we couldn't be doing that as part of the write
> path, if it was plumbed through - the write path has to do an inode
> update anyways. Although that would involve an unpack/repack of the
> inode, so maybe we don't want to do that - we'd want to change the inode
> format to not encode timestamps as varints, and I'm not sure that's
> worth the hassle and the increased inode size.
> 
> I was eyeing changing the way timestamp updates work to make them more
> direct, it would get rid of the need to call sync_inode_metadata() and
> regularize timestamp updates with the way inode updates work for
> everything else - ISTR that's how it works in XFS as well. But it'd make
> atime updates more expensive, and that's not something I've looked into
> yet.
> 
> > All in all I think this test basically builds on some minor assumptions
> > about how fsync error behavior is implemented in Linux, and bcachefs
> > happens to slightly diverge in a way that leads to this shutdown. IOW,
> > I'd expect the same problematic behavior out of XFS if it implemented
> > this sort of fsync logic, but afaict no other fs does that, so the test
> > is functional in practice. I admit that's not the best pure engineering
> > justification for the change in bcachefs (so I understand any
> > hesitation), but IMO it's reasonable in practice and worthwhile enough
> > to improve test coverage. I haven't audited fstests for this or
> > anything, but it wouldn't surprise me much if there are other tests that
> > rely on this sort of "assumed behavior" for testing I/O failures.
> > Thoughts?
> 
> Yeah, maybe we should hold off on making any decisions until we see
> where else this comes up, I hoped this test was going to be easier to
> fix but it doesn't seem like there's any clean obvious solutions. Ah
> well :)
> 

Indeed. While the proposed logic change seems reasonable to me (for
reasons already explained)...

> LSF is coming up and as I recall that's where the errseq stuff was
> originally discussed - I'd like to hear from the people behind those
> changes if they thing leaving our journal flush out of the errseq path
> is reasonable (it seems so to me, but it's worth bringing up). I can
> pencil it in to the bcachefs talk... need to start working on that...
> 

... I also think it's reasonable to sit on it, take stock of the scope,
and gain more input wrt to errseq and whatnot, should any of that lead
to potentially better solutions.

> We can just leave it failing in the CI for now - maybe make some notes
> as to what our options are when we decide to come back to it, there's
> definitely more straightforward and more impactful bugs to work on in
> the meantime.
> 

Ok. FWIW, I was just trying to pick off something that looked
approachable because that helps get more comfortable with the code,
etc., even if it doesn't result in an immediate fix. I.e., this
investigation/root-cause was helpful to grok journaling a bit more,
uncover (to me, at least) a use case for freeze, etc.

If you have any other open bugs that you think might be useful to look
into, feel free to send them along..

Brian

