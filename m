Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5EEC77B75
	for <linux-bcachefs@archiver.kernel.org>; Wed, 17 May 2023 06:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjEQGPe (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 17 May 2023 02:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbjEQGPc (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 17 May 2023 02:15:32 -0400
Received: from out-3.mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3276D122
        for <linux-bcachefs@vger.kernel.org>; Tue, 16 May 2023 23:15:31 -0700 (PDT)
Date:   Wed, 17 May 2023 02:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684304129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MFJInflfQUxOXuIi+2gKjPbl1C7u8nYILf6Mhjt2zGc=;
        b=VyE69bOjc56IhHBzIqMIs1plM4U4ThEmhEnimfYDGKlxYCXPAotfoAZWLOZCqxdkog57We
        aVzZqAa+GRqZ6C0ARb8K0v5tzXMDaqnaMed9zQMAA3MzAeMnFZ8Ol+gfr9arrkag44j33C
        QpKOxu4hyWpDaAPpapcHHWGqkXvq4hg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Josh Litherland <josh@temp123.org>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs fsck out-of-memory
Message-ID: <ZGRw/THnljDnveBS@moria.home.lan>
References: <CAKib_wKEnoF4=aFVhA5Sd0Edcyo6=RTs0i81ntADFogFezR=cg@mail.gmail.com>
 <ZFnV6wfafWPeuHDv@moria.home.lan>
 <CAKib_wLQPr0uFjThRrpzvvPmzKTUGB-H8f5F=3kkd_W2K+NayA@mail.gmail.com>
 <CAKib_wJyoUCKVtk=Xg6gzZmn-BptqCoogPrZCkU23RD45ScaGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKib_wJyoUCKVtk=Xg6gzZmn-BptqCoogPrZCkU23RD45ScaGQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, May 16, 2023 at 02:28:31PM -0400, Josh Litherland wrote:
> Is there any further diagnostic value to me leaving these drives in
> their current state?  I can, if you think it will help track down the
> fsck OOM issue.  But if not I'm going to wipe them and start fresh.

Yeah we just need to add a limit based on main memory size to the number
of dirty keys in the journal. Sorry for the OOM - I'll try to get a
proper fix for this in soon.
