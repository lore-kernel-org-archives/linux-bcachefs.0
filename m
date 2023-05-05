Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E396FC77B75
	for <linux-bcachefs@archiver.kernel.org>; Fri,  5 May 2023 13:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjEENt2 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 5 May 2023 09:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbjEENt1 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 5 May 2023 09:49:27 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDD5AB
        for <linux-bcachefs@vger.kernel.org>; Fri,  5 May 2023 06:49:26 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-74de7182043so83507485a.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 05 May 2023 06:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=temp123.org; s=google; t=1683294565; x=1685886565;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+Ur4RPcmdTPOCXhLZ5H2CDimkodlWJcVvzPjOcJVJp8=;
        b=IhH0ib4x/49xiIOlzh6uTtFSVipWcVpxIfdec/y96KyHm1w+2CFFG4kmuQuwUqmhPc
         fPYyNq17MLeHG9EQnOMFLezckRc84nvyITgBzVzCB6ueRszw695XQ4NFPTTuSeRNN7hz
         EoMUYNQRLuQ1DgcafhGJC3aatTKVXQOn1SCx4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683294565; x=1685886565;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Ur4RPcmdTPOCXhLZ5H2CDimkodlWJcVvzPjOcJVJp8=;
        b=MIUMt3VEz2yXqqYwdXIo+2F5T7UfqICuIuW61qxp2PKnwbq3Wq6c9ugh2ap9Rug3Hp
         rJ006k70E6aHG0nrgn4sq/P1OYWYVYVR+sEASBzAbJ2uM4MuycFqvSwBGLs1QJb5Emxl
         aGSXGpLwrR7qxMKXUp6wZk3KwfRAB0DG+LKrQn6BwCKuOuhU6c2gxWluT355iXQJIAno
         lN/GQyJudGM8Nn5+2mUKOr5TuI/oQ0QrPeMcBh5yeXYYSkzk9abQvWtI0AlU+QPEWBR8
         C6J00CYzU8p9E3KmdJul+xsHmJ8xGb9N5cyKIn1spp9FQC1oMh28frrmn8jqxbzwk+vg
         4Z4Q==
X-Gm-Message-State: AC+VfDyIQPQb4xHMJeEIX+9G5tM0jQhsDTdCRN0Mx0aA1jqmHdPU4Los
        W6e7afQiYLvlAiy3CHdcShd/kVI+PUAObuB5QuLZAN+Vx35m/XWbxaF0mg==
X-Google-Smtp-Source: ACHHUZ6mymIeOkRDp6EcOQLtNk8ccCwUQqukNMwBKRcKvrkNUph8NxtaZgoqmFmeey9rLz8PxkILAYlFCrTPNn1agvk=
X-Received: by 2002:a05:6214:20e7:b0:5e8:e6ac:594e with SMTP id
 7-20020a05621420e700b005e8e6ac594emr1726139qvk.29.1683294565515; Fri, 05 May
 2023 06:49:25 -0700 (PDT)
MIME-Version: 1.0
From:   Josh Litherland <josh@temp123.org>
Date:   Fri, 5 May 2023 09:49:14 -0400
Message-ID: <CAKib_wKEnoF4=aFVhA5Sd0Edcyo6=RTs0i81ntADFogFezR=cg@mail.gmail.com>
Subject: bcachefs fsck out-of-memory
To:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

I have a largeish filesystem (4x16TB + 2x2TB) which was uncleanly shut
down.  I am attempting to do an fsck repair, and consistently hitting
the OOM killer (approximately 64GiB RAM in use) with the userspace
fsck repair tool.  The in-kernel repair runs for a while and
eventually stops doing any IO while the mount command hangs, so I
assume it's hitting the same condition.

Kernel is 6.3.0-bcachefs-ccc8737427a3.
bcachefs-tools is revision 6b1f79d5df9f2735192ed1a40c711cf131d4f43e.

Please let me know if there is any information I can provide that
might help to debug this issue, or any other repair techniques I can
try out.  I have a recent backup of the data, and I'm not in a
particular hurry to wipe and reformat the drives.

-- 
Josh Litherland (josh@temp123.org)
