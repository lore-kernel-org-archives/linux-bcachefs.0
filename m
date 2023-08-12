Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20F8C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 21:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjHLVvP (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 17:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjHLVvO (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 17:51:14 -0400
Received: from out-102.mta1.migadu.com (out-102.mta1.migadu.com [IPv6:2001:41d0:203:375::66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7896C1706
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:51:17 -0700 (PDT)
Date:   Sat, 12 Aug 2023 17:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691877074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6VVaEpV34P3Dj0rLd0Ta/UWckBRv1VN1Ju7XqsxIC4c=;
        b=VySgJkrpn3wOSDKbpjEsRyOsWzG67Sobibjd/68DwnOuQJ72cMpRTJbEH9uIH6/ZtPvawV
        kUcyekSUzc4ljqt6ob3p5VEfi1NamOEL0n0jWI1dZY5xJNEY1N+M1ZRo2EoChx4lUw5Mm1
        oyOv2JkrWMI3PU3thnpsqTZgjD2GT24=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [v2 1/3] bcachefs: Introduce bch2_dirent_get_name
Message-ID: <20230812215111.memibkgxfc3qscbf@moria.home.lan>
References: <20230812212647.490829-1-joshua@froggi.es>
 <20230812212647.490829-2-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230812212647.490829-2-joshua@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sat, Aug 12, 2023 at 10:26:29PM +0100, Joshua Ashton wrote:
> A nice cleanup that avoids a bunch of open-coding name/string usage
> around dirent usage.
> 
> Will be used by casefolding impl in future commits.
> 
> Signed-off-by: Joshua Ashton <joshua@froggi.es>

Applied
