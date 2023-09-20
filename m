Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C061ECE79A9
	for <linux-bcachefs@archiver.kernel.org>; Wed, 20 Sep 2023 01:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjITBV2 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 21:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjITBV2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 21:21:28 -0400
Received: from out-228.mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA869BD
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 18:21:21 -0700 (PDT)
Date:   Tue, 19 Sep 2023 21:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695172879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r8ynYOcsjwAnnV9McTaLVOen4fw0NAMm+hWl+udnmYY=;
        b=RBVIYh1b3bHSeZX4IH3lYaiPq3WXhaRW9av0MD4SHKrTv69/5tlElVScPslluLs51UxsIF
        U42Lc9tKHljGBz9Ijaz7RCB7VQ6R4Q9dI3vyu5O12KhLFAr57XyAjjbAsZv7X7RoBZdiOM
        6Hpwrp+mYHYbwQ89aWRIL4cxygJA8AU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] bcachefs: initial freeze/unfreeze support
Message-ID: <20230920012116.pi7nw5ziebrdffkq@moria.home.lan>
References: <20230915125154.307450-1-bfoster@redhat.com>
 <20230915125154.307450-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230915125154.307450-5-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Pulled this into the testing branch and then got

https://evilpiepirate.org/~testdashboard/c/de4ea1e2a9ceec5d55fffbc1acab89f0dc8f90b6/xfstests.generic.459/log.br

So I'll likely kick this patch back out for now, let me know when you
have a fixed version :)
