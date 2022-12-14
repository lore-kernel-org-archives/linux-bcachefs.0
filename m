Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3286C4332F
	for <linux-bcachefs@archiver.kernel.org>; Wed, 14 Dec 2022 17:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbiLNRro (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 14 Dec 2022 12:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLNRrn (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 14 Dec 2022 12:47:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91BB29A
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Dec 2022 09:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671040015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LD4Fhdp9mVlxc8PEN3CLTCclJg8PnD23elgUQemx0iQ=;
        b=eHxO0Q49b9vvyeVZ++EANIQrl7Qg4vHSS3MCfsx81C2Ew/YKXDoewhKHbqeK7uixhkoS7Z
        IJWjzyfy10adpxk0d9MpI23WorbiLJiE2Da94gsUYv323kQjxdhLd2RoJp3mhbQNnYhWxc
        nmcNWYP7TZtGqQTQ57iDbSMyQrboQbE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-CavUV127MHqYmotFoXr3hQ-1; Wed, 14 Dec 2022 12:46:53 -0500
X-MC-Unique: CavUV127MHqYmotFoXr3hQ-1
Received: by mail-qt1-f198.google.com with SMTP id gc12-20020a05622a59cc00b003a5444280e1so2847030qtb.13
        for <linux-bcachefs@vger.kernel.org>; Wed, 14 Dec 2022 09:46:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LD4Fhdp9mVlxc8PEN3CLTCclJg8PnD23elgUQemx0iQ=;
        b=CBZCN3PcaPYvlDuDoGVYlLALanEHI4RVZRrxwzagg/JX7iZ53qvMX1jG1cSKL+OGZw
         Bkrqr8Yvw0qapDZvoZWxunOIVyagS51UQJU+QnPVogDXHiTTo7KX2WEIv5vjFBRSWLgw
         8flytfzjjClv2XQX0YJdGqZavJLCQbjTk0L7Sn0mD1tKlSREEhLBqZfhnqWAQ0wg8wNT
         H7bWEPoOyfR1KPf/SOh33Tm17POD5WnkkNAenCBL3LNX1MFratKVf0sKkTGXb1wyyB/v
         u7b/0jh70MPz0WCpLizVlLHEJeksOYNvyk/zsz8lbSZo3UmbyMolY/twX1SAtFjuJHrx
         KC+Q==
X-Gm-Message-State: ANoB5pklZBMBurCC0XSpFdzdmMdQ6qmiMUwcopHDKd6SVxV59GIUci+Q
        IqgMH2EpK+h+4IXvhBP+h1Zckq+Zhj4gSzD/2f4tTjreqJmut0LKCxbg4UG3rknDBSuMVKt5ex3
        aTVZzs5pPbGRlXUDUpqmnohryuHI=
X-Received: by 2002:a05:622a:1002:b0:3a5:4e34:fafe with SMTP id d2-20020a05622a100200b003a54e34fafemr45007048qte.68.1671040012826;
        Wed, 14 Dec 2022 09:46:52 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7wd1ow8fYg5SOCGPvM0fxXCKvgT4AY0aBuZL9bcMs8NQEVoOXXHmoIZRT4gi/HCCHXNCBiKA==
X-Received: by 2002:a05:622a:1002:b0:3a5:4e34:fafe with SMTP id d2-20020a05622a100200b003a54e34fafemr45007027qte.68.1671040012617;
        Wed, 14 Dec 2022 09:46:52 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id ay42-20020a05620a17aa00b006b929a56a2bsm10345844qkb.3.2022.12.14.09.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 09:46:51 -0800 (PST)
Date:   Wed, 14 Dec 2022 12:46:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [BUG] trace_printk() broken?
Message-ID: <Y5oME9YVbg9Me2An@bfoster>
References: <Y5d/B88BOu6qOE5X@bfoster>
 <Y5kLgQh3NVMmUr8W@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5kLgQh3NVMmUr8W@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Dec 13, 2022 at 06:32:17PM -0500, Kent Overstreet wrote:
> On Mon, Dec 12, 2022 at 02:20:39PM -0500, Brian Foster wrote:
> > Hi,
> > 
> > While poking around the bcachefs tree I ran into a problem where
> > trace_printk() seems to be broken. I suspect this has something to do
> > with the printbuf bits as it works once I back out some of those
> > changes.
> > 
> > What I observe is that a smaller printk with a fixed string seems to
> > work as expected, but once I add some variable args the message string
> > seems to get chewed up. This results in wonky formatting when reading
> > /sys/kernel/debug/tracing/trace and a read of the corresponding
> > trace_pipe file seems to spin in a livelock.
> 
> I recently noticed it was broken too, but different symptoms - I wasn't getting
> any output at all. Thanks for the reminder, I'll have a look soon.
> 

Thanks. Just to be clear, I saw no output from trace_pipe. The separate
.../tracing/trace file is where I observed the wonky event formatting.

Brian

