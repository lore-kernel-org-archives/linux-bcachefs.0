Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F1BEB64D9
	for <linux-bcachefs@archiver.kernel.org>; Thu, 15 Jun 2023 21:27:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjFOV07 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 15 Jun 2023 17:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjFOV07 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 15 Jun 2023 17:26:59 -0400
Received: from out-60.mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA352962
        for <linux-bcachefs@vger.kernel.org>; Thu, 15 Jun 2023 14:26:57 -0700 (PDT)
Date:   Thu, 15 Jun 2023 17:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686864415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vU5F4kweR0t8znRkWod5I7zwdc0+2wJs0+hMTJMidFM=;
        b=JWZWpSBDxhCSnLE66w1A2iWttUKaEJdWHRlSTalwvCUHDqAFvbHQXoehS8hIFbpqUbMgIs
        I6g2w5TPrWdjVPhKA70lwEL2luVN5STXfkw+OJ7WUIbCUpGJd/eQ3ikqneDOeQVRJNM6D2
        GXDhVF63Ul/Of6+zpb6+4USm1WhnyDY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        linux-bcachefs@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, boqun.feng@gmail.com,
        brauner@kernel.org, hch@infradead.org, colyli@suse.de,
        djwong@kernel.org, mingo@redhat.com, jack@suse.cz, axboe@kernel.dk,
        willy@infradead.org, ojeda@kernel.org, ming.lei@redhat.com,
        ndesaulniers@google.com, peterz@infradead.org,
        phillip@squashfs.org.uk, urezki@gmail.com, longman@redhat.com,
        will@kernel.org
Subject: Re: [PATCH 00/32] bcachefs - a new COW filesystem
Message-ID: <ZIuCFtmnFturKwex@moria.home.lan>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230615204156.GA1119@bug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615204156.GA1119@bug>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Jun 15, 2023 at 10:41:56PM +0200, Pavel Machek wrote:
> Hi!
> 
> > I'm submitting the bcachefs filesystem for review and inclusion.
> > 
> > Included in this patch series are all the non fs/bcachefs/ patches. The
> > entire tree, based on v6.3, may be found at:
> > 
> >   http://evilpiepirate.org/git/bcachefs.git bcachefs-for-upstream
> > 
> > ----------------------------------------------------------------
> > 
> > bcachefs overview, status:
> > 
> > Features:
> >  - too many to list
> > 
> > Known bugs:
> >  - too many to list
> 
> 
> Documentation: missing.

https://bcachefs.org/bcachefs-principles-of-operation.pdf

> Dunno. I guess it would help review if feature and known bugs lists were included.

https://evilpiepirate.org/~testdashboard/ci?branch=bcachefs

https://github.com/koverstreet/bcachefs/issues/

Hope that helps...
