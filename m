Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C61C001B0
	for <linux-bcachefs@archiver.kernel.org>; Sun, 13 Aug 2023 15:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjHMPr4 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 13 Aug 2023 11:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjHMPr4 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 13 Aug 2023 11:47:56 -0400
Received: from out-83.mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BA3E63
        for <linux-bcachefs@vger.kernel.org>; Sun, 13 Aug 2023 08:47:57 -0700 (PDT)
Date:   Sun, 13 Aug 2023 11:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691941676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z5tumwVPJWInA9jnK95qIuJtiyPQHOrQt+sY7DtSDI8=;
        b=nBauH/ZHY16SrK95EcgjXdrrJqi5R8Cf0tCgQ7g+JWJIlmva9Sk62UhmZRJ1C1EclrTrtE
        4PBP0CCj+EvDBHr6gzTm1tNw9HWLXUSK3ru/mqAzsa3DXWUgUU32KN+Z88RaBF5Radh2CY
        j1M76zvnqrLdBy2STm94X1GdgtIawgs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joshua Ashton <joshua@froggi.es>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [v2] bcachefs: Lower BCH_NAME_MAX to 512
Message-ID: <20230813154754.acqqirhqufqhy7ga@moria.home.lan>
References: <20230813153427.106834-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813153427.106834-1-joshua@froggi.es>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Aug 13, 2023 at 04:34:22PM +0100, Joshua Ashton wrote:
> To ensure we aren't shooting ourselves in the foot after merge for
> potentially doing future revisions for dirent or for storing multiple
> names for casefolding, limit this to 512 for now.
> 
> Previously this define was linked to the max size a d_name in
> bch_dirent could be.
> 
> Signed-off-by: Joshua Ashton <joshua@froggi.es>

Applied :)
