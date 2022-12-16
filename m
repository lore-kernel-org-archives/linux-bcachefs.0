Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149E9C4332F
	for <linux-bcachefs@archiver.kernel.org>; Fri, 16 Dec 2022 07:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiLPHEx (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 16 Dec 2022 02:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiLPHEv (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 16 Dec 2022 02:04:51 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392A550D54
        for <linux-bcachefs@vger.kernel.org>; Thu, 15 Dec 2022 23:04:50 -0800 (PST)
Date:   Fri, 16 Dec 2022 02:04:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1671174288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hox/faCL7V/Kg9rgEJFJO4cFZy2Tm68qfWWxug5KkYg=;
        b=kX11ctkG057ugKfrlplxUXq7dUIfsQnD4esvzjyvmNxU5rGHS0krrwVBXlcMJKUD1wwRZp
        cqqfTh7kf/SopD314ziWtU56RkAo+ONvAvwPQqWTjsXwVqV8r60zKN6pbpRYnkRq4j5zrK
        vOlZsZipf5TUrM2SJgu6rJpZ9VG9QNQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC] bcachefs: use inode as write point index instead of
 task
Message-ID: <Y5wYjUhTAzhSIvM3@moria.home.lan>
References: <20221212190602.1388127-1-bfoster@redhat.com>
 <20221213183743.3m6ntfnu7n3yebng@moria.home.lan>
 <Y5oLlLcHmS2EWp8n@bfoster>
 <Y5u3VlkA3AbhQKav@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5u3VlkA3AbhQKav@moria.home.lan>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Dec 15, 2022 at 07:09:58PM -0500, Kent Overstreet wrote:
> I do think we could probably be doing something more than using the pid for the
> writepoint, I've just been waiting until we see specific workloads where the
> current behaviour falls over or have a specific complaint before designing
> something new.

Random late night thoughts:

Say we introduce a new object, 'writepoint_handle' or somesuch.

Allocate them when opening a file for write, close them when close the file.

Then we'd be explicitly picking which writepoint to use when allocating the
writepoint_handle; it would be easy to add logic for "if there's a writepoint
which was last used by this process and doesn't currently have any handles
pointing to it, use that".

One of the things that needs to be considered is - what do we do when there's
more writepoint_handles than writepoints?

bcache has some logic for this by tracking when a writepoint was used, and if we
don't find a writepoint that matches up with the IO being issued - pick the
oldest one off an LRU queue. Was dropped in bcachefs because the straight hash
table seemed to work just as well and was faster - or maybe I'm thinking of the
sequential bypass data structure?
