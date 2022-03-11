Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881DFC433EF
	for <linux-bcachefs@archiver.kernel.org>; Fri, 11 Mar 2022 20:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351126AbiCKUXX (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 11 Mar 2022 15:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiCKUXV (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 11 Mar 2022 15:23:21 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248841AAFDF
        for <linux-bcachefs@vger.kernel.org>; Fri, 11 Mar 2022 12:22:18 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 50B9239;
        Fri, 11 Mar 2022 12:22:17 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id DiMjgWXwl2l1; Fri, 11 Mar 2022 12:22:16 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 5ED3681;
        Fri, 11 Mar 2022 12:22:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 5ED3681
Date:   Fri, 11 Mar 2022 12:22:14 -0800 (PST)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@gmail.com>
cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs: Kernel panic - not syncing: trans path oveflow
In-Reply-To: <20220311185655.idsjt7opl5stclu5@moria.home.lan>
Message-ID: <ca774415-6921-4776-5ef6-19712fed5fbc@ewheeler.net>
References: <6bc8aca6-2f93-4a81-376-13155fcc5d7@ewheeler.net> <YilZD2oxhUtFVCfu@moria.home.lan> <bc622d24-9fad-7b3-22cb-da4bf2dd32d@ewheeler.net> <20220311185655.idsjt7opl5stclu5@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Fri, 11 Mar 2022, Kent Overstreet wrote:

> On Thu, Mar 10, 2022 at 02:25:29PM -0800, Eric Wheeler wrote:
> > On Wed, 9 Mar 2022, Kent Overstreet wrote:
> > 
> > > On Wed, Mar 09, 2022 at 01:14:58PM -0800, Eric Wheeler wrote:
> > > > Hi Kent,
> > > > 
> > > > We just started testing bcachefs snapshots this week: we have a bunch of 
> > > > mysql replicas, each in its own subvolume.  Every 4 hours we stop mysql, 
> > > > run a subvolume snapshot and restart mysql, so it gets lots of snapshot 
> > > > and sync IO from the many database instances.
> > > 
> > > Cool! Would love to hear any comments you've got so far.
> >  
> > Happy to.  So far we've hit this bug...but once that is fixed I'm curious 
> > how it will compare to btrfs, which has just become too slow...
> 
> I think I've got a fix for this up - let me know if it works for you
> 

Thanks, we will!


--
Eric Wheeler


