Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA01EC77B75
	for <linux-bcachefs@archiver.kernel.org>; Wed, 17 May 2023 16:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjEQQBD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 17 May 2023 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjEQQAp (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 17 May 2023 12:00:45 -0400
Received: from out-20.mta1.migadu.com (out-20.mta1.migadu.com [IPv6:2001:41d0:203:375::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD19BA5DE
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 May 2023 09:00:05 -0700 (PDT)
Date:   Wed, 17 May 2023 11:59:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684339203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uj5Rjh+AN0r/Ht1trw7qzyL7wBHUsoOZQ8wgW5hbJew=;
        b=DKzUV2fMhLT8gizPcUiaWKOzbYxc5ECoXth7Jg+gW5iquDVvCug3k6eHhkGXh2VnHvbXsh
        WF7yrhikG1PJYZw7Vgi2IvcQJXxvUN+yQTvVEiCRi+ldsou1jQ5un2NZgJyqsC8Ff95uqE
        +hOLNw5zcm0cdTCRdL7KgsuYii08Ng8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        song@kernel.org
Subject: Re: [PATCH 07/32] mm: Bring back vmalloc_exec
Message-ID: <ZGT5/gBbh5kNYQgf@moria.home.lan>
References: <3508afc0-6f03-a971-e716-999a7373951f@wdc.com>
 <202305111525.67001E5C4@keescook>
 <ZF6Ibvi8U9B+mV1d@moria.home.lan>
 <202305161401.F1E3ACFAC@keescook>
 <ZGPzocRpSlg+4vgN@moria.home.lan>
 <ZGP54T0d89TMySsf@casper.infradead.org>
 <ZGRmC2Qhe6oAHPIm@moria.home.lan>
 <ZGTe6zFYL25fNwcw@kernel.org>
 <ZGTiI49s8+YjBxVX@moria.home.lan>
 <20230517154412.GC4967@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517154412.GC4967@kernel.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, May 17, 2023 at 06:44:12PM +0300, Mike Rapoport wrote:
> On Wed, May 17, 2023 at 10:18:11AM -0400, Kent Overstreet wrote:
> > On Wed, May 17, 2023 at 05:04:27PM +0300, Mike Rapoport wrote:
> > 
> > And I'm really curious why text_poke() is needed at all. Seems like we
> > could just use kmap_local() to create a temporary writeable mapping,
> 
> On 64 bit kmap_local_page() is aliased to page_address() and does not map
> anything. text_poke() is needed to actually create a temporary writable
> mapping without touching page tables in vmalloc and/or direct map.

Duh - thanks!
