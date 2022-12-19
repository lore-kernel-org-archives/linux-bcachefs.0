Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D785C4332F
	for <linux-bcachefs@archiver.kernel.org>; Mon, 19 Dec 2022 15:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiLSPnf (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 19 Dec 2022 10:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbiLSPmw (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 19 Dec 2022 10:42:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11E112087
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Dec 2022 07:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671464526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KlmAXRN/bl6GOiZ7bfwE8nGx0LLWtlpcSJavywUbIXE=;
        b=LCi+2BroyGY51KNUsAWDX035aNjGUMSgJ1n6rk29NLffNmOkIxu5JLLVttUAkOGKMqOc2V
        MT5+LWdgEpuFnuVoXCfuJw6enaJyupjPRgmF07aHpSrfAaUBLvSaAiczdX/eJddNQLi9ds
        MyYZxhjwAVhxTXzobOS4/fkYp5bthxc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-379-1iIti7d3PRObsEZVbnQExw-1; Mon, 19 Dec 2022 10:42:04 -0500
X-MC-Unique: 1iIti7d3PRObsEZVbnQExw-1
Received: by mail-qk1-f199.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso7540288qkp.21
        for <linux-bcachefs@vger.kernel.org>; Mon, 19 Dec 2022 07:42:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KlmAXRN/bl6GOiZ7bfwE8nGx0LLWtlpcSJavywUbIXE=;
        b=4j2nzsGs2ZcbnxCH0JdPuP34JbPsgBKo9zQ2INwEXCfTRMxQ3ASdj7LxCW2yWTys5o
         eeyCoZNoM4B3HLbVt7J9YxKJTlSxsM958IzQL4f3204mX+fV84ixdynUtlYhML1Le3wW
         PdvGjZnkxfRi/oFkqPAhxUHbjlR7o0c+Mgq7nHOLnATbEHtZGwGHXN4rLonx3kfNdq5b
         naemJTnA2jOaA9VBnLfS5W/zxo3duV6cvgc8p8SVy1BX1wG1QSsmsXFH1gC1N1XvOakg
         rnrbNbhJx6EkaD4HLD04V18vY4VEa5+WAKox/OB0VMU0koswS3Q0Vmr52Cc8ScGPQiDg
         qnAw==
X-Gm-Message-State: AFqh2kqL31y2xmEmVrwtIyL1k4F/PrRw+W4p2SprhJ6CBZdjlCs8HxhE
        EDEDBCsGz6JLaYqBtcYi23dNLcHoh8AvNJ84Aene2LM09SXieVYIm2AiYyLFRUffmHIpGiPQB1d
        0jF8MOBOuNzAEtefzRvXdJ3BRuk0=
X-Received: by 2002:ac8:44b6:0:b0:3a9:7d74:d138 with SMTP id a22-20020ac844b6000000b003a97d74d138mr11198578qto.40.1671464524078;
        Mon, 19 Dec 2022 07:42:04 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsAKgQ5Wa9xDgBFCzAvbkrDetU3o2mDrt+nRzeIYa6W8RtQxq9qEke9GedRPKLFG/msBwo7iw==
X-Received: by 2002:ac8:44b6:0:b0:3a9:7d74:d138 with SMTP id a22-20020ac844b6000000b003a97d74d138mr11198559qto.40.1671464523823;
        Mon, 19 Dec 2022 07:42:03 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id a16-20020ac81090000000b003a82ca4e81csm6060610qtj.80.2022.12.19.07.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 07:42:03 -0800 (PST)
Date:   Mon, 19 Dec 2022 10:42:09 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y6CGUZhqs5ABBIbO@bfoster>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
 <Y5wYjUhTAzhSIvM3@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5wYjUhTAzhSIvM3@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, Dec 16, 2022 at 02:04:45AM -0500, Kent Overstreet wrote:
> On Thu, Dec 15, 2022 at 07:09:58PM -0500, Kent Overstreet wrote:
> > I do think we could probably be doing something more than using the pid for the
> > writepoint, I've just been waiting until we see specific workloads where the
> > current behaviour falls over or have a specific complaint before designing
> > something new.
> 
> Random late night thoughts:
> 
> Say we introduce a new object, 'writepoint_handle' or somesuch.
> 
> Allocate them when opening a file for write, close them when close the file.
> 
> Then we'd be explicitly picking which writepoint to use when allocating the
> writepoint_handle; it would be easy to add logic for "if there's a writepoint
> which was last used by this process and doesn't currently have any handles
> pointing to it, use that".
> 

Ok, but if we alloc the handle at open (or first write or whatever),
we'd still need to potentially keep it around after ->release() (i.e.
userspace close()) while the mapping is dirty and thus still needs to be
written back, right? 

If so, perhaps this would need some additional state to track an
"active" writepoint, explicitly defined as a "writepoint with currently
open files" as opposed to simply a handle pointer? IOW, if the task is
no longer writing to the previous file, it's probably Ok to reuse that
writepoint even though the handle might still have a reference..?

But generally I think I get the idea: preserve the current ability for a
single sequential writer to use the same writepoint across N files, but
fall back to a separate writepoint where we otherwise detect multi-file
activity. I think that makes sense, though I'd probably have to think a
bit more about an explicit open() -> close() handle lifecycle and
whether that's robust enough for fileserver like use cases. I.e., I'd be
a little concerned about whether that workload might make inter-spersed
sub-file writes look a bit too much like the single user open -> write
-> close -> repeat use case..

> One of the things that needs to be considered is - what do we do when there's
> more writepoint_handles than writepoints?
> 

Does bcachefs have to deal with something like that today? For example
if there is some max number of writepoints, what happens if there might
be some greater number of tasks doing allocations at the same time?

Brian

> bcache has some logic for this by tracking when a writepoint was used, and if we
> don't find a writepoint that matches up with the IO being issued - pick the
> oldest one off an LRU queue. Was dropped in bcachefs because the straight hash
> table seemed to work just as well and was faster - or maybe I'm thinking of the
> sequential bypass data structure?
> 

