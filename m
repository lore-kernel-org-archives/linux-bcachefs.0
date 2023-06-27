Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95B3EB64DD
	for <linux-bcachefs@archiver.kernel.org>; Tue, 27 Jun 2023 16:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjF0QYu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 27 Jun 2023 12:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjF0QYo (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 27 Jun 2023 12:24:44 -0400
Received: from out-34.mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E20D30DB
        for <linux-bcachefs@vger.kernel.org>; Tue, 27 Jun 2023 09:24:42 -0700 (PDT)
Date:   Tue, 27 Jun 2023 12:24:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687883080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=Q4aV2OrFE85KsWboNQG0tZuajBNz8EPdue5rE4nWrkQ=;
        b=d+PY6JPrFqh4plrJsp82rL64NTgUHndNDiiuX6XgCAV/tDOB4YiVIwHFF/LiwznItlVE4S
        WAo+06j/npWF8F5K918WvpNRBx148EGVoIomlavqH1MCFcVmK0d5t3cJSzmIbngOK0kxJE
        O9CxWI5/7PyzI1X3pFPYieNuADmrOd0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [biweekly bcachefs cabal]
Message-ID: <20230627162432.fkjuvpo5665hxqpz@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Every other Tuesday at 1 PM Eastern (i.e., in half an hour):

Email me if you'd like in invite
