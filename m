Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4B9C10F19
	for <linux-bcachefs@archiver.kernel.org>; Wed, 16 Aug 2023 19:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345606AbjHPTkq (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345849AbjHPTkW (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 16 Aug 2023 15:40:22 -0400
Received: from out-34.mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8661FF3
        for <linux-bcachefs@vger.kernel.org>; Wed, 16 Aug 2023 12:40:20 -0700 (PDT)
Date:   Wed, 16 Aug 2023 15:40:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1692214818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nXdSoc7XdvAT2WHKkF30oZTMbYrUiFWpdhZz59LrgnQ=;
        b=nEXMBNJQuF5KpTR2CcXFV+3xynlUoKWxMjwntPo/j3RplZnLOYhEHAP27De/F+ACW93QWv
        swQHi6PdMFr7k/PCaj5FWM1lpNZaJVFOUv4yFCzuyw4UTYQsMrPLFGKQ1VJX/D8SLZx2wS
        mlOA48MeVy+3g3YHzpZHqXuRJ93faQU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [v4 0/3] bcachefs: Casefolding implementation
Message-ID: <20230816194014.guhw6afyvix3kvpn@moria.home.lan>
References: <20230814012434.627641-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230814012434.627641-1-joshua@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Mon, Aug 14, 2023 at 02:24:24AM +0100, Joshua Ashton wrote:
> This implements support for case-insensitive file and directory
> lookups using the regular `chattr +F` (`S_CASEFOLD`, `FS_CASEFOLD_FL`)
> casefolding attributes for bcachefs.
> 
> The implementation uses the same UTF-8 lowering and normalization that
> ext4 and f2fs is using currently
> 
> The main usecase for casefolding is compatibility with software written
> against other filesystems that rely on casefolded lookups
> (eg. NTFS and Wine/Proton).
> Taking advantage of file-system level casefolding can lead to great
> loading time gains in many applications and games.
> 
> See more information and rationale in:
> Documentation/filesystems/bcachefs/casefolding.rst
> 
> You can see/review the work in my tree here:
> https://github.com/Joshua-Ashton/bcachefs/tree/casefold
> 
> v2: Update format to store length in dirent based on flag, add comments, cleanup
> dirent_create_key, other misc. nits from IRC.
> 
> v3: Cleanup the dirent code, utilize the fact that BCH_NAME_MAX is smaller now,
> remove fallbacks for too big keys that won't make sense anymore. Improved
> lookup string lowering.
> 
> v4: Move cf_name allocation from stack to trans alloc, validated bkey in invalid,
> used length directly, misc. nits.

Josh, do you think you could post the benchmarks you ran at the start of
all this? We should look at those again after negative dentries are
hooked up and working correctly.

After giving this more thought, I'm starting to feel a bit more inclined
to Gabriel's approach...
