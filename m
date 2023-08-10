Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14D5C41513
	for <linux-bcachefs@archiver.kernel.org>; Thu, 10 Aug 2023 15:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbjHJPBr (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 10 Aug 2023 11:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjHJPBq (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 10 Aug 2023 11:01:46 -0400
Received: from out-107.mta1.migadu.com (out-107.mta1.migadu.com [95.215.58.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A852694
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Aug 2023 08:01:45 -0700 (PDT)
Date:   Thu, 10 Aug 2023 11:01:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691679703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=be7nrxC8vFjnOsf8A6+wgRzYFhlkQMgRrz3nuis5HPU=;
        b=iZPeIIrqCrT1NrjO2avV2m3n/PQSRJQztwr/+9Ict7i1GeLCMJLZmEHWYpJ2P4WYCDix8A
        7xDjyrdqEXnH/RfCXGKuOJdRp3my6eiF+GhAevqX8dyKNkCwYdE0QrtZMH5EeNqsxq9qYj
        CETxGwnNWLULHeW4/zdr9cZWbUo8B+w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Linus Heckemann <git@sphalerite.org>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] cmd_mount: don't return 0 on mount failure
Message-ID: <20230810150136.gadrklxjakl6xjz3@moria.home.lan>
References: <20230810132225.796096-1-git@sphalerite.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230810132225.796096-1-git@sphalerite.org>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Aug 10, 2023 at 03:22:25PM +0200, Linus Heckemann wrote:
> Signed-off-by: Linus Heckemann <git@sphalerite.org>
> ---
>  bcachefs.c                | 3 +--
>  cmds.h                    | 2 +-
>  rust-src/src/cmd_mount.rs | 6 ++++--
>  3 files changed, 6 insertions(+), 5 deletions(-)

Thanks! Applied.
